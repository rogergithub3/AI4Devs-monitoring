locals {
  timestamp = formatdate("YYYYMMDDHHmmss", timestamp())
  bucket_name = "${var.s3_bucket_name}-${local.timestamp}"
}

resource "aws_s3_bucket" "code_bucket" {
  bucket = local.bucket_name
  tags   = var.tags

  force_destroy = true
}

resource "aws_s3_bucket_ownership_controls" "bucket_ownership" {
  bucket = aws_s3_bucket.code_bucket.id
  rule {
    object_ownership = "BucketOwnerPreferred"
  }
}

resource "aws_s3_bucket_acl" "bucket_acl" {
  depends_on = [
    aws_s3_bucket.code_bucket,
    aws_s3_bucket_ownership_controls.bucket_ownership
  ]
  bucket = aws_s3_bucket.code_bucket.id
  acl    = "private"
}

output "bucket_name" {
  value = aws_s3_bucket.code_bucket.bucket
  description = "The name of the S3 bucket created"
}
