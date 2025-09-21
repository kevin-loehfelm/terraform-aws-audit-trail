variable "terraform_organization" {
  description = "Name of HCP Terraform organization"
  type        = string
}

variable "app_bundle_arn" {
  description = "Amazon Resource Name (ARN) of the AppFabric app bundle"
  type        = string
}

variable "firehose_stream_name" {
  description = "Name of the Kinesis Firehose delivery stream"
  type        = string
}