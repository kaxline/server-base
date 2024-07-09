terraform {
  required_version = ">= 1.0.0"

  required_providers {
    digitalocean = {
      source  = "digitalocean/digitalocean"
      version = "~> 2.39.2"
    }

    cloudflare = {
      source  = "cloudflare/cloudflare"
      version = "~> 4.36.0"
    }

    scaleway = {
      source  = "scaleway/scaleway"
      version = "~> 2.41.3"
    }
  }
}

resource "scaleway_instance_user_data" "main" {
  server_id = scaleway_instance_server.vps_instance.id
  key = "cloud-init"
  value = templatefile("${path.module}/user_data.tftpl", {
      sudo_username = var.sudo_username
      sudo_password = var.sudo_password
      repo_url = var.repo_url
      repo_access_token = var.repo_access_token
      domain_name = var.domain_name
      letsencrypt_email = var.letsencrypt_email
      guacamole_db = var.guacamole_db
      guacamole_user = var.guacamole_user
      guacamole_password = var.guacamole_password
      dir_name = var.dir_name
      docker_compose_file_path = var.docker_compose_file_path
      traefik_domain_name = var.traefik_domain_name
    })
}

provider "scaleway" {
  access_key        = var.scaleway_access_key
  secret_key        = var.scaleway_secret_key
  organization_id   = var.scaleway_organization_id
  region            = "nl-ams" # Adjust this according to your needs
  zone              = "nl-ams-3" # Adjust this according to your needs
}


# provider "digitalocean" {
#   token = var.do_token
# }

resource "scaleway_instance_server" "vps_instance" {
  name        = var.scaleway_name
  image       = var.scaleway_image
  type = var.scaleway_type
  ip_id = scaleway_instance_ip.public_ip.id

}

resource "scaleway_instance_ip" "public_ip" {}

resource "scaleway_instance_ip" "server_ip" {
  type = "routed_ipv4"
  zone = "nl-ams-3"
  project_id = var.scaleway_project_id
}

provider "cloudflare" {
  api_token = var.cloudflare_api_token
}



# resource "digitalocean_droplet" "web" {
#   image  = "ubuntu-24-04-x64"
#   name   = var.do_droplet_name
#   region = var.do_region
#   size   = var.do_size
#
#   user_data = templatefile("user_data.tftpl", {
#     sudo_username = var.sudo_username
#     sudo_password = var.sudo_password
#     repo_url = var.repo_url
#     repo_access_token = var.repo_access_token
#     domain_name = var.domain_name
#     letsencrypt_email = var.letsencrypt_email
#   })
# }

resource "cloudflare_record" "a_record_app" {
  zone_id = var.cloudflare_zone_id
  name    = var.domain_name
  value   = scaleway_instance_ip.server_ip.address
  type    = "A"
  ttl     = 1
}

resource "cloudflare_record" "a_record_traefik" {
  zone_id = var.cloudflare_zone_id
  name    = var.traefik_domain_name
  value   = scaleway_instance_ip.server_ip.address
  type    = "A"
  ttl     = 1
}

resource "local_file" "env_file" {
  content  = templatefile("${path.module}/env.tftpl", {
    db_name     = var.guacamole_db,
    db_user     = var.guacamole_user,
    db_password = var.guacamole_password
    letsencrypt_email = var.letsencrypt_email
    docker_compose_file_path = var.docker_compose_file_path
    domain_name = var.domain_name
    traefik_domain_name = var.traefik_domain_name
    guacamole_db = var.guacamole_db
  })
  filename = "/home/${var.sudo_username}/${var.docker_compose_file_path}/.env"
}

# locals {
#   active_provider = var.active_provider == "scaleway" ? scaleway : digitalocean
# }
