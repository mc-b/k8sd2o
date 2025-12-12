
# Optionale Module bzw. SW Pakete

variable "install_cert_manager" {
  type    = string
  default = "no"
}

variable "install_kubevirt" {
  type    = string
  default = "no"
}

variable "install_longhorn" {
  type    = string
  default = "no"
}

variable "install_istio" {
  type    = string
  default = "no"
}

variable "install_knative" {
  type    = string
  default = "no"
}

variable "install_argocd" {
  type    = string
  default = "no"
}

variable "install_iiot" {
  type    = string
  default = "no"
}

variable "host_no" {
  description = "Host-No fuer die erste Host-IP Nummer"
  type        = number
  default     = 10
}


# Zugriffsinformationen

variable "url" {
  description = "Evtl. URL fuer den Zugriff auf das API des Racks Servers"
  type        = string
  default     = "unknown"
}

# Umgebungsvariable TF_VAR_key ablegen
variable "key" {
  description = "API Key, Token etc. fuer Zugriff"
  type        = string
  sensitive   = true
  default     = "unknown"
}

variable "vpn" {
  description = "Optional VPN welches eingerichtet werden soll"
  type        = string
  default     = "unknown"
}