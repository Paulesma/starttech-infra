terraform {
  backend "s3" {
    bucket       = "starttech-bucket10"
    key          = "prod/terraform.tfstate" # This path can be whatever you like
    region       = "us-east-1"              # Ensure this matches your bucket's region
    use_lockfile = true                     # Replaces the deprecated dynamodb_table
  }
}



