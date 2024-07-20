output "ip_address" {
  value = digitalocean_droplet.web.ipv4_address
  description = "The public IP address of the server."
}

# output "cloudflare_record_app" {
#   value = cloudflare_record.a_record_app
# }
#
# output "cloudflare_record_traefik" {
#   value = cloudflare_record.a_record_traefik
# }