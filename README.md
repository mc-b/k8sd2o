# Beispiele zum Kurs: [Souveräne Cloud mit Kubernetes](https://www.digicomp.ch/d/k8sd2o)

Lerne, wie du Kubernetes und das Cloud-Native-Ökosystem nutzt. Blicke hinter OpenShift oder SUSE und erfahre, wie Cloud-Dienste aufgebaut sind. Dabei stehen Cloud-Souveränität, offene Standards und die Kontrolle über deine Daten im Mittelpunkt.

### Lernziele

* Beurteilen der Grundlagen einer souveränen Cloud
* Abbilden typischer Cloud-Services auf Kubernetes
* Umsetzen von IaaS-, PaaS-, SaaS- und FaaS-Diensten mit Cloud-Native-Technologien
* Einsetzen von Kubernetes als gemeinsame API für Infrastruktur- und Plattformdienste
* Fachliches Beurteilen und gezieltes Ergänzen integrierter Kubernetes-Plattformen
* Erkennen und Reduzieren von Abhängigkeiten von proprietären Cloud-Services und Distributionen
* Auswählen geeigneter Open-Source- und Cloud-Native-Projekte (CNCF) für eine Cloud-Plattform

### Quick Start

Installiert [Git/Bash](https://git-scm.com/downloads), [Multipass](https://multipass.run/) und [Terraform](https://www.terraform.io/).

Git/Bash Kommandozeile (CLI) starten und dieses Repository clonen.

    git clone https://github.com/mc-b/k8sd2o
    cd k8sd2o
    
Terraform Initialisieren und VMs erstellen

    terraform init
    terraform apply
    
Terraform verwendet [Multipass](https://multipass.run/) um mehrere VMs zu erstellen.

Nach erfolgreicher Installation werden weitere Informationen für den Zugriff auf die VMs angezeigt.

### Beispiele und Übungen

* [01 Development](data/01-dev/)
* [02 Build](data/02-build/)
* [03 Production](data/03-prod/)

* [Auto Shop GmbH – Übersicht](https://gitlab.com/ch-mc-b/autoshop-ms)
* [IoT Kit M5stack](https://github.com/mc-b/iotkitm5)

### Lizenz (Attribution-NonCommercial-ShareAlike 4.0 International)

![](http://www.creativecommons.ch/wp-content/uploads/2014/03/by-nc-sa1.png)

Quelle [Creative Commons](https://creativecommons.org/licenses/by-nc-sa/4.0/deed.de)

- - -

* Name muss genannt werden
* keine kommerzielle Nutzung erlaubt
* gleiche Lizenz vorgeschrieben

* Copyright (c) Marcel Bernet, Zürich