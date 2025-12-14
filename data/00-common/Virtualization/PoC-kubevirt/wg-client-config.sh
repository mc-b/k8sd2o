#!/usr/bin/env bash
set -euo pipefail

### =========================
### PARAMETER
### =========================

if [ "$#" -ne 3 ]; then
  echo "Usage: $0 <HOST_ID> <K8S_NAMESPACE> <WG_ENDPOINT_NODE>"
  echo "Example: $0 201 m01 cloud.tbz.ch"
  exit 1
fi

HOST_ID="$1"              # z.B. 201
K8S_NS="$2"               # z.B. m01
WG_ENDPOINT_NODE="$3"     # z.B. 192.168.1.36

### =========================
### KONSTANTEN
### =========================

WG_IF="wg0"
WG_PORT="31820"           # NodePort
WG_NET="10.10.0.0/24"
CLIENT_IP="10.10.0.${HOST_ID}/32"
SECRET_NAME="client-${HOST_ID}"

### =========================
### CHECKS
### =========================

command -v wg >/dev/null || { echo "wg fehlt"; exit 1; }
command -v kubectl >/dev/null || { echo "kubectl fehlt"; exit 1; }

### =========================
### KEYS ERZEUGEN
### =========================

CLIENT_PRIV="$(wg genkey)"
CLIENT_PUB="$(printf "%s" "$CLIENT_PRIV" | wg pubkey)"

### =========================
### CLIENT IM CLUSTER REGISTRIEREN
### =========================

kubectl create secret generic "${SECRET_NAME}" \
  -n "${K8S_NS}" \
  --from-literal=publickey="${CLIENT_PUB}" \
  --dry-run=client -o yaml | kubectl apply -f -

### =========================
### GATEWAY PUBLIC KEY HOLEN
### =========================

GW_PUB="$(kubectl get secret wg-gateway-pub -n "${K8S_NS}" \
  -o jsonpath='{.data.publickey}' | base64 -d)"

### =========================
### AUSGABE DER WG-KONFIG
### =========================

cat <<EOF
# =========================================
# WireGuard Client Konfiguration
# Namespace: ${K8S_NS}
# Secret:    ${SECRET_NAME}
# Client IP: ${CLIENT_IP}
# =========================================

# Client PublicKey (zur Referenz):
# ${CLIENT_PUB}

[Interface]
PrivateKey = ${CLIENT_PRIV}
Address = ${CLIENT_IP}

[Peer]
PublicKey = ${GW_PUB}
Endpoint = ${WG_ENDPOINT_NODE}:${WG_PORT}
AllowedIPs = ${WG_NET}
PersistentKeepalive = 25
EOF
