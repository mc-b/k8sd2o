Kubernetes 2-Day Operations mit CNCF
====================================

Umgebung zum Kurs: [Kubernetes 2-Day Operations mit CNCF ](https://www.digicomp.ch/d/k8sd2o).

Dashboard bzw. neu Headlamp
---------------------------

Das Kubernetes Dashboard/Headlamp ist wie folgt erreichbar:

    https://${fqdn}:30443
    http://${fqdn}:30444
    
Zugriffstoken für Headlamp erstellen:

    kubectl create token Headlamp-admin -n kube-system   

Beispiele
---------

Die Umgebung beinhaltet eine Vielzahl von Beispielen als Juypter Notebooks. Die Jupyter Lab Oberfläche ist wie folgt erreichbar:

    http://${fqdn}:32188/lab/tree/k8sd2o
