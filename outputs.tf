
# Lokale Hilfsvariablen für Zugriff auf die einzelnen Maschinen aus der map
locals {

  development_ip   = terraform.workspace != "lernmaas" ? try(module.vms.ip_vm["dev"], null) : null
  development_fqdn = terraform.workspace != "lernmaas" ? try(module.vms.fqdn_vm["dev"], null) : null

  build_ip   = terraform.workspace != "lernmaas" ? try(module.vms.ip_vm["build"], null) : null
  build_fqdn = terraform.workspace != "lernmaas" ? try(module.vms.fqdn_vm["build"], null) : null

  controlplane_ip      = terraform.workspace != "lernmaas" ? try(module.vms.ip_vm["controlplane-01"], null) : null
  controlplane_fqdn    = terraform.workspace != "lernmaas" ? try(module.vms.fqdn_vm["controlplane-01"], null) : null
  controlplane_private = terraform.workspace != "lernmaas" ? try(module.vms.fqdn_private["controlplane-01"], null) : null
  worker_01_ip         = terraform.workspace != "lernmaas" ? try(module.vms.ip_vm["worker-01"], null) : null
  worker_01_fqdn       = terraform.workspace != "lernmaas" ? try(module.vms.fqdn_vm["worker-01"], null) : null
  worker_01_private    = terraform.workspace != "lernmaas" ? try(module.vms.fqdn_private["worker-01"], null) : null
  worker_02_ip         = terraform.workspace != "lernmaas" ? try(module.vms.ip_vm["worker-02"], null) : null
  worker_02_fqdn       = terraform.workspace != "lernmaas" ? try(module.vms.fqdn_vm["worker-02"], null) : null
  worker_02_private    = terraform.workspace != "lernmaas" ? try(module.vms.fqdn_private["worker-02"], null) : null
}

# Generiere README aus INTRO.md Template
output "README" {
  value = terraform.workspace != "lernmaas" ? templatefile("INTRO.md", {

    development_ip   = local.development_ip,
    development_fqdn = local.development_fqdn,

    build_ip   = local.build_ip,
    build_fqdn = local.build_fqdn,

    ip           = local.controlplane_ip,
    fqdn         = local.controlplane_fqdn,
    fqdn_private = local.controlplane_private,

    worker_01_ip      = local.worker_01_ip,
    worker_01_fqdn    = local.worker_01_fqdn,
    worker_01_private = local.worker_01_private,

    worker_02_ip      = local.worker_02_ip,
    worker_02_fqdn    = local.worker_02_fqdn,
    worker_02_private = local.worker_02_private,
  }) : null
}

#########################
# nur Workspace lernmaas

locals {
  controlplane_keys = local.is_lernmaas ? [
    for k in keys(module.vms.fqdn_vm) : k if can(regex("^controlplane-01-", k))
  ] : ["controlplane-01"]
  
  controlplane_list = local.is_lernmaas ? [
    for k, v in module.vms.fqdn_vm : v if can(regex("^controlplane-01-", k))
  ] : [try(module.vms.fqdn_vm["controlplane-01"], null)]

  worker_01_list = local.is_lernmaas ? [
    for k, v in module.vms.fqdn_vm : v if can(regex("^worker-01-", k))
  ] : [try(module.vms.fqdn_vm["worker-01"], null)]

  worker_02_list = local.is_lernmaas ? [
    for k, v in module.vms.fqdn_vm : v if can(regex("^worker-02-", k))
  ] : [try(module.vms.fqdn_vm["worker-02"], null)]  

  development_list = local.is_lernmaas ? [
    for k, v in module.vms.fqdn_vm : v if can(regex("^dev-", k))
  ] : [try(module.vms.fqdn_vm["dev"], null)] 
  
  build_list = local.is_lernmaas ? [
    for k, v in module.vms.fqdn_vm : v if can(regex("^build-", k))
  ] : [try(module.vms.fqdn_vm["build"], null)]     
}

output "README_lernmaas" {
  value = terraform.workspace != "lernmaas" ? null : templatefile("INTRO_lernmaas.md", {
    controlplanes = local.controlplane_list,
    worker1s      = local.worker_01_list,
    worker2s      = local.worker_02_list
    devs          = local.development_list
    builds        = local.build_list
  })
}

