# --- Remote State Configuration (Uncomment to enable) ---
# 
# To use this, you must first create:
# 1. An S3 bucket (e.g., "my-terraform-state-bucket")
# 2. A DynamoDB table (e.g., "terraform-lock") with partition key "LockID"
#
# terraform {
#   backend "s3" {
#     bucket         = "CHANGE_ME_TO_YOUR_BUCKET_NAME"
#     key            = "cloudstack-demo/terraform.tfstate"
#     region         = "us-east-1"
#     encrypt        = true
#     dynamodb_table = "terraform-lock"
#   }
# }
