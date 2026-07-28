output "pypi_server_url" {
  description = "The URL of the self-hosted PyPI server."
  value       = "http://${aws_instance.pypi_server.public_ip}:8080"
}