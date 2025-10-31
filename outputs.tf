output "vpc_name" {
  value       = data.aws_vpc.default.tags["Name"]
  description = "The name tag of the default VPC"
}

output "vpc_owner_id" {
  value       = data.aws_vpc.default.owner_id
  description = "The owner ID of the default VPC"
}

