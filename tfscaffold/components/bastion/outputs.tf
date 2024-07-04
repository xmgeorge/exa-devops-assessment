output "bastion_ip_address" {
  description = "The public IP address assigned to the instance"
  value       = module.ec2_instance.public_ip
}
