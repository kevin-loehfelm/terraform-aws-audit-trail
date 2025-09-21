# Resource(s): IAM Role Trust Policy
data "aws_iam_policy_document" "firehose_assume_role" {
  statement {
    effect = "Allow"

    principals {
      type        = "Service"
      identifiers = ["firehose.amazonaws.com"]
    }

    actions = ["sts:AssumeRole"]
  }
}

# Resource(s): IAM Policy for Firehose Stream
data "aws_iam_policy_document" "firehose_policy" {
  statement {
    effect = "Allow"

    actions = [
      "s3:AbortMultipartUpload",
      "s3:GetBucketLocation",
      "s3:GetObject",
      "s3:ListBucket",
      "s3:ListBucketMultipartUploads",
      "s3:PutObject",
    ]

    resources = [
      aws_s3_bucket.this.arn,
      "${aws_s3_bucket.this.arn}/*",
    ]
  }
}

# Resource(s): IAM Role for Firehose Stream
resource "aws_iam_role" "firehose" {
  name               = "hcp-terraform-audit-firehose-role"
  path               = "/service-role/"
  assume_role_policy = data.aws_iam_policy_document.firehose_assume_role.json
}

# Resource(s): IAM Policy for Firehose Stream
resource "aws_iam_policy" "firehose" {
  name   = "hcp-terraform-audit-firehose-policy"
  policy = data.aws_iam_policy_document.firehose_policy.json
}

# Resource(s): IAM Role Policy Attachment for Firehose Stream
resource "aws_iam_role_policy_attachment" "firehose" {
  role       = aws_iam_role.firehose.name
  policy_arn = aws_iam_policy.firehose.arn
}

# Resource(s): S3 Bucket for HCP Audit Trails
resource "aws_s3_bucket" "this" {
  bucket        = var.s3_bucket_name_audit_trail
  force_destroy = true
}

# Resource(s): S3 Bucket Versioning Configuration
resource "aws_s3_bucket_versioning" "this" {
  bucket = aws_s3_bucket.this.id

  versioning_configuration {
    status = "Enabled"
  }
}

# Resource(s): S3 Bucket Server-Side Encryption Configuration
resource "aws_s3_bucket_server_side_encryption_configuration" "this" {
  bucket = aws_s3_bucket.this.id

  rule {
    apply_server_side_encryption_by_default {
      sse_algorithm = "AES256"
    }
  }
}

# Resource(s): S3 Bucket Public Access Block Configuration
resource "aws_s3_bucket_public_access_block" "this" {
  bucket = aws_s3_bucket.this.id

  block_public_acls       = true
  block_public_policy     = true
  ignore_public_acls      = true
  restrict_public_buckets = true
}

# Resource(s): AppFabric App Bundle
resource "aws_appfabric_app_bundle" "this" {}

# Resource(s): Kinesis Firehose Delivery Stream to S3
resource "aws_kinesis_firehose_delivery_stream" "this" {
  name        = "hcp-terraform-audit-firehose"
  destination = "extended_s3"

  extended_s3_configuration {
    role_arn            = aws_iam_role.firehose.arn
    bucket_arn          = aws_s3_bucket.this.arn
    prefix              = "log/"
    error_output_prefix = "error/"

    cloudwatch_logging_options {
      enabled = false
    }

    processing_configuration {
      enabled = false
    }
  }

  server_side_encryption {
    enabled  = false
    key_type = "AWS_OWNED_CMK"
  }

  tags = {
    "AWSAppFabricManaged" = "true"
  }
}

# Module(s): Log Configuratoin for HCP Terraform Organization(s)
module "audit_configuration" {
  source = "./modules/log_configuration"

  for_each = toset(var.terraform_organizations)

  terraform_organization = each.value
  app_bundle_arn         = aws_appfabric_app_bundle.this.arn
  firehose_stream_name   = aws_kinesis_firehose_delivery_stream.this.name
}