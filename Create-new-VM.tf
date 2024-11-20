terraform {
  required_providers {
    proxmox = {
      source  = "Telmate/proxmox"
      version = "~> 2.9.11" # Specify the desired version
    }
  }
}

# Proxmox Provider Configuration
provider "proxmox" {
  pm_api_url      = "https://10.0.15.42:8006/api2/json" # Replace with your Proxmox server address
  pm_user         = "root@pam" # Using root user with PAM authentication
  pm_password     = "cricbuzz" # Replace with your root password
  pm_tls_insecure = true # Set to false for a secure connection with a valid certificate
}

# Create a new VM
resource "proxmox_vm_qemu" "new_vm" {
  name        = "new-vm" # Desired VM name
  target_node = "test"    # Replace with your Proxmox node name
  clone       = "Server" # Replace with the name of your Proxmox template

  # VM Configuration
  cores       = 2         # Number of CPU cores
  sockets     = 1         # Number of CPU sockets
  memory      = 2048      # RAM size in MB
  scsihw      = "virtio-scsi-pci" # SCSI controller type
  bootdisk    = "scsi0"   # Boot disk

  # Disk Configuration
  disk {
    size    = "20G"
    type    = "scsi"
    storage = "local-lvm"
  }

  # Network Configuration
  network {

    model   = "virtio"  # Network interface model
    bridge  = "vmbr1"   # Proxmox network bridge
  }

  # Cloud-Init Configuration (Optional)
  ciuser    = "root" # Cloud-Init user
  cipassword = "cricbuzz" # Password for Cloud-Init root user
}
