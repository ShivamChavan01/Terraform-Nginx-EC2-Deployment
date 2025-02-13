provider "aws" {
  access_key                  = "LKIAQAAAAAAAIOFPSI36"  # Dummy values for LocalStack
  secret_key                  = "p4VoUAkjIKZKyTAQco/KtX5fRIZjDye/DuxJvo+C"
  region                      = "eu-north-1"
  s3_use_path_style           = true
  skip_credentials_validation = true
  skip_requesting_account_id  = true
  skip_metadata_api_check     = true

  # Define LocalStack endpoints
  endpoints {
    s3    = "http://localhost:4566"
    ec2   = "http://localhost:4566"
    iam   = "http://localhost:4566"
    sts   = "http://localhost:4566"
    rds   = "http://localhost:4566"
    lambda = "http://localhost:4566"
  }
}