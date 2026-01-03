# Proxmox VM Terraform Module

This module creates and manages Proxmox VMs using the Proxmox provider.

## Features

- Full VM lifecycle management
- Cloud-init support
- Multiple disk support
- Multiple network interface support
- Configurable CPU, memory, and storage
- Template cloning
- Flexible configuration via Terragrunt
- Multi-VM deployment

## Usage

This module is designed to be used with Terragrunt. See the `examples/` directory for usage examples.

<!-- BEGIN_TF_DOCS -->
# Proxmox VM Terraform Module

This module creates and manages Proxmox VMs using the Proxmox provider.

## Features

- Full VM lifecycle management
- Windows and Linux support
- WinRM provisioning for Windows VMs
- Cloud-init support
- Multiple disk support
- Multiple network interface support
- Configurable CPU, memory, and storage
- Template cloning
- Flexible configuration via Terragrunt
- Multi-VM deployment

## Usage

### Basic Example (Linux VM)

```hcl
module "linux_vm" {
  source = "git::https://github.com/ginanck/terraform-proxmox-vm.git?ref=master"

  vms = {
    web-server = {
      vm_id       = 100
      name        = "web-server-01"
      ip_address  = "192.168.1.100/24"
      cpu_cores   = 2
      memory_dedicated = 4096
      disk_size   = 50
      tags        = ["web", "production"]
    }
  }

  clone_vm_id      = 8000  # Linux template
  network_bridge   = "vmbr0"
  init_gateway     = "192.168.1.1"
  init_dns_servers = ["8.8.8.8", "8.8.4.4"]
}
```

### Windows VM Example

```hcl
module "windows_vm" {
  source = "git::https://github.com/ginanck/terraform-proxmox-vm.git?ref=master"

  vms = {
    windows-server = {
      vm_id            = 200
      name             = "win-server-01"
      ip_address       = "192.168.1.200/24"
      cpu_cores        = 4
      memory_dedicated = 8192
      disk_size        = 100
      tags             = ["windows", "server"]

      # Windows-specific settings
      bios           = "ovmf"
      disk_interface = "sata0"
      is_windows     = true
      force_update   = false
      init_username  = "Administrator"
      init_password  = "SecurePassword123!"
    }
  }

  clone_vm_id      = 7902  # Windows template
  network_bridge   = "vmbr0"
  init_gateway     = "192.168.1.1"
  init_dns_servers = ["192.168.1.1"]
  is_windows       = true
}
```

### Terragrunt Example

See the [examples directory](https://github.com/ginanck/terraform-proxmox-vm/tree/master/examples) for complete Terragrunt configurations.

## Windows Support

For Windows VMs, the module includes:
- Automatic WinRM availability checks
- PowerShell-based disk management provisioners
- Configurable WinRM connection parameters

### Windows Requirements:
1. Template must have Cloudbase-Init installed
2. WinRM enabled on port 5985
3. OVMF BIOS configured
4. SATA disk interface

## Requirements

| Name | Version |
|------|---------|
| <a name="requirement_terraform"></a> [terraform](#requirement\_terraform) | >= 1.0.0 |
| <a name="requirement_null"></a> [null](#requirement\_null) | 3.2.4 |
| <a name="requirement_proxmox"></a> [proxmox](#requirement\_proxmox) | 0.85.1 |

## Providers

| Name | Version |
|------|---------|
| <a name="provider_null"></a> [null](#provider\_null) | 3.2.4 |
| <a name="provider_proxmox"></a> [proxmox](#provider\_proxmox) | 0.85.1 |

## Modules

No modules.

## Resources

| Name | Type |
|------|------|
| [null_resource.configure_disks](https://registry.terraform.io/providers/hashicorp/null/3.2.4/docs/resources/resource) | resource |
| [null_resource.wait_for_winrm](https://registry.terraform.io/providers/hashicorp/null/3.2.4/docs/resources/resource) | resource |
| [proxmox_virtual_environment_vm.vm](https://registry.terraform.io/providers/bpg/proxmox/0.85.1/docs/resources/virtual_environment_vm) | resource |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_acpi"></a> [acpi](#input\_acpi) | Enable ACPI support | `bool` | `true` | no |
| <a name="input_additional_ip_configs"></a> [additional\_ip\_configs](#input\_additional\_ip\_configs) | Optional list of additional IP configurations for multi-homed network setups. Leave empty (default) if only the primary IP configuration is needed. | <pre>list(object({<br/>    address = string<br/>    gateway = optional(string)<br/>  }))</pre> | `[]` | no |
| <a name="input_agent_enabled"></a> [agent\_enabled](#input\_agent\_enabled) | Enable QEMU guest agent | `bool` | `true` | no |
| <a name="input_bios"></a> [bios](#input\_bios) | BIOS type (seabios or ovmf) | `string` | `"seabios"` | no |
| <a name="input_clone_datastore_id"></a> [clone\_datastore\_id](#input\_clone\_datastore\_id) | Datastore ID for clone operation | `string` | `"data"` | no |
| <a name="input_clone_full"></a> [clone\_full](#input\_clone\_full) | Perform full clone instead of linked clone | `bool` | `true` | no |
| <a name="input_clone_retries"></a> [clone\_retries](#input\_clone\_retries) | Number of clone retries | `number` | `3` | no |
| <a name="input_clone_vm_id"></a> [clone\_vm\_id](#input\_clone\_vm\_id) | VM ID of the template to clone from | `number` | `null` | no |
| <a name="input_cpu_cores"></a> [cpu\_cores](#input\_cpu\_cores) | Number of CPU cores | `number` | `2` | no |
| <a name="input_cpu_hotplugged"></a> [cpu\_hotplugged](#input\_cpu\_hotplugged) | Number of hotplugged CPU cores | `number` | `0` | no |
| <a name="input_cpu_limit"></a> [cpu\_limit](#input\_cpu\_limit) | CPU limit (0 = unlimited) | `number` | `0` | no |
| <a name="input_cpu_numa"></a> [cpu\_numa](#input\_cpu\_numa) | Enable NUMA | `bool` | `false` | no |
| <a name="input_cpu_sockets"></a> [cpu\_sockets](#input\_cpu\_sockets) | Number of CPU sockets | `number` | `1` | no |
| <a name="input_cpu_type"></a> [cpu\_type](#input\_cpu\_type) | CPU type | `string` | `"host"` | no |
| <a name="input_cpu_units"></a> [cpu\_units](#input\_cpu\_units) | CPU weight (relative to other VMs) | `number` | `1024` | no |
| <a name="input_description"></a> [description](#input\_description) | VM description | `string` | `"VM managed by Terraform"` | no |
| <a name="input_disk_additional"></a> [disk\_additional](#input\_disk\_additional) | Optional list of additional disks to attach to the VM. Leave empty (default) if no additional disks are needed. | <pre>list(object({<br/>    size         = optional(number, 10)<br/>    interface    = optional(string, "virtio1")<br/>    datastore_id = optional(string, "data")<br/>    file_format  = optional(string, "qcow2")<br/>    cache        = optional(string, "none")<br/>    aio          = optional(string, "io_uring")<br/>    backup       = optional(bool, false)<br/>    discard      = optional(string, "ignore")<br/>    iothread     = optional(bool, false)<br/>    replicate    = optional(bool, false)<br/>    ssd          = optional(bool, false)<br/>  }))</pre> | `[]` | no |
| <a name="input_disk_aio"></a> [disk\_aio](#input\_disk\_aio) | AIO mode | `string` | `"io_uring"` | no |
| <a name="input_disk_backup"></a> [disk\_backup](#input\_disk\_backup) | Include disk in backups | `bool` | `false` | no |
| <a name="input_disk_cache"></a> [disk\_cache](#input\_disk\_cache) | Disk cache mode | `string` | `"none"` | no |
| <a name="input_disk_datastore_id"></a> [disk\_datastore\_id](#input\_disk\_datastore\_id) | Datastore ID for primary disk | `string` | `"data"` | no |
| <a name="input_disk_discard"></a> [disk\_discard](#input\_disk\_discard) | Discard mode (ignore, on) | `string` | `"ignore"` | no |
| <a name="input_disk_file_format"></a> [disk\_file\_format](#input\_disk\_file\_format) | Disk file format (raw, qcow2, vmdk) | `string` | `"qcow2"` | no |
| <a name="input_disk_interface"></a> [disk\_interface](#input\_disk\_interface) | Disk interface (virtio0, scsi0, etc.) | `string` | `"virtio0"` | no |
| <a name="input_disk_iothread"></a> [disk\_iothread](#input\_disk\_iothread) | Enable IO thread | `bool` | `false` | no |
| <a name="input_disk_replicate"></a> [disk\_replicate](#input\_disk\_replicate) | Enable replication | `bool` | `false` | no |
| <a name="input_disk_size"></a> [disk\_size](#input\_disk\_size) | Primary disk size in GB | `number` | `20` | no |
| <a name="input_disk_ssd"></a> [disk\_ssd](#input\_disk\_ssd) | Mark disk as SSD | `bool` | `false` | no |
| <a name="input_force_update"></a> [force\_update](#input\_force\_update) | Run post-initialization tasks when true (default=false). Set to true for subsequent applies to execute post-init provisioners. | `bool` | `false` | no |
| <a name="input_init_datastore_id"></a> [init\_datastore\_id](#input\_init\_datastore\_id) | Datastore ID for cloud-init drive | `string` | `"data"` | no |
| <a name="input_init_dns_servers"></a> [init\_dns\_servers](#input\_init\_dns\_servers) | List of DNS servers | `list(string)` | <pre>[<br/>  "8.8.8.8",<br/>  "8.8.4.4"<br/>]</pre> | no |
| <a name="input_init_gateway"></a> [init\_gateway](#input\_init\_gateway) | Default gateway IP address | `string` | n/a | yes |
| <a name="input_init_interface"></a> [init\_interface](#input\_init\_interface) | Interface for cloud-init drive | `string` | `"scsi0"` | no |
| <a name="input_init_ip_address"></a> [init\_ip\_address](#input\_init\_ip\_address) | Primary IP address with CIDR (e.g., 172.16.2.100/24) | `string` | `"172.16.2.100"` | no |
| <a name="input_init_password"></a> [init\_password](#input\_init\_password) | Default user account password | `string` | `"dummy"` | no |
| <a name="input_init_ssh_keys"></a> [init\_ssh\_keys](#input\_init\_ssh\_keys) | List of SSH public keys for default user | `list(string)` | `[]` | no |
| <a name="input_init_username"></a> [init\_username](#input\_init\_username) | Default user account username | `string` | `"dummy"` | no |
| <a name="input_is_windows"></a> [is\_windows](#input\_is\_windows) | Set to true if the VM is Windows; false for Linux | `bool` | `false` | no |
| <a name="input_keyboard_layout"></a> [keyboard\_layout](#input\_keyboard\_layout) | Keyboard layout | `string` | `"en-us"` | no |
| <a name="input_memory_dedicated"></a> [memory\_dedicated](#input\_memory\_dedicated) | Dedicated memory in MB | `number` | `2048` | no |
| <a name="input_memory_floating"></a> [memory\_floating](#input\_memory\_floating) | Floating memory in MB | `number` | `0` | no |
| <a name="input_memory_keep_hugepages"></a> [memory\_keep\_hugepages](#input\_memory\_keep\_hugepages) | Keep hugepages after VM shutdown | `bool` | `false` | no |
| <a name="input_memory_shared"></a> [memory\_shared](#input\_memory\_shared) | Shared memory in MB | `number` | `0` | no |
| <a name="input_migrate"></a> [migrate](#input\_migrate) | Enable live migration | `bool` | `false` | no |
| <a name="input_name"></a> [name](#input\_name) | VM name (default, can be overridden per VM) | `string` | `""` | no |
| <a name="input_network_additional"></a> [network\_additional](#input\_network\_additional) | Optional list of additional network devices to attach to the VM. Leave empty (default) if only the primary network device is needed. | <pre>list(object({<br/>    bridge      = optional(string, "vmbr2")<br/>    model       = optional(string, "virtio")<br/>    enabled     = optional(bool, true)<br/>    firewall    = optional(bool, false)<br/>    mac_address = optional(string)<br/>    mtu         = optional(number, 0)<br/>    queues      = optional(number, 0)<br/>    rate_limit  = optional(number, 0)<br/>    vlan_id     = optional(number, 0)<br/>  }))</pre> | `[]` | no |
| <a name="input_network_bridge"></a> [network\_bridge](#input\_network\_bridge) | Network bridge for primary network device | `string` | `"vmbr0"` | no |
| <a name="input_network_enabled"></a> [network\_enabled](#input\_network\_enabled) | Enable primary network device | `bool` | `true` | no |
| <a name="input_network_firewall"></a> [network\_firewall](#input\_network\_firewall) | Enable firewall for primary network device | `bool` | `false` | no |
| <a name="input_network_mac_address"></a> [network\_mac\_address](#input\_network\_mac\_address) | MAC address for primary network device (auto-generated if null) | `string` | `null` | no |
| <a name="input_network_model"></a> [network\_model](#input\_network\_model) | Network model (virtio, e1000, rtl8139) | `string` | `"virtio"` | no |
| <a name="input_network_mtu"></a> [network\_mtu](#input\_network\_mtu) | MTU for primary network device (0 = default) | `number` | `0` | no |
| <a name="input_network_queues"></a> [network\_queues](#input\_network\_queues) | Number of packet queues (0 = default) | `number` | `0` | no |
| <a name="input_network_rate_limit"></a> [network\_rate\_limit](#input\_network\_rate\_limit) | Rate limit in MB/s (0 = unlimited) | `number` | `0` | no |
| <a name="input_network_vlan_id"></a> [network\_vlan\_id](#input\_network\_vlan\_id) | VLAN ID (0 = no VLAN) | `number` | `0` | no |
| <a name="input_node_name"></a> [node\_name](#input\_node\_name) | Proxmox node name where the VM will be created | `string` | `"carbon"` | no |
| <a name="input_on_boot"></a> [on\_boot](#input\_on\_boot) | Start VM on node boot | `bool` | `true` | no |
| <a name="input_protection"></a> [protection](#input\_protection) | Enable VM protection (prevents accidental deletion) | `bool` | `false` | no |
| <a name="input_proxmox_api_token"></a> [proxmox\_api\_token](#input\_proxmox\_api\_token) | Proxmox API token | `string` | n/a | yes |
| <a name="input_proxmox_endpoint"></a> [proxmox\_endpoint](#input\_proxmox\_endpoint) | Proxmox API endpoint | `string` | n/a | yes |
| <a name="input_proxmox_insecure"></a> [proxmox\_insecure](#input\_proxmox\_insecure) | Skip TLS verification | `bool` | `true` | no |
| <a name="input_reboot"></a> [reboot](#input\_reboot) | Reboot VM after creation | `bool` | `false` | no |
| <a name="input_reboot_after_update"></a> [reboot\_after\_update](#input\_reboot\_after\_update) | Reboot VM after updates | `bool` | `true` | no |
| <a name="input_scsi_hardware"></a> [scsi\_hardware](#input\_scsi\_hardware) | SCSI hardware type | `string` | `"virtio-scsi-pci"` | no |
| <a name="input_started"></a> [started](#input\_started) | Start VM after creation | `bool` | `true` | no |
| <a name="input_stop_on_destroy"></a> [stop\_on\_destroy](#input\_stop\_on\_destroy) | Stop VM before destroying | `bool` | `false` | no |
| <a name="input_tablet_device"></a> [tablet\_device](#input\_tablet\_device) | Enable tablet device for better mouse handling | `bool` | `true` | no |
| <a name="input_tags"></a> [tags](#input\_tags) | List of tags to apply to the VM | `list(string)` | `[]` | no |
| <a name="input_template"></a> [template](#input\_template) | Create as template | `bool` | `false` | no |
| <a name="input_timeout_clone"></a> [timeout\_clone](#input\_timeout\_clone) | Timeout for clone operations (seconds) | `number` | `1800` | no |
| <a name="input_timeout_create"></a> [timeout\_create](#input\_timeout\_create) | Timeout for create operations (seconds) | `number` | `1800` | no |
| <a name="input_timeout_migrate"></a> [timeout\_migrate](#input\_timeout\_migrate) | Timeout for migrate operations (seconds) | `number` | `1800` | no |
| <a name="input_timeout_reboot"></a> [timeout\_reboot](#input\_timeout\_reboot) | Timeout for reboot operations (seconds) | `number` | `1800` | no |
| <a name="input_timeout_shutdown_vm"></a> [timeout\_shutdown\_vm](#input\_timeout\_shutdown\_vm) | Timeout for shutdown operations (seconds) | `number` | `1800` | no |
| <a name="input_timeout_start_vm"></a> [timeout\_start\_vm](#input\_timeout\_start\_vm) | Timeout for start operations (seconds) | `number` | `1800` | no |
| <a name="input_timeout_stop_vm"></a> [timeout\_stop\_vm](#input\_timeout\_stop\_vm) | Timeout for stop operations (seconds) | `number` | `300` | no |
| <a name="input_vm_id"></a> [vm\_id](#input\_vm\_id) | VM ID (must be unique across the Proxmox cluster) | `number` | `110` | no |
| <a name="input_vms"></a> [vms](#input\_vms) | Map of VM configurations. Each key is a unique identifier for the VM. | `any` | `{}` | no |
| <a name="input_winrm_max_attempts"></a> [winrm\_max\_attempts](#input\_winrm\_max\_attempts) | Maximum number of WinRM connectivity check attempts before failing | `number` | `60` | no |
| <a name="input_winrm_retry_delay"></a> [winrm\_retry\_delay](#input\_winrm\_retry\_delay) | Seconds to wait between WinRM connectivity check attempts | `number` | `10` | no |
| <a name="input_winrm_settle_time"></a> [winrm\_settle\_time](#input\_winrm\_settle\_time) | Seconds to wait after WinRM responds before running provisioners | `number` | `30` | no |
| <a name="input_winrm_timeout"></a> [winrm\_timeout](#input\_winrm\_timeout) | Timeout for WinRM connection attempts | `string` | `"10m"` | no |

## Outputs

| Name | Description |
|------|-------------|
| <a name="output_vm_details"></a> [vm\_details](#output\_vm\_details) | Complete VM details summary |
<!-- END_TF_DOCS -->
