variable "proxmox_endpoint" {
  description = "URL of the Proxmox cluster API"
  type        = string
  default     = "https://pve1.example.com:8006/"
}

variable "proxmox_api_token" {
  description = "Proxmox API token"
  type        = string
}
