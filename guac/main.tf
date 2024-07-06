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

provider "scaleway" {
  count             = var.provider == "scaleway" ? 1 : 0
  access_key        = var.scaleway_access_key
  secret_key        = var.scaleway_secret_key
  organization_id   = var.scaleway_organization_id
  region            = "nl-ams" # Adjust this according to your needs
  zone              = "nl-ams-3" # Adjust this according to your needs
}


provider "digitalocean" {
  count = var.provider == "digitalocean" ? 1 : 0
  token = var.do_token
}

resource "scaleway_instance_server" "vps_instance" {
  count       = var.provider == "scaleway" ? 1 : 0
  name        = var.scaleway_name
  image       = var.scaleway_image
  type = var.scaleway_type

  dynamic_ip_required = true
  enable_ipv6         = true

  key = var.ssh_key

  user_data = templatefile("user_data.tp1", {
    env_content = local.env_content
    sudo_username = var.sudo_username
    sudo_password = var.sudo_password
    repo_url = var.repo_url
    repo_access_token = var.repo_access_token
    domain_name = var.domain_name
    letsencrypt_email = var.letsencrypt_email
  })
}

provider "cloudflare" {
  api_token = var.cloudflare_api_token
}



resource "digitalocean_droplet" "web" {
  image  = "ubuntu-24-04-x64"
  name   = var.do_droplet_name
  region = var.do_region
  size   = var.do_size

  user_data = templatefile("user_data.tp1", {
    env_content = local.env_content
    sudo_username = var.sudo_username
    sudo_password = var.sudo_password
    repo_url = var.repo_url
    repo_access_token = var.repo_access_token
    domain_name = var.domain_name
    letsencrypt_email = var.letsencrypt_email
  })
}

resource "cloudflare_record" "a_record" {
  zone_id = var.cloudflare_zone_id
  name    = var.domain_name
  value   = digitalocean_droplet.web.ipv4_address
  type    = "A"
  ttl     = 1
}

resource "local_file" "env_file" {
  content  = templatefile("${path.module}/env.tmpl", {
    db_name     = var.guacamole_db,
    db_user     = var.guacamole_user,
    db_password = var.guacamole_password
    letsenrypt_email = var.letsencrypt_email
  })
  filename = "${path.module}/.env"
}

output "droplet_ip" {
  value = digitalocean_droplet.web.ipv4_address
}

output "cloudflare_record" {
  value = cloudflare_record.a_record
}

locals {
  env_content = file("./.env")
}
