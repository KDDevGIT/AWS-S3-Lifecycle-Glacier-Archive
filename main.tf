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





