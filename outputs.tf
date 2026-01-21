output "public_ip_address" {
  description = "Public IP address of the VM"
  value       = azurerm_public_ip.demo.ip_address
}

output "ssh_command" {
  description = "SSH command to connect to the VM"
  value       = "ssh ${var.admin_username}@${azurerm_public_ip.demo.ip_address}"
}

output "nginx_url" {
  description = "URL to access NGINX"
  value       = "http://${azurerm_public_ip.demo.ip_address}"
}

output "private_key" {
  description = "Private SSH key (sensitive)"
  value       = tls_private_key.demo.private_key_pem
  sensitive   = true
}
