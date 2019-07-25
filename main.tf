locals {
  name_prefix = terraform.workspace == "default" ? var.project.name : "${terraform.workspace}-${var.project.name}"
}

/**
 * Resource policy for the Key
 */
data "aws_iam_policy_document" "main" {
  statement {
    actions   = ["kms:*"]
    effect    = "Allow"
    sid       = "Allow root user to manage the KMS key and enable IAM policies to allow access to the key."
    resources = ["*"]

    principals {
      type        = "AWS"
      identifiers = ["arn:aws:iam::${var.project.account_id}:root"]
    }
  }

  dynamic "statement" {
    // trick to only add ONE statement if var.iam_consumers_arn isn't empty.
    for_each = length(var.iam_consumers_arns) > 0 ? ["foo"] : []

    content {
      actions = [
        "kms:Encrypt",
        "kms:Decrypt",
        "kms:ReEncrypt*",
        "kms:GenerateDataKey*",
        "kms:DescribeKey",
      ]

      effect    = "Allow"
      resources = ["*"]

      principals {
        identifiers = var.iam_consumers_arns
        type        = "AWS"
      }
    }
  }

  dynamic "statement" {
    // trick to only add ONE statement if var.iam_consumers_arn isn't empty.
    for_each = length(var.consuming_aws_services) > 0 ? ["foo"] : []

    content {
      actions = [
        "kms:Encrypt",
        "kms:Decrypt",
        "kms:ReEncrypt*",
        "kms:GenerateDataKey*",
        "kms:DescribeKey",
      ]

      effect    = "Allow"
      resources = ["*"]

      principals {
        identifiers = var.consuming_aws_services
        type        = "Service"
      }
    }
  }
}

/**
 * The KMS key.
 */
resource "aws_kms_key" "main" {
  description         = var.description
  enable_key_rotation = true
  policy              = data.aws_iam_policy_document.main.json
  tags                = var.project.tags
}

/**
 * Alias for the KMS key
 */
resource "aws_kms_alias" "main" {
  name_prefix   = "alias/${local.name_prefix}-${var.name}-"
  target_key_id = aws_kms_key.main.id
}
