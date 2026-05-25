terraform {
  backend "s3" {
    bucket         = "starttech-bucket10" # Change this!
    key            = "state/terraform.tfstate"
    region         = "us-east-1"
    encrypt        = true
  }
}
