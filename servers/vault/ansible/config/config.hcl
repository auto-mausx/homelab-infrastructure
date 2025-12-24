ui            = true
cluster_addr  = "https://127.0.0.1:8201"
api_addr      = "http://127.0.0.1:8200"
disable_mlock = true

storage "file" {
  path = "/mnt/vault/data"
}

listener "tcp" {
  address       = "172.16.1.7:8200"
  tls_disable   = "true"
}

