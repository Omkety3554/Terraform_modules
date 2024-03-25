# store the terraform statefile in S3 and lock with dynamodb
terraform {
  backend "s3" {
    bucket            = "omkety3554-terraform-remote-state"
    key               = "terraform-module/hemqew/terraform.tfstate"
    region            = "us-east-1"
    profile           = "olatunji"
    dynamodb_table    = "terraform-state-lock"
  }
}