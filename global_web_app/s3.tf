## aws_s3_bucket
resource "aws_s3_bucket" "web_bucket" {
  bucket = local.s3_bucket_name
  acl = "private"
  force_destroy = true

  tags = local.common_tags
}

## aws_s3_bucket_object

## aws_iam_role

## aws_iam_role_policy

## aws_iam_instance_profile