## aws_s3_bucket_objects
module "web_app_s3" {
  source = "./modules/globo-web-app-s3"

  bucket_name             = local.s3_bucket_name
  elb_service_account_arn = data.aws_elb_service_account.root.arn
  common_tags             = local.common_tags
}

resource "aws_s3_bucket_object" "website_content" {
  for_each = {
    website = "/website/index.html"
    logo    = "/website/Globo_logo_Vert.png"
  }
  bucket = module.web_app_s3.bucket_object.id
  key    = each.value
  source = ".${each.value}"

  tags = local.common_tags
}

