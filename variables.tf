variable "terraform_organizations" {
  description = "List of HCP Terraform organizations"
  type        = list(string)
  default     = []
}

variable "s3_bucket_name_audit_trail" {
  description = "The name of the S3 bucket to store audit trail logs"
  type        = string
}