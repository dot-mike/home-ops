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
