resource "proxmox_virtual_environment_vm" "vm" {
  for_each = var.vms

  # Basic settings
  name        = each.value.name
  description = lookup(each.value, "description", var.description)
  node_name   = lookup(each.value, "node_name", var.node_name)
  vm_id       = each.value.vm_id
  tags        = lookup(each.value, "tags", var.tags)

  # VM behavior settings
  acpi                = lookup(each.value, "acpi", var.acpi)
  bios                = lookup(each.value, "bios", var.bios)
  keyboard_layout     = lookup(each.value, "keyboard_layout", var.keyboard_layout)
  migrate             = lookup(each.value, "migrate", var.migrate)
  on_boot             = lookup(each.value, "on_boot", var.on_boot)
  protection          = lookup(each.value, "protection", var.protection)
  reboot              = lookup(each.value, "reboot", var.reboot)
  reboot_after_update = lookup(each.value, "reboot_after_update", var.reboot_after_update)
  scsi_hardware       = lookup(each.value, "scsi_hardware", var.scsi_hardware)
  started             = lookup(each.value, "started", var.started)
  stop_on_destroy     = lookup(each.value, "stop_on_destroy", var.stop_on_destroy)
  tablet_device       = lookup(each.value, "tablet_device", var.tablet_device)
  template            = lookup(each.value, "template", var.template)

  # Agent configuration
  agent {
    enabled = lookup(each.value, "agent_enabled", var.agent_enabled)
  }

  # Timeouts
  timeout_clone       = lookup(each.value, "timeout_clone", var.timeout_clone)
  timeout_create      = lookup(each.value, "timeout_create", var.timeout_create)
  timeout_migrate     = lookup(each.value, "timeout_migrate", var.timeout_migrate)
  timeout_reboot      = lookup(each.value, "timeout_reboot", var.timeout_reboot)
  timeout_shutdown_vm = lookup(each.value, "timeout_shutdown_vm", var.timeout_shutdown_vm)
  timeout_start_vm    = lookup(each.value, "timeout_start_vm", var.timeout_start_vm)
  timeout_stop_vm     = lookup(each.value, "timeout_stop_vm", var.timeout_stop_vm)

  # Clone configuration
  clone {
    datastore_id = lookup(each.value, "clone_datastore_id", var.clone_datastore_id)
    full         = lookup(each.value, "clone_full", var.clone_full)
    retries      = lookup(each.value, "clone_retries", var.clone_retries)
    vm_id        = lookup(each.value, "clone_vm_id", var.clone_vm_id)
  }

  # CPU configuration
  cpu {
    cores      = lookup(each.value, "cpu_cores", var.cpu_cores)
    hotplugged = lookup(each.value, "cpu_hotplugged", var.cpu_hotplugged)
    limit      = lookup(each.value, "cpu_limit", var.cpu_limit)
    numa       = lookup(each.value, "cpu_numa", var.cpu_numa)
    sockets    = lookup(each.value, "cpu_sockets", var.cpu_sockets)
    type       = lookup(each.value, "cpu_type", var.cpu_type)
    units      = lookup(each.value, "cpu_units", var.cpu_units)
  }

  # Memory configuration
  memory {
    dedicated      = lookup(each.value, "memory_dedicated", var.memory_dedicated)
    floating       = lookup(each.value, "memory_floating", var.memory_floating)
    keep_hugepages = lookup(each.value, "memory_keep_hugepages", var.memory_keep_hugepages)
    shared         = lookup(each.value, "memory_shared", var.memory_shared)
  }

  # Primary disk
  disk {
    aio          = lookup(each.value, "disk_aio", var.disk_aio)
    backup       = lookup(each.value, "disk_backup", var.disk_backup)
    cache        = lookup(each.value, "disk_cache", var.disk_cache)
    datastore_id = lookup(each.value, "disk_datastore_id", var.disk_datastore_id)
    discard      = lookup(each.value, "disk_discard", var.disk_discard)
    interface    = lookup(each.value, "disk_interface", var.disk_interface)
    file_format  = lookup(each.value, "disk_file_format", var.disk_file_format)
    iothread     = lookup(each.value, "disk_iothread", var.disk_iothread)
    replicate    = lookup(each.value, "disk_replicate", var.disk_replicate)
    size         = lookup(each.value, "disk_size", var.disk_size)
    ssd          = lookup(each.value, "disk_ssd", var.disk_ssd)
  }

  # Additional disks
  dynamic "disk" {
    for_each = lookup(each.value, "disk_additional", var.disk_additional)
    content {
      aio          = lookup(disk.value, "aio", "io_uring")
      backup       = lookup(disk.value, "backup", false)
      cache        = lookup(disk.value, "cache", "none")
      datastore_id = lookup(disk.value, "datastore_id", var.disk_datastore_id)
      discard      = lookup(disk.value, "discard", "ignore")
      interface    = disk.value.interface
      file_format  = lookup(disk.value, "file_format", "qcow2")
      iothread     = lookup(disk.value, "iothread", false)
      replicate    = lookup(disk.value, "replicate", false)
      size         = disk.value.size
      ssd          = lookup(disk.value, "ssd", false)
    }
  }

  # Primary network device
  network_device {
    bridge      = lookup(each.value, "network_bridge", var.network_bridge)
    enabled     = lookup(each.value, "network_enabled", var.network_enabled)
    firewall    = lookup(each.value, "network_firewall", var.network_firewall)
    mac_address = lookup(each.value, "network_mac_address", var.network_mac_address)
    model       = lookup(each.value, "network_model", var.network_model)
    mtu         = lookup(each.value, "network_mtu", var.network_mtu)
    queues      = lookup(each.value, "network_queues", var.network_queues)
    rate_limit  = lookup(each.value, "network_rate_limit", var.network_rate_limit)
    vlan_id     = lookup(each.value, "network_vlan_id", var.network_vlan_id)
  }

  # Additional network devices
  dynamic "network_device" {
    for_each = lookup(each.value, "network_additional", var.network_additional)
    content {
      bridge      = network_device.value.bridge
      enabled     = lookup(network_device.value, "enabled", true)
      firewall    = lookup(network_device.value, "firewall", false)
      mac_address = lookup(network_device.value, "mac_address", null)
      model       = lookup(network_device.value, "model", "virtio")
      mtu         = lookup(network_device.value, "mtu", null)
      queues      = lookup(network_device.value, "queues", null)
      rate_limit  = lookup(network_device.value, "rate_limit", null)
      vlan_id     = lookup(network_device.value, "vlan_id", null)
    }
  }

  # Initialization (Cloud-Init)
  initialization {
    datastore_id = lookup(each.value, "init_datastore_id", var.init_datastore_id)
    interface    = lookup(each.value, "init_interface", var.init_interface)

    dns {
      servers = lookup(each.value, "init_dns_servers", var.init_dns_servers)
    }

    ip_config {
      ipv4 {
        address = each.value.ip_address
        gateway = lookup(each.value, "init_gateway", var.init_gateway)
      }
    }

    # Additional IP configurations
    dynamic "ip_config" {
      for_each = lookup(each.value, "additional_ip_configs", var.additional_ip_configs)
      content {
        ipv4 {
          address = lookup(ip_config.value, "address", null)
          gateway = lookup(ip_config.value, "gateway", null)
        }
      }
    }

    user_account {
      keys     = lookup(each.value, "init_ssh_keys", var.init_ssh_keys)
      password = lookup(each.value, "init_password", var.init_password)
      username = lookup(each.value, "init_username", var.init_username)
    }
  }
}

# =============================================================================
# WINDOWS SUPPORT - WinRM Wait and Disk Configuration
# =============================================================================

locals {
  # Extract host IP addresses for each VM
  vm_host_ips = {
    for k, v in var.vms : k => split("/", v.ip_address)[0]
  }

  # Filter only Windows VMs that need updates
  windows_vms_to_configure = {
    for k, v in var.vms : k => v
    if lookup(v, "is_windows", var.is_windows) && lookup(v, "force_update", var.force_update)
  }
}

# Wait for WinRM to become available before running provisioners
resource "null_resource" "wait_for_winrm" {
  for_each = local.windows_vms_to_configure

  depends_on = [proxmox_virtual_environment_vm.vm]

  provisioner "local-exec" {
    command = <<-EOT
      echo "Waiting for WinRM on ${local.vm_host_ips[each.key]}..."
      for i in $(seq 1 ${lookup(each.value, "winrm_max_attempts", var.winrm_max_attempts)}); do
        curl -s -o /dev/null -w '' --max-time 3 http://${local.vm_host_ips[each.key]}:5985/wsman && \
          echo "WinRM ready" && sleep ${lookup(each.value, "winrm_settle_time", var.winrm_settle_time)} && exit 0
        sleep ${lookup(each.value, "winrm_retry_delay", var.winrm_retry_delay)}
      done
      echo "WinRM timeout" && exit 1
    EOT
  }
}

resource "null_resource" "configure_disks" {
  for_each = local.windows_vms_to_configure

  depends_on = [
    null_resource.wait_for_winrm,
  ]

  # Trigger on disk size changes (primary + additional disks)
  triggers = {
    disk_config = jsonencode({
      primary          = lookup(each.value, "disk_size", var.disk_size)
      additional_sizes = [for disk in lookup(each.value, "disk_additional", var.disk_additional) : disk.size]
    })
  }

  connection {
    type     = "winrm"
    host     = local.vm_host_ips[each.key]
    user     = lookup(each.value, "init_username", var.init_username)
    password = lookup(each.value, "init_password", var.init_password)
    port     = 5985
    https    = false
    insecure = true
    timeout  = lookup(each.value, "winrm_timeout", var.winrm_timeout)
  }

  provisioner "remote-exec" {
    inline = [
      "powershell.exe -ExecutionPolicy Bypass -File \"C:\\Program Files\\Cloudbase Solutions\\Cloudbase-Init\\pc2_scripts\\Runtime-ManageDisks.ps1\""
    ]
  }
}
