# AWS KMS Key module

This module is a simple wrapper around the AWS resource `aws_kms_key` which:
   * creates a kms key with key rotation enabled,
   * creates an alias name for the key,
   * attach a policy to the key allowing the root user to use it and enabling IAM policies to allow access to the key.

Usage:

```hcl
module "project" {
  source  = "PGBI/project/aws"
  version = "~>0.1.0"

  name     = "myProject"
  vcs_repo = "github.com/account/project"
}

/**
 * Creates a kms key whose name will be "prod-myProject-myKey" if the terraform workspace is "prod", allow
 * the IAM users john and lisa to use it, and allow the Cloudwatch Logs AWS service to use it.
 */
module "key" {
  source  = "PGBI/kms-key/aws"
  version = "~>0.1.0"

  name               = "myKey"
  project            = module.project

  iam_consumers_arns = [
    "arn:aws:iam::${module.project.account_id}:user/john",
    "arn:aws:iam::${module.project.account_id}:user/lisa",
  ]

  consuming_aws_services = [
    "logs.amazonaws.com"
  ]
}
```
