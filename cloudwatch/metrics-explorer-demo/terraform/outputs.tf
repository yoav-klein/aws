

output "public_dns" {
    description = "Public DNS of the host"
    value = aws_instance.prod_web.public_dns
}
