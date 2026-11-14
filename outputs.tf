output "instance_public_ip" {
  description = "Public IPv4 address of the Nginx instance."
  value       = aws_instance.nginx.public_ip
}

output "nginx_url" {
  description = "Open this HTTP URL to see the custom Nginx page."
  value       = "http://${aws_instance.nginx.public_ip}"
}
