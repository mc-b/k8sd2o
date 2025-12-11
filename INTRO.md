Kubernetes 2-Day Operations mit CNCF 
====================================

Umgebung zum Kurs: [Kubernetes 2-Day Operations mit CNCF ](https://www.digicomp.ch/d/k8sd2o).
   
SSH Access
----------

Development: 
    ssh -i ~/.ssh/lerncloud ubuntu@${development_fqdn}
    
Build (CI/CD): 
    ssh -i ~/.ssh/lerncloud ubuntu@${build_fqdn}

Production (Control-Plane und Worker-Nodes):
    ssh -i ~/.ssh/lerncloud ubuntu@${fqdn}
    ssh -i ~/.ssh/lerncloud ubuntu@${worker_01_fqdn}
    ssh -i ~/.ssh/lerncloud ubuntu@${worker_02_fqdn}   
    
Services
--------

Development:
- http://${development_fqdn}:32188/tree/k8sd2o/data/01-dev/README.ipynb - Beispiele Infrastruktur (Jupyter Notebooks)
- https://${development_fqdn}:30443                                - Kubernetes Dashboard (kein Token notwendig, Überspringen drücken)
- https://${development_fqdn}:4200                                 - Terminal im Browser. User: ubuntu, Password insecure
- http://${development_fqdn}:7500                                  - FRP (Fast Reverse Proxy). User: admin, Password insecure

Build (CI/CD):
- http://${build_fqdn}:32188/tree/k8sd2o/data/02-build/README.ipynb  - Beispiele Infrastruktur (Jupyter Notebooks)
- http://${build_fqdn}                                          - Gitlab CE 
- https://${build_fqdn}:30443                                   - Kubernetes Dashboard (kein Token notwendig, Überspringen drücken)
- https://${build_fqdn}:4200                                    - Terminal im Browser. User: ubuntu, Password insecure

Production:
- http://${fqdn}:32188/tree/k8sd2o/data/03-prod/README.ipynb - Beispiele Infrastruktur (Jupyter Notebooks)
- https://${fqdn}:30443                                 - Kubernetes Dashboard (kein Token notwendig, Überspringen drücken)
- https://${fqdn}:4200                                  - Terminal im Browser. User: ubuntu, Password insecure

