terraform {
  required_providers {
    proxmox = {
      source  = "bpg/proxmox"
      version = "~> 0.57.0"
    }
    aws = {
      source  = "hashicorp/aws"
      version = "~> 5.50"
    }
  }

  encryption {
    method "aes_gcm" "default" {
      keys = key_provider.pbkdf2.my_passphrase
    }

    state {
      method = method.aes_gcm.default
      enforced = true
    }
  }

  backend "s3" {
    bucket = "terraform-state-homeops"
    key    = "global/s3/terraform.tfstate"
    region = "eu-central-1"
  }
}

locals {
  pve_iso_datastore_id = "SynoNFS1"
  pve_vm_datastore = "Pool1"

  pve_pool_id_okd = "okd4"
}


resource "proxmox_virtual_environment_pool" "okd4_pool" {
  comment = "Managed by Terraform"
  pool_id = local.pve_pool_id_okd
}

resource "proxmox_virtual_environment_file" "fedora_coreos_cloud_image" {
  content_type = "iso"
  datastore_id = local.pve_iso_datastore_id
  node_name    = "pve-node-01"

  source_file {
    path      = "https://builds.coreos.fedoraproject.org/prod/streams/stable/builds/${var.fedora_core_os_version}/x86_64/fedora-coreos-${var.fedora_core_os_version}-openstack.x86_64.qcow2.xz"
    file_name = "fedora-coreos-${element(split(".", var.fedora_core_os_version), 0)}-openstack.x86_64.img"
  }
}
