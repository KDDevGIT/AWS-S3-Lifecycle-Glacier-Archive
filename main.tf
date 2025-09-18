locals {
  tags = {
    Project = var.project
    Owner = "Kyler"
    Env = "dev"
  }
}

resource "aws_s3_bucket" "this" {
  bucket = var.bucket_name
  tags = local.tags
}

# Block all public access (default)
resource "aws_s3_bucket_public_access_block" "this" {
  bucket = aws_s3_bucket.this.id 
  block_public_acls = true 
  block_public_policy = true 
  ignore_public_acls = true 
  restrict_public_buckets = true 
}

# For Access Control Lists in some regions, keeps same ownership
resource "aws_s3_bucket_ownership_controls" "this" {
  bucket = aws_s3_bucket.this.id 
  rule {
    object_ownership = "BucketOwnerPreferred"
  }
}

# Default Encryption (AES256) 
resource "aws_s3_bucket_server_side_encryption_configuration" "this" {
  bucket = aws_s3_bucket.this.id 
  rule {
    apply_server_side_encryption_by_default {
      sse_algorithm = "AES256"
    }
  }
}

# Versioning for Robust Lifecycle Rules
resource "aws_s3_bucket_versioning" "this" {
  bucket = aws_s3_bucket.this.id 
  versioning_configuration {
    status = "Enabled"
  }
}

# Enforce TLS-Only
# Deny unencrypted uploads
data "aws_iam_policy_document" "bucket_policy" {
  statement {
    sid = "DenyInsecureTransport"
    effect = "Deny"
    actions = ["s3:*"]
    resources = [
      aws_s3_bucket.this.arn, 
      "${aws_s3_bucket.this.arn}/*"
    ]
    principals {
      type = "*"
      identifiers = ["*"]
    }
    condition {
      test = "Bool"
      variable = "aws:SecureTransport"
      values = ["false"]
    }
  }

  statement {
    sid = "DenyUnEncryptedObjectUploads"
    effect = "Deny"
    actions = ["s3:PutObject"]
    resources = [
      "${aws_s3_bucket.this.arn}/*"
    ]
    principals {
      type = "*"
      identifiers = ["*"]
    }
    condition {
      test = "StringNotEquals"
      variable = "s3:x-amz-server-side-encryption"
      values = ["AES256", "aws:kms"]
    }
  }
}



