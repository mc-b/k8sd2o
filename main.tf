
# K8s Cluster
module "vms" {
  source = local.selected_source

  machines = {
    # Development 
    "dev" = {
      hostname = "dev"
      userdata = templatefile("${path.root}/cloud-init-development.yaml", {})
    },
    # Build CI/CD
    "build" = {
      hostname = "build"
      userdata = templatefile("${path.root}/cloud-init-build.yaml", {})
    },
    # Production
    "controlplane-01" = {
      hostname    = "control"
      description = "Kubernetes Control Plane Node"
      userdata = templatefile("${path.root}/cloud-init-controlplane.yaml", {
        INSTALL_CERT_MANAGER = var.install_cert_manager
        INSTALL_KUBEVIRT     = var.install_kubevirt
        INSTALL_LONGHORN     = var.install_longhorn
        INSTALL_ISTIO        = var.install_istio
        INSTALL_KNATIVE      = var.install_knative
        INSTALL_ARGOCD       = var.install_argocd
        INSTALL_IIOT         = var.install_iiot

      })
    },
    "worker-01" = {
      hostname = "worker1"
      userdata = templatefile("${path.root}/cloud-init-worker.yaml", {})
    },
    "worker-02" = {
      hostname = "worker2"
      userdata = templatefile("${path.root}/cloud-init-worker.yaml", {})
    }
  }

  description = "Kubernetes Nodes"
  memory      = 6
  cores       = 4
  storage     = 48

  ports = [22, 80, 443, 16443]

  # MAAS: URL MAAS, Azure: Resource Group, Google: Project-Id
  url = var.url
  # MAAS: API-Key, Azure: Subscription-Id
  key = var.key
  # MAAS: optionales WireGuard VPN
  vpn = var.vpn
}



