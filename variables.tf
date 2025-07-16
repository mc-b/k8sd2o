
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