output "vm_details" {
  description = "Complete VM details summary"
  value = {
    for k, v in proxmox_virtual_environment_vm.vm : k => {
      vm_id       = v.vm_id
      vm_name     = v.name
      vm_ip       = v.initialization[0].ip_config[0].ipv4[0].address
      node_name   = v.node_name
      cpu_cores   = v.cpu[0].cores
      memory_mb   = v.memory[0].dedicated
      tags        = v.tags
      clone_vm_id = v.clone[0].vm_id
    }
  }
}
