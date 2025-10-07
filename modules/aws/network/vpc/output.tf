output "id" {
  value = aws_vpc.this.id
}

output "arn" {
  value = aws_vpc.this.arn
}

output "public_subent_ids" {
  value = aws_subnet.public[*].id
}

output "private_subent_ids" {
  value = aws_subnet.private[*].id
}