# =============================================================================
# PROVIDER VARIABLES
# =============================================================================

variable "proxmox_endpoint" {
  description = "Proxmox API endpoint"
  type        = string
}

variable "proxmox_insecure" {
  description = "Skip TLS verification"
  type        = bool
  default     = true
}

variable "proxmox_api_token" {
  description = "Proxmox API token"
  type        = string
  sensitive   = true
}

# =============================================================================
# VMS MAP (for_each support)
# =============================================================================

variable "vms" {
  description = "Map of VM configurations. Each key is a unique identifier for the VM."
  type        = any
  default     = {}
}

# =============================================================================
# BASIC VM SETTINGS (defaults for vms map)
# =============================================================================

variable "name" {
  description = "VM name (default, can be overridden per VM)"
  type        = string
  default     = ""
}

variable "description" {
  description = "VM description"
  type        = string
  default     = "VM managed by Terraform"
}

variable "node_name" {
  description = "Proxmox node name where the VM will be created"
  type        = string
  default     = "carbon"
}

variable "vm_id" {
  description = "VM ID (must be unique across the Proxmox cluster)"
  type        = number
  default     = 110
}

variable "tags" {
  description = "List of tags to apply to the VM"
  type        = list(string)
  default     = []
}

# =============================================================================
# VM BEHAVIOR SETTINGS
# =============================================================================

variable "acpi" {
  description = "Enable ACPI support"
  type        = bool
  default     = true
}

variable "agent_enabled" {
  description = "Enable QEMU guest agent"
  type        = bool
  default     = true
}

variable "bios" {
  description = "BIOS type (seabios or ovmf)"
  type        = string
  default     = "seabios"
  validation {
    condition     = contains(["seabios", "ovmf"], var.bios)
    error_message = "BIOS must be either 'seabios' or 'ovmf'."
  }
}

variable "keyboard_layout" {
  description = "Keyboard layout"
  type        = string
  default     = "en-us"
}

variable "migrate" {
  description = "Enable live migration"
  type        = bool
  default     = false
}

variable "on_boot" {
  description = "Start VM on node boot"
  type        = bool
  default     = true
}

variable "protection" {
  description = "Enable VM protection (prevents accidental deletion)"
  type        = bool
  default     = false
}

variable "reboot" {
  description = "Reboot VM after creation"
  type        = bool
  default     = false
}

variable "reboot_after_update" {
  description = "Reboot VM after updates"
  type        = bool
  default     = true
}

variable "started" {
  description = "Start VM after creation"
  type        = bool
  default     = true
}

variable "stop_on_destroy" {
  description = "Stop VM before destroying"
  type        = bool
  default     = true
}

variable "tablet_device" {
  description = "Enable tablet device for better mouse handling"
  type        = bool
  default     = true
}

variable "template" {
  description = "Create as template"
  type        = bool
  default     = false
}

variable "scsi_hardware" {
  description = "SCSI hardware type"
  type        = string
  default     = "virtio-scsi-pci"
  validation {
    condition = contains([
      "virtio-scsi-pci",
      "virtio-scsi-single",
      "megasas",
      "pvscsi",
      "lsi",
      "lsi53c810"
    ], var.scsi_hardware)
    error_message = "SCSI hardware must be one of: virtio-scsi-pci, virtio-scsi-single, megasas, pvscsi, lsi, lsi53c810."
  }
}

# =============================================================================
# TIMEOUTS
# =============================================================================

variable "timeout_clone" {
  description = "Timeout for clone operations (seconds)"
  type        = number
  default     = 60
}

variable "timeout_create" {
  description = "Timeout for create operations (seconds)"
  type        = number
  default     = 60
}

variable "timeout_migrate" {
  description = "Timeout for migrate operations (seconds)"
  type        = number
  default     = 1800
}

variable "timeout_reboot" {
  description = "Timeout for reboot operations (seconds)"
  type        = number
  default     = 1800
}

variable "timeout_shutdown_vm" {
  description = "Timeout for shutdown operations (seconds)"
  type        = number
  default     = 60
}

variable "timeout_start_vm" {
  description = "Timeout for start operations (seconds)"
  type        = number
  default     = 60
}

variable "timeout_stop_vm" {
  description = "Timeout for stop operations (seconds)"
  type        = number
  default     = 60
}

# =============================================================================
# CLONE SETTINGS
# =============================================================================

variable "clone_vm_id" {
  description = "VM ID of the template to clone from"
  type        = number
  default     = null
}

variable "clone_datastore_id" {
  description = "Datastore ID for clone operation"
  type        = string
  default     = "data"
}

variable "clone_full" {
  description = "Perform full clone instead of linked clone"
  type        = bool
  default     = true
}

variable "clone_retries" {
  description = "Number of clone retries"
  type        = number
  default     = 3
}

# =============================================================================
# CPU CONFIGURATION
# =============================================================================

variable "cpu_cores" {
  description = "Number of CPU cores"
  type        = number
  default     = 2
}

variable "cpu_sockets" {
  description = "Number of CPU sockets"
  type        = number
  default     = 1
}

variable "cpu_type" {
  description = "CPU type"
  type        = string
  default     = "host"
}

variable "cpu_units" {
  description = "CPU weight (relative to other VMs)"
  type        = number
  default     = 1024
}

variable "cpu_limit" {
  description = "CPU limit (0 = unlimited)"
  type        = number
  default     = 0
}

variable "cpu_numa" {
  description = "Enable NUMA"
  type        = bool
  default     = false
}

variable "cpu_hotplugged" {
  description = "Number of hotplugged CPU cores"
  type        = number
  default     = 0
}

# =============================================================================
# MEMORY CONFIGURATION
# =============================================================================

variable "memory_dedicated" {
  description = "Dedicated memory in MB"
  type        = number
  default     = 2048
}

variable "memory_floating" {
  description = "Floating memory in MB"
  type        = number
  default     = 0
}

variable "memory_shared" {
  description = "Shared memory in MB"
  type        = number
  default     = 0
}

variable "memory_keep_hugepages" {
  description = "Keep hugepages after VM shutdown"
  type        = bool
  default     = false
}

# =============================================================================
# PRIMARY DISK CONFIGURATION
# =============================================================================

variable "disk_size" {
  description = "Primary disk size in GB"
  type        = number
  default     = 20
}

variable "disk_datastore_id" {
  description = "Datastore ID for primary disk"
  type        = string
  default     = "data"
}

variable "disk_interface" {
  description = "Disk interface (virtio0, scsi0, etc.)"
  type        = string
  default     = "virtio0"
  validation {
    condition = can(regex("^(virtio|scsi|ide|sata)[0-9]+$", var.disk_interface)) || contains([
      "efidisk0", "tpmstate0"
    ], var.disk_interface)
    error_message = "Disk interface must be in format: virtio[0-15], scsi[0-30], ide[0-3], sata[0-5], efidisk0, or tpmstate0."
  }
}

variable "disk_file_format" {
  description = "Disk file format (raw, qcow2, vmdk)"
  type        = string
  default     = "qcow2"
  validation {
    condition = contains([
      "raw",
      "qcow2",
      "vmdk"
    ], var.disk_file_format)
    error_message = "Disk file format must be one of: raw, qcow2, vmdk."
  }
}

variable "disk_cache" {
  description = "Disk cache mode"
  type        = string
  default     = "none"
}

variable "disk_aio" {
  description = "AIO mode"
  type        = string
  default     = "io_uring"
}

variable "disk_backup" {
  description = "Include disk in backups"
  type        = bool
  default     = false
}

variable "disk_discard" {
  description = "Discard mode (ignore, on)"
  type        = string
  default     = "ignore"
}

variable "disk_iothread" {
  description = "Enable IO thread"
  type        = bool
  default     = false
}

variable "disk_replicate" {
  description = "Enable replication"
  type        = bool
  default     = false
}

variable "disk_ssd" {
  description = "Mark disk as SSD"
  type        = bool
  default     = false
}

# =============================================================================
# ADDITIONAL DISKS (OPTIONAL)
# =============================================================================

variable "disk_additional" {
  description = "Optional list of additional disks to attach to the VM. Leave empty (default) if no additional disks are needed."
  type = list(object({
    size         = optional(number, 10)
    interface    = optional(string, "virtio1")
    datastore_id = optional(string, "data")
    file_format  = optional(string, "qcow2")
    cache        = optional(string, "none")
    aio          = optional(string, "io_uring")
    backup       = optional(bool, false)
    discard      = optional(string, "ignore")
    iothread     = optional(bool, false)
    replicate    = optional(bool, false)
    ssd          = optional(bool, false)
  }))
  default = []

  # This variable is entirely optional - VMs will work perfectly fine with just the primary disk
}

# =============================================================================
# PRIMARY NETWORK DEVICE
# =============================================================================

variable "network_bridge" {
  description = "Network bridge for primary network device"
  type        = string
  default     = "vmbr0"
}

variable "network_model" {
  description = "Network model (virtio, e1000, rtl8139)"
  type        = string
  default     = "virtio"
  validation {
    condition = contains([
      "virtio",
      "e1000",
      "e1000-82540em",
      "e1000-82544gc",
      "e1000-82545em",
      "rtl8139",
      "ne2k_pci",
      "pcnet",
      "vmxnet3"
    ], var.network_model)
    error_message = "Network model must be one of: virtio, e1000, e1000-82540em, e1000-82544gc, e1000-82545em, rtl8139, ne2k_pci, pcnet, vmxnet3."
  }
}

variable "network_enabled" {
  description = "Enable primary network device"
  type        = bool
  default     = true
}

variable "network_firewall" {
  description = "Enable firewall for primary network device"
  type        = bool
  default     = false
}

variable "network_mac_address" {
  description = "MAC address for primary network device (auto-generated if null)"
  type        = string
  default     = null
}

variable "network_mtu" {
  description = "MTU for primary network device (0 = default)"
  type        = number
  default     = 0
}

variable "network_queues" {
  description = "Number of packet queues (0 = default)"
  type        = number
  default     = 0
}

variable "network_rate_limit" {
  description = "Rate limit in MB/s (0 = unlimited)"
  type        = number
  default     = 0
}

variable "network_vlan_id" {
  description = "VLAN ID (0 = no VLAN)"
  type        = number
  default     = 0
}

# =============================================================================
# ADDITIONAL NETWORK DEVICES (OPTIONAL)
# =============================================================================

variable "network_additional" {
  description = "Optional list of additional network devices to attach to the VM. Leave empty (default) if only the primary network device is needed."
  type = list(object({
    bridge      = optional(string, "vmbr2")
    model       = optional(string, "virtio")
    enabled     = optional(bool, true)
    firewall    = optional(bool, false)
    mac_address = optional(string)
    mtu         = optional(number, 0)
    queues      = optional(number, 0)
    rate_limit  = optional(number, 0)
    vlan_id     = optional(number, 0)
  }))
  default = []

  # This variable is entirely optional - VMs will work perfectly fine with just the primary network device
}

# =============================================================================
# INITIALIZATION / CLOUD-INIT
# =============================================================================

variable "init_datastore_id" {
  description = "Datastore ID for cloud-init drive"
  type        = string
  default     = "data"
}

variable "init_interface" {
  description = "Interface for cloud-init drive"
  type        = string
  default     = "scsi0"
}

variable "init_dns_servers" {
  description = "List of DNS servers"
  type        = list(string)
  default     = ["8.8.8.8", "8.8.4.4"]
}

variable "init_ip_address" {
  description = "Primary IP address with CIDR (e.g., 172.16.2.100/24)"
  type        = string
  default     = "172.16.2.100"
}

variable "init_gateway" {
  description = "Default gateway IP address"
  type        = string
}

variable "init_username" {
  description = "Default user account username"
  type        = string
  default     = "dummy"
}

variable "init_password" {
  description = "Default user account password"
  type        = string
  default     = "dummy"
}

variable "init_ssh_keys" {
  description = "List of SSH public keys for default user"
  type        = list(string)
  default     = []
}

# =============================================================================
# ADDITIONAL IP CONFIGURATIONS (OPTIONAL)
# =============================================================================

variable "additional_ip_configs" {
  description = "Optional list of additional IP configurations for multi-homed network setups. Leave empty (default) if only the primary IP configuration is needed."
  type = list(object({
    address = string
    gateway = optional(string)
  }))
  default = []

  # This variable is entirely optional - VMs will work perfectly fine with just the primary IP configuration
}

# =============================================================================
# WINDOWS SETTINGS
# =============================================================================

variable "is_windows" {
  description = "Set to true if the VM is Windows; false for Linux"
  type        = bool
  default     = false
}

variable "winrm_max_attempts" {
  description = "Maximum number of WinRM connectivity check attempts before failing"
  type        = number
  default     = 60
}

variable "winrm_retry_delay" {
  description = "Seconds to wait between WinRM connectivity check attempts"
  type        = number
  default     = 10
}

variable "winrm_settle_time" {
  description = "Seconds to wait after WinRM responds before running provisioners"
  type        = number
  default     = 30
}

variable "winrm_timeout" {
  description = "Timeout for WinRM connection attempts"
  type        = string
  default     = "10m"
}

variable "force_update" {
  description = "Run post-initialization tasks when true (default=false). Set to true for subsequent applies to execute post-init provisioners."
  type        = bool
  default     = false
}
