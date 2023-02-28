


output "public_dns" {
    description = "Public DNS of the host"
    value = aws_instance.this[*].public_dns
}
