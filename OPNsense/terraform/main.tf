# Proxmox Full-Clone
# ---
# Create a new VM from a clone

resource "proxmox_vm_qemu" "your-vm" {

  # VM General Settings
  target_node = "prox"
  vmid        = "102"
  name        = "OPNsense"
  desc        = "OPNsense VPN server"

  # VM Advanced General Settings
  onboot   = false
  vm_state = "running"

  # VM OS Settings
  # clone      = "OPNsense"
  # full_clone = false

  # VM System Settings
  agent = 1

  # VM CPU Settings
  cores   = 4
  sockets = 1
  cpu     = "host"

  # VM Memory Settings
  memory = 8192

  # VM Network Settings
  network {
    bridge = "vmbr0"
    model  = "virtio"
  }

  network {
    bridge = "vmbr1"
    model  = "virtio"
  }

  disks {
    scsi {
      scsi0 {
        cdrom {
          iso = "iso-storage:iso/OPNsense-24.7-dvd-amd64.iso"
        }
      }
    }
    virtio {
      virtio0 {
        disk {
          size    = 50
          storage = "vm-storage"
        }
      }
    }
  }

  # VM Cloud-Init Settings
  # os_type = "cloud-init"

  # (Optional) IP Address and Gateway
  ipconfig0 = "ip=dhcp"

  # (Optional) Default User
  ciuser = "kmaus"

  # (Optional) Add your SSH KEY
  sshkeys = <<EOF
  ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAABgQDhbUU61MLQUdz8c6J07EFTKZy2hjR27ZBAsJMIlEHYieUt8WBNPnv5ffi4lvX1Dnv2ovXTpVg3C+62V65EcTQ6aBMyIxu7K9OSG60o2TAY3pni98u9c22H+ACYa6v8zNuWlDYi0FEmqWweYCRI7p0bDJ51bDwfw/ZKiwzJPZf20jBH8AAKW/8iSfC1nNVikfIRbxNNjNYKg+kLKCF+H+jO04lnOXKyQyylUwvIm8CyhYMzirA8EUbVBIWGNTC8azj1HzyQdepiY8+HUc28nnLTmxajTP2Z8vhbQBqgsnCmy9SNJek3CEW+iQ4udYR/ih3j8joRtnltAiLaNqTGwj2yFeWZTu2VNn3b48iYL6gbQaTmq58FFywz8E68bJDvYTYr1DZJOFIiYHQuPKQ3jXPZfC4Z6mnWasXR3WI2niNeD5/l9AnCZjqReJk3eBnX2cHZex3HsGF5iglQ60OCTo9fEPgfj0hLksDzx2m8LB0Yh29Uwye30nC9v6n8OXI3Ce0= kmaus@Kodys-MBP.attlocal.net
  EOF
}