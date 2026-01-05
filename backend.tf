terraform {
  backend "s3" {
    bucket = "terraform-state-bucket-198"
    key    = "github-actions/terraform.tfstate"
    region = "ap-south-1"
  }
}