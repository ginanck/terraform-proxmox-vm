terraform {
  required_version = ">= 1.0.0"

  required_providers {
    proxmox = {
      source                = "bpg/proxmox"
      version               = "0.85.1"
      configuration_aliases = [proxmox]
    }
    null = {
      source  = "hashicorp/null"
      version = "3.2.4"
    }
  }
}
