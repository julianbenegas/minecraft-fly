terraform {
  required_providers {
    fly = {
      source = "fly-apps/fly"
      version = "0.0.20"
    }
  }
}

provider "fly" {
  useinternaltunnel    = true
  internaltunnelorg    = "personal"
  internaltunnelregion = "eze"
}

resource "fly_app" "minecraft" {
  name = "minecraft-jbtc"
  org  = "personal"
}

resource "fly_volume" "mcVolume" {
  app    = "minecraft-jbtc"
  name   = "mcVolume"
  size   = 15
  region = "eze"

  depends_on = [fly_app.minecraft]
}

resource "fly_ip" "mcIP" {
  app  = "minecraft-jbtc"
  type = "v4"

  depends_on = [fly_app.minecraft]
}

resource "fly_machine" "mcServer" {
  name   = "mc-server"
  region = "eze"
  app    = "minecraft-jbtc"
  image  = "itzg/minecraft-server:latest"

  env = {
    EULA                    = "TRUE"
    ENABLE_AUTOSTOP         = "TRUE"
    AUTOSTOP_TIMEOUT_EST    = 120
    AUTOSTOP_TIMEOUT_INIT   = 120
    MEMORY                  = "7G"
    AUTOSTOP_PKILL_USE_SUDO = "TRUE"
  }

  services = [
    {
      ports = [
        {
          port = 25565
        }
      ]
      protocol      = "tcp"
      internal_port = 25565
    }
  ]

  mounts = [
    { path   = "/data"
      volume = fly_volume.mcVolume.id
    }
  ]

  cpus     = 4
  memorymb = 8192

  depends_on = [fly_volume.mcVolume, fly_app.minecraft]
}
