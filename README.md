# Beispiele zum Kurs: [Kubernetes 2-Day Operations mit CNCF ](https://www.digicomp.ch/d/k8sd2o)

Erkunden Sie im Kurs das CNCF-Ökosystem rund um Kubernetes. Lernen Sie in zwei Tagen, wie Sie durch den Einsatz ausgesuchter CNCF-Projekte Ihre Kubernetes-Infrastruktur und Ihre Microservices sicherer, effizienter und nachhaltiger betreiben können.

### Lernziele

* Verstehen der Herausforderungen und Aufgaben von Kubernetes Day-2-Operations
* Erwerben der Fähigkeit zur strukturierten Analyse von Betriebsaspekten in Kubernetes
* Kennen von zentralen CNCF.io-Projekten zur Lösung typischer Aufgaben im Betrieb
* Anwenden der Tools auf reale Szenarien anhand eines durchgängigen Fallbeispiels
* Entwickeln eines Tool-Stacks für produktive Kubernetes-Umgebungen

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