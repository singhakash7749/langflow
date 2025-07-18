output "ec2_public_ip" {
  description = "Public IP of LangFlow EC2 instance"
  value       = aws_instance.langflow_ec2.public_ip
}

