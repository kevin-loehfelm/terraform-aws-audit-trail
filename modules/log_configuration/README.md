## Requirements

No requirements.

## Providers

| Name | Version |
|------|---------|
| <a name="provider_aws"></a> [aws](#provider\_aws) | n/a |
| <a name="provider_tfe"></a> [tfe](#provider\_tfe) | n/a |
| <a name="provider_time"></a> [time](#provider\_time) | n/a |

## Modules

No modules.

## Resources

| Name | Type |
|------|------|
| [aws_appfabric_app_authorization.this](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/appfabric_app_authorization) | resource |
| [aws_appfabric_app_authorization_connection.this](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/appfabric_app_authorization_connection) | resource |
| [aws_appfabric_ingestion.this](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/appfabric_ingestion) | resource |
| [aws_appfabric_ingestion_destination.ocsf_json](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/appfabric_ingestion_destination) | resource |
| [tfe_audit_trail_token.this](https://registry.terraform.io/providers/hashicorp/tfe/latest/docs/resources/audit_trail_token) | resource |
| [time_rotating.this](https://registry.terraform.io/providers/hashicorp/time/latest/docs/resources/rotating) | resource |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_app_bundle_arn"></a> [app\_bundle\_arn](#input\_app\_bundle\_arn) | Amazon Resource Name (ARN) of the AppFabric app bundle | `string` | n/a | yes |
| <a name="input_firehose_stream_name"></a> [firehose\_stream\_name](#input\_firehose\_stream\_name) | Name of the Kinesis Firehose delivery stream | `string` | n/a | yes |
| <a name="input_prefix"></a> [prefix](#input\_prefix) | Prefix for resource naming | `string` | `"terraform-audit-trail"` | no |
| <a name="input_terraform_organization"></a> [terraform\_organization](#input\_terraform\_organization) | Name of HCP Terraform organization | `string` | n/a | yes |

## Outputs

No outputs.
