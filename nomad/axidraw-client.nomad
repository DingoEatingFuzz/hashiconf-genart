client {
  enabled = true
  servers = ["1.2.3.4:4647", "5.6.7.8:4647"]

  reserved {
    cpu    = 500
    memory = 512
    disk   = 1024
  }

  meta {
  	axidraw = "true"
  }
}