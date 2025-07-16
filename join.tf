
# Join Cluster

locals {
  is_lernmaas = terraform.workspace == "lernmaas"
  target_host = local.is_lernmaas ? "localhost" : try(module.vms.fqdn_vm["controlplane-01"], "localhost")
}

resource "local_file" "join_script" {
  count = local.is_lernmaas ? 0 : 1

  content = terraform.workspace != "lernmaas" ? templatefile("${path.module}/join.sh.tmpl", {
    controlplane = local.controlplane_private
    worker1      = local.worker_01_private
    worker2      = local.worker_02_private
  }) : ""

  filename        = "${path.module}/join.sh"
  file_permission = "0755"
}

resource "null_resource" "join_cluster" {
  count = local.is_lernmaas ? 0 : 1

  depends_on = [
    local_file.join_script
  ]

  provisioner "local-exec" {
    interpreter = ["bash", "-c"]
    command     = <<EOT
      echo "[+] Warte auf SSH-Verfügbarkeit auf der Controlplane ${local.target_host} ..."
      sleep 60
      for i in {1..240}; do
        ssh -o BatchMode=yes -o ConnectTimeout=5 -o StrictHostKeyChecking=no \
            -o UserKnownHostsFile=/dev/null -i ~/.ssh/lerncloud \
            ubuntu@${local.target_host} true >/dev/null 2>&1 && break
        sleep 5
      done
      echo "[+] SSH Verbindung steht, kopiere join.sh to ${local.target_host}"
      scp -o StrictHostKeyChecking=no -o UserKnownHostsFile=/dev/null \
          -i ~/.ssh/lerncloud join.sh ubuntu@${local.target_host}:join.sh
EOT
  }
}
#########################
# nur workspace lernmaas

resource "local_file" "join_script_lernmaas" {
  count = local.is_lernmaas ? length(local.controlplane_list) : 0

  content = templatefile("${path.module}/join.sh.tmpl", {
    controlplane = local.controlplane_list[count.index]
    worker1      = local.worker_01_list[count.index]
    worker2      = local.worker_02_list[count.index]
  })

  filename        = "${path.module}/join-${count.index + 1}.sh"
  file_permission = "0755"
}

resource "null_resource" "join_cluster_lernmaas" {
  count = local.is_lernmaas ? length(local.controlplane_list) : 0

  depends_on = [local_file.join_script_lernmaas]

  provisioner "local-exec" {
    interpreter = ["bash", "-c"]

    command = <<EOT
      echo "[+] Warte auf SSH-Verfügbarkeit auf ${local.controlplane_list[count.index]}..."
      for i in {1..400}; do
        ssh -o BatchMode=yes -o ConnectTimeout=5 -o StrictHostKeyChecking=no -o UserKnownHostsFile=/dev/null -i ~/.ssh/lerncloud ubuntu@${local.controlplane_list[count.index]} "echo 'SSH OK'" && break || echo "SSH noch nicht verfügbar, versuche erneut..." && sleep 5
      done
      echo "[+] SSH Verbindung steht, kopiere join-${count.index + 1}.sh..."
      scp -o StrictHostKeyChecking=no -o UserKnownHostsFile=/dev/null -i ~/.ssh/lerncloud ${path.module}/join-${count.index + 1}.sh ubuntu@${local.controlplane_list[count.index]}:join.sh
EOT
  }
}




