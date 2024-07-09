output "ip_address" {
  value = scaleway_instance_server.vps_instance.public_ip
  description = "The public IP address of the server."
}

output "cloudflare_record_app" {
  value = cloudflare_record.a_record_app
}

output "cloudflare_record_traefik" {
  value = cloudflare_record.a_record_traefik
}