# String type
variable "environment" {
  type        = string
  default     = "dev"
  description = "Environment name (e.g., dev, prod, staging)"
}

# List type
variable "account_names" {
  type        = set(string)
  description = "List of allowed Azure storage accounts"
  default     = ["pushtutorials1", "pushtutorials2", "pushtutorials3"]
}
