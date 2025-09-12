variable "project" {
  description = "Project/Tag Name"
  type = string
  default = "S3-Lifecycle-Glacier"
}

variable "region" {
  description = "AWS Region"
  type = string
  default = "us-west-1"
}

variable "bucket_name" {
  description = "Globally-Unique Bucket Name"
  type = string
}

variable "transition_days_ia" {
  description = "Days before moving to STANDARD_IA"
  type = number
  default = 30
}

variable "transition_days_glacier" {
  description = "Days before moving to Glacier"
  type = number
  default = 120
}

variable "transition_days_deep_archive" {
  description = "Days before moving to Deep Archive"
  type = number
  default = 180
}

variable "expire_days_current" {
  description = "Expire current object version after N Days"
  type = number
  default = 365
}

variable "noncurrent_days_glacier_ir" {
  description = "Noncurrent transition to GLACIER_IR after N Days"
  type = number
  default = 30
}



