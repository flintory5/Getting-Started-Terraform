# Bucket name
variable "bucket_name" {
  type        = string
  description = "The unique name for the s3 bucket"
}

# ELB service account arn
variable "elb_service_account_arn" {
  type        = string
  description = "The unique arn for the ELB Service Account"
}

#Common tags
variable "common_tags" {
  type        = map(string)
  description = "The tags to apply to resources"
  default     = {}
}