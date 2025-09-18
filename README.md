# AWS S3 Lifecycle Rules & Glacier Archival
Provisions a secure S3 bucket with versioning, encryption, and lifecycle rules to automatically transition data through storage classes (Standard → IA → Glacier → Deep Archive) for cost-optimized archival.

This project creates a secure S3 bucket with:
- Versioning + default server-side encryption
- Public access blocked
- TLS-only + deny unencrypted uploads bucket policy
- Lifecycle policy targeting the `cold/` prefix that transitions objects over time:
  - → STANDARD_IA @ 30 days
  - → GLACIER Instant Retrieval @ 60 days
  - → GLACIER (Flexible Retrieval) @ 120 days
  - → DEEP_ARCHIVE @ 180 days
  - Expire current versions @ 365 days
  - Noncurrent versions → GLACIER_IR @ 30 days, → DEEP_ARCHIVE @ 120 days, expire @ 400 days
  - Abort incomplete multipart uploads @ 7 days

> Tip: Put files that should age into Glacier under `cold/` (e.g., `cold/reports/2025-01-01.csv`).

## Prereqs
- Terraform >= 1.6
- AWS CLI configured (`aws sts get-caller-identity` should work)
- AWS provider >= 5.50

## Usage

```bash
## Clone and enter
git clone <your-new-repo-url>.git s3-lifecycle-glacier
cd s3-lifecycle-glacier
```
## Set a globally-unique bucket name
```bash
export BUCKET_NAME="kyler-week8-lifecycle-<random>"
```

## Create a tfvars or pass via CLI
```bash
cat > terraform.tfvars <<EOF
bucket_name = "${BUCKET_NAME}"
region      = "us-east-1"
EOF
```

## Terraform Init, plan, apply
```bash
terraform init
terraform plan
terraform apply -auto-approve
```
