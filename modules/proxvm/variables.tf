variable "ipconfig" {
  type        = string
  description = "Example: ip=192.168.1.xxx/24,gw=192.168.1.xxx"
}

variable "os_type" {
  type    = string
  default = "cloud-init"
}

variable "ciuser" {
  type    = string
  default = "kmaus"
}

variable "ssh_pub_key" {
  type    = string
  default = "ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAABgQDhbUU61MLQUdz8c6J07EFTKZy2hjR27ZBAsJMIlEHYieUt8WBNPnv5ffi4lvX1Dnv2ovXTpVg3C+62V65EcTQ6aBMyIxu7K9OSG60o2TAY3pni98u9c22H+ACYa6v8zNuWlDYi0FEmqWweYCRI7p0bDJ51bDwfw/ZKiwzJPZf20jBH8AAKW/8iSfC1nNVikfIRbxNNjNYKg+kLKCF+H+jO04lnOXKyQyylUwvIm8CyhYMzirA8EUbVBIWGNTC8azj1HzyQdepiY8+HUc28nnLTmxajTP2Z8vhbQBqgsnCmy9SNJek3CEW+iQ4udYR/ih3j8joRtnltAiLaNqTGwj2yFeWZTu2VNn3b48iYL6gbQaTmq58FFywz8E68bJDvYTYr1DZJOFIiYHQuPKQ3jXPZfC4Z6mnWasXR3WI2niNeD5/l9AnCZjqReJk3eBnX2cHZex3HsGF5iglQ60OCTo9fEPgfj0hLksDzx2m8LB0Yh29Uwye30nC9v6n8OXI3Ce0= kmaus@Kodys-MBP.attlocal.net"
}

variable "disk" {
  type = map(object({
    type = map(object({
      int = map(object({
        storage = string
      }))
    }))
  }))
}