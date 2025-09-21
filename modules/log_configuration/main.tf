# Resource(s): Token Rotation
resource "time_rotating" "this" {
  rotation_days = 30
}

# Resource(s): AppFabric Audit Trail to Kinesis Firehose
resource "tfe_audit_trail_token" "this" {
  organization = var.terraform_organization
  expired_at   = time_rotating.this.rotation_rfc3339
}

# Resource(s): AppFabric Authorization
resource "aws_appfabric_app_authorization" "this" {
  app            = "TERRAFORMCLOUD"
  app_bundle_arn = var.app_bundle_arn
  auth_type      = "apiKey"

  credential {
    api_key_credential {
      api_key = tfe_audit_trail_token.this.token
    }
  }
  tenant {
    tenant_display_name = var.terraform_organization
    tenant_identifier   = var.terraform_organization
  }
}

# Resource(s): AppFabric Authorization Connection
resource "aws_appfabric_app_authorization_connection" "this" {
  app_authorization_arn = aws_appfabric_app_authorization.this.arn
  app_bundle_arn        = var.app_bundle_arn
}

# Resource(s): AppFabric Ingestion
resource "aws_appfabric_ingestion" "this" {
  app            = "TERRAFORMCLOUD"
  app_bundle_arn = var.app_bundle_arn
  tenant_id      = var.terraform_organization
  ingestion_type = "auditLog"
  depends_on = [
    aws_appfabric_app_authorization_connection.this
  ]
}

# Resource(s): AppFabric Ingestion Destination to Kinesis Firehose (OCSF JSON)
resource "aws_appfabric_ingestion_destination" "ocsf_json" {
  app_bundle_arn = var.app_bundle_arn
  ingestion_arn  = aws_appfabric_ingestion.this.arn

  processing_configuration {
    audit_log {
      format = "json"
      schema = "ocsf"
    }
  }

  destination_configuration {
    audit_log {
      destination {
        firehose_stream {
          stream_name = var.firehose_stream_name
        }
      }
    }
  }
}

/**** S3 Example

# Resource(s): AppFabric Ingestion Destination to S3 (OCSF JSON)
resource "aws_appfabric_ingestion_destination" "ocsf_json" {
  app_bundle_arn = var.app_bundle_arn
  ingestion_arn  = aws_appfabric_ingestion.this.arn

  processing_configuration {
    audit_log {
      format = "json"
      schema = "ocsf"
    }
  }

  destination_configuration {
    audit_log {
      destination {
        s3_bucket {
          bucket_name = var.s3_bucket_name
          prefix      = "${var.terraform_organization}/"
        }
      }
    }
  }
}
*/