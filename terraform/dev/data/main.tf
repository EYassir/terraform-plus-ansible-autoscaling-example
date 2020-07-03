#Créer ma base de données rds - mysql
terraform{
    required_version=">= 0.12, < 0.13"
    backend "s3"{
        region = "eu-west-3"
        bucket = "yassir-bucket-terraform-remote-state-example"
        dynamodb_table="yassir-dynamodb-terraform-remote-state-1"
        key="remote-state/dev/rds/mysql/terraform.tfstate"
    }
}

provider "aws"{
    region="eu-west-3"
}

resource "aws_db_instance" "my_rds" { 

  allocated_storage    = 20
  storage_type         = "gp2"
  engine               = "mysql"
  engine_version       = "5.7"
  instance_class       = "db.t2.micro"
  name                 = var.db_name
  username             = "admin"
  password             = var.db_password
  parameter_group_name = "default.mysql5.7"
}