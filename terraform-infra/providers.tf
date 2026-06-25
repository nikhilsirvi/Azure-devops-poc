// Default provider
provider "aws" {
  region = var.aws_region
assume_role {
    role_arn = var.assume_role_arn
  }
  default_tags {
    tags = local.common_tags
  }
}
// for cloudfront WAF
provider "aws" {
  alias  = "virginia"
  region = "us-east-1"
  assume_role {
    role_arn = var.assume_role_arn
  }
  default_tags {
    tags = local.common_tags
  }
}