# WireGuard-basierte Lernumgebung mit KubeVirt

## 0. Quick Start

**VMs in Kubernetes erstellen**

Installation

    helm install lab . -n m346-ap21a --create-namespace
    
Kontrolle

    kubectl get sa,job,secrets,pvc,vmi -n m346-ap21a
    
Löschen

    helm uninstall lab -n m346-ap21a && kubectl delete ns m346-ap21a    
    
Testen

    virtctl console -n m346-ap21a vm-0  

**Client Zugriff**

Client Zugriff mittels erstellen Client (Public) Key und WireGuard Konfigurationdatei erlauben

    ./wg-client-config.sh 201 m346-ap21a 192.168.1.36
    
Testen

    ssh -i ~/.ssh/lerncloud debian@10.10.0.10    
    
Client Zugriff wieder entziehen

    kubectl delete secret client-201 -n m346-ap21a
    
---

## 1. Zielsetzung

Bereitstellung einer **isolierten, skalierbaren Lernumgebung** pro Modul/Klasse, in der:

* jede VM automatisch einen **eigenen WireGuard-Key** erhält
* externe Clients (LE, Admins) **sicher von ausserhalb** zugreifen können
* **keine manuellen Konfigurationsschritte** im Cluster nötig sind
* Zugriffe **dynamisch aktiviert/deaktiviert** werden können

---

## 2. Gesamtübersicht (logisch)

```
┌───────────────────────────┐
│        Externer Client     │
│  (LE / Admin / Laptop)     │
│                             │
│  WireGuard Client           │
│  PrivateKey (lokal)         │
└─────────────┬─────────────┘
              │ UDP/31820
              ▼
┌──────────────────────────────────────────┐
│ Kubernetes Node                           │
│                                          │
│  NodePort Service (wg-gateway)            │
│  UDP 31820 → 51820                        │
│                                          │
│  ┌────────────────────────────────────┐  │
│  │ WireGuard Gateway Pod               │  │
│  │                                    │  │
│  │  wg0 Interface                     │  │
│  │  PrivateKey (lokal im Pod)          │  │
│  │                                    │  │
│  │  controller.sh                     │  │
│  │  - liest Secrets                   │  │
│  │  - synchronisiert WG-Peers         │  │
│  └───────────────┬────────────────────┘  │
│                  │                         │
│                  │ kubectl get secrets     │
│                  ▼                         │
│        Kubernetes Secrets (Namespace)      │
│        ──────────────────────────────      │
│        vm-0                     │
│        vm-1                     │
│        external-client-admin               │
│        └─ publickey                        │
│        └─ userData (cloud-init)            │
└──────────────────┬────────────────────────┘
                   │
                   │ virtio / cloud-init
                   ▼
┌──────────────────────────────────────────┐
│ KubeVirt VM (Studenten-VM)                │
│                                          │
│  cloud-init                               │
│  - erzeugt /etc/wireguard/wg0.conf        │
│  - enthält PrivateKey (nur in VM)         │
│                                          │
│  WireGuard wg0                            │
│  IP: 10.10.0.x                            │
└──────────────────────────────────────────┘
```

---

## 3. Zentrale Komponenten

### 3.1 WireGuard Gateway

* läuft als **privilegierter Pod**
* hält **keine Client-PrivateKeys**
* kennt **nur PublicKeys**
* synchronisiert Peers **dynamisch**

**Aufgaben:**

* Terminierung aller VPN-Verbindungen
* Routing zwischen externen Clients und VMs
* Automatisches Hinzufügen/Entfernen von Peers

---

### 3.2 Keygen Job

* läuft **einmalig pro Helm-Deployment**
* erzeugt pro VM:

  * PrivateKey (nur für VM)
  * PublicKey (für Gateway)
* erstellt Kubernetes Secrets:

  * `vm-<n>`

**Wichtig:**

* PrivateKeys verlassen **nie** die VM
* PublicKeys sind **die einzige Quelle** für Peer-Management

---

### 3.3 Kubernetes Secrets = Desired State

Jedes Secret repräsentiert **einen WireGuard-Peer**.

Beispiel:

```
Secret: vm-0
  ├─ publickey   → Gateway liest diesen
  └─ userData    → VM nutzt diesen
```

**Regel:**

> Existiert ein Secret → Peer ist erlaubt
> Wird ein Secret gelöscht → Peer wird entfernt

---

### 3.4 Controller (`controller.sh`)

* läuft dauerhaft im Gateway-Pod
* arbeitet **polling-basiert**
* kein Custom Controller, kein CRD

**Algorithmus (vereinfacht):**

```
loop alle 15s:
  secrets = kubectl get secrets
  desired_keys = secrets.publickey
  current_keys = wg show peers

  add peers, die fehlen
  remove peers, die nicht mehr existieren
```

---

## 4. Netzwerkdesign

| Netz           | Zweck             |
| -------------- | ----------------- |
| `10.10.0.0/24` | WireGuard Overlay |
| `10.10.0.1`    | Gateway           |
| `10.10.0.10+`  | VMs               |
| `10.10.0.250`  | Externe Clients   |

---

## 5. Sicherheitsprinzipien

* **PrivateKeys bleiben immer beim Besitzer**

  * VM-Keys nur in der VM
  * Client-Keys nur auf dem Client
* Gateway sieht **ausschliesslich PublicKeys**
* Zugriff wird **durch Secret-Existenz** gesteuert
* Sofortiger Widerruf durch `kubectl delete secret`

---

## 6. Typischer Ablauf (End-to-End)

1. Helm installiert Namespace + Ressourcen
2. Keygen Job erzeugt Secrets
3. VMs booten und konfigurieren WG per cloud-init
4. Gateway-Controller liest Secrets
5. Peers werden automatisch konfiguriert
6. Externer Client verbindet sich per NodePort
7. Zugriff auf VMs ist möglich

---

## 7. Didaktische Einordnung (SEUSAG)

* klare Trennung von:

  * **Infrastruktur**
  * **Automatisierung**
  * **Security**
* gut geeignet für:

  * M346 / M347 / M183
  * Netzwerke, VPN, Cloud-Grundlagen
* Architektur ist:

  * transparent
  * reproduzierbar
  * realitätsnah

---

## 8. Kernaussage

> **Kubernetes Secrets definieren den gewünschten VPN-Zustand,
> der WireGuard-Controller setzt ihn automatisch um.**

---

    