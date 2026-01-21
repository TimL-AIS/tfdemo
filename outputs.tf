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
