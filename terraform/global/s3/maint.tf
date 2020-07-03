#Créer mes ressources que je vais utiliser pour mon remote-backend
terraform{
    required_version=">= 0.12, < 0.13"
}

provider "aws"{
    region="eu-west-3"
}

resource "aws_s3_bucket" "remote_bucket_terraform" {  
  bucket = "yassir-bucket-terraform-remote-state-example"  
  tags = {
    Name        = "terraform-Yassir-bucket"
    Environment = "Dev"
  }

 # Prevent accidental deletion of this S3 bucket
  lifecycle {
    prevent_destroy = true
  }

  # Enable versioning so we can see the full revision history of our
  # state files
  versioning {
    enabled = true
  }

  # Enable server-side encryption by default
  server_side_encryption_configuration {
    rule {
      apply_server_side_encryption_by_default {
        sse_algorithm = "AES256"
      }
    }
  }

}

resource "aws_dynamodb_table" "basic-dynamodb-table" {
  name           = "yassir-dynamodb-terraform-remote-state-1"
  billing_mode   = "PAY_PER_REQUEST"
  # Clé primaire
  hash_key       = "LockID" 
  
  attribute {
    name = "LockID"
    # type string
    type = "S" 
  }

  tags = {
    Name        = "yassir-dynamodb-table-example-terraform"
    Environment = "dev"
  }
}