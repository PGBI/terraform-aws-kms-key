output "arn" {
  description = "ARN of the generated KMS key."
  value       = aws_kms_key.main.arn
}

output "alias" {
  description = "Alias name of the key."
  value       = aws_kms_alias.main.name
}
