
variable "active_provider" {
  description = "The cloud provider to use"
  type        = string
  default     = "scaleway"
}

variable "provider_choice" {
  description = "The provider to use. Allowed values: scaleway, digitalocean"
  type        = string
  default     = "scaleway"
}


variable "scaleway_access_key" {
  description = "The access key for the Scaleway API"
  type        = string
}

variable "scaleway_secret_key" {
  description = "The secret key for the Scaleway API"
  type        = string
}

variable "scaleway_organization_id" {
  description = "The organization ID for the Scaleway API"
  type        = string
}


variable "scaleway_name" {
    description = "Name of the Scaleway instance"
    type        = string
}

variable "scaleway_type" {
    description = "Architecture of the Scaleway instance"
    type        = string
}

variable "scaleway_image" {
    description = "Image of the Scaleway instance"
    type        = string
}

variable "scaleway_project_id" {
    description = "Project ID for the Scaleway API"
    type        = string
}

variable "ssh_key" {
  description = "Your public SSH key"
  type        = string
}

variable "do_token" {
  type        = string
  description = "DigitalOcean API token"
}

variable "do_droplet_name" {
  type        = string
  description = "Name of the droplet"
  default     = "ubuntu-base-server"
}

variable "do_region" {
  type        = string
  description = "DigitalOcean region"
  default     = "sfo3"
}

variable "do_size" {
  type        = string
  description = "Droplet size"
  default     = "s-2vcpu-4gb"
}

variable "do_image" {
    type        = string
    description = "Droplet image"
    default     = "ubuntu-24-04-x64"
}

variable "sudo_username" {
  type        = string
  description = "Username for the sudo user"
  default     = "your_sudo_user"
}

variable "sudo_password" {
  type        = string
  description = "Password for the sudo user"
}

variable "letsencrypt_email" {
  type        = string
  description = "Email to use for Let's Encrypt certificate generation"
}

variable "repo_url" {
  type        = string
  description = "URL of the GitHub repository to clone"
}

variable "repo_access_token" {
  type        = string
  description = "Github personal access token"
}

variable "domain_name" {
  type        = string
  description = "Domain name for the A record"
}

variable "cloudflare_email" {
  type        = string
  description = "Cloudflare account email"
}

variable "cloudflare_api_token" {
  type        = string
  description = "Cloudflare API key"
}

variable "cloudflare_zone_id" {
  type        = string
  description = "Cloudflare Zone ID"
}

variable "guacamole_db" {
    type        = string
    description = "Guacamole database name"
}

variable "guacamole_user" {
    type        = string
    description = "Guacamole database user"
}

variable "guacamole_password" {
    type        = string
    description = "Guacamole database password"
}

variable "traefik_domain_name" {
    type        = string
    description = "Domain name for Traefik"
}

variable "dir_name" {
    type        = string
    description = "Directory name for the cloned repository"
}

variable "docker_compose_file_path" {
    type        = string
    description = "Path to the docker-compose file"
}
