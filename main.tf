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

