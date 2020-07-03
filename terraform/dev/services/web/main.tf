terraform {
  required_version = ">= 0.12, < 0.13"
}

provider "aws" {
    region="eu-west-1"
}

module "my_module" {

  source = "../../../modules/services/web"

  my_cluster_name = var.cluster_name
  my_server_port = var.server_port
  my_key_name= var.key_name
  my_slave_user= var.slave_user
  my_master_public_key= var.master_public_key
  min_size = var.min_size
  max_size = var.max_size
  my_remote_region = var.remote_region
  my_remote_key = var.remote_key
  my_remote_bucket = var.remote_bucket
  my_image_to_use = var.image_to_use
  my_instance_type = var.instance_type
}