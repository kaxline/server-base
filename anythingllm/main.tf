terraform {
  required_version = ">= 1.0.0"

  required_providers {
    digitalocean = {
      source  = "digitalocean/digitalocean"
      version = "~> 2.39.2"
    }

#     vultr = {
#       source = "vultr/vultr"
#       version = "2.21.0"
#     }

    cloudflare = {
      source  = "cloudflare/cloudflare"
      version = "~> 4.36.0"
    }

  }
}

provider "digitalocean" {
  token = var.do_token
}

# provider "vultr" {
#   api_key = var.vultr_api_key
#   rate_limit = 100
#   retry_limit = 3
# }


provider "cloudflare" {
  api_token = var.cloudflare_api_token
}

resource "digitalocean_droplet" "web" {
  image  = "ubuntu-24-04-x64"
  name   = var.do_droplet_name
  region = var.do_region
  size   = var.do_size

#   depends_on = [digitalocean_volume.app_data]

  user_data = templatefile("${path.module}/user_data.tftpl", {
    sudo_username = var.sudo_username
    sudo_password = var.sudo_password
    repo_url = var.repo_url
    repo_access_token = var.repo_access_token
    domain_name = var.domain_name
    traefik_domain_name = var.traefik_domain_name
    letsencrypt_email = var.letsencrypt_email
    dir_name = var.dir_name
    app_dir_path = var.app_dir_path
    root_password = var.root_password
    do_volume_name = var.do_volume_name
  })
}

resource "digitalocean_volume" "journodao_anythingllm_data" {
  size     = 100
  name     = var.do_volume_name
  region   = var.do_region
  initial_filesystem_type = "ext4"
}

resource "digitalocean_volume_attachment" "journodao_anythingllm_data_attach" {
  droplet_id = digitalocean_droplet.web.id
  volume_id  = digitalocean_volume.journodao_anythingllm_data.id
}

# resource "vultr_instance" "my_instance" {
#     plan = "vc2-1c-2gb"
#     region = "sea"
#     os_id = 1743
# }

resource "cloudflare_record" "a_record_app" {
  zone_id = var.cloudflare_zone_id
  name    = var.domain_name
  value   = digitalocean_droplet.web.ipv4_address
  type    = "A"
  ttl     = 1
}

resource "cloudflare_record" "a_record_traefik" {
  zone_id = var.cloudflare_zone_id
  name    = var.traefik_domain_name
  value   = digitalocean_droplet.web.ipv4_address
  type    = "A"
  ttl     = 1
}

