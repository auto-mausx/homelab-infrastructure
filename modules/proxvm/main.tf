# Proxmox Full-Clone
# ---
# Create a new VM from a clone

resource "proxmox_vm_qemu" "your-vm" {

  # VM General Settings
  target_node = "prox"
  vmid        = "101"
  name        = "dns-server"
  desc        = "Bind9 container DNS server VM"

  # VM Advanced General Settings
  onboot = true

  # VM OS Settings
  clone      = "ubuntu-server-docker"
  full_clone = false

  # VM System Settings
  agent = 1

  # VM CPU Settings
  cores   = 2
  sockets = 1
  cpu     = "host"

  # VM Memory Settings
  memory = 2048

  # VM Network Settings
  network {
    bridge = "vmbr0"
    model  = "virtio"
  }

  disks {
    ide {
      ide0 {
        cloudinit {
          storage = "vm-storage"
        }
      }
    }
    virtio {
      virtio0 {
        disk {
          size    = 20
          storage = "vm-storage"
        }
      }
    }
  }

  dynamic "disks" {
    for_each = var.disk
    content {
      dynamic "type" {
        for_each = disks.type.value
        content {
          dynamic "int" {
            for_each = type.int
            content {
              storage = int["storage"]
            }
          }
        }
      }
    }
  }

  # VM Cloud-Init Settings
  os_type = var.os_type

  # (Optional) IP Address and Gateway
  ipconfig0 = var.ipconfig

  # (Optional) Default User
  ciuser = var.ciuser

  # (Optional) Add your SSH KEY
  sshkeys = <<EOF
  "${var.ssh_pub_key}"
  EOF
}