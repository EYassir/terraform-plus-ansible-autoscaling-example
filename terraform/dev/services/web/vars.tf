variable "server_port" {
  description = "The port the server will use for HTTP requests"
  type        = number
  default     = 8080
}

variable "cluster_name" {
  description = "The name to use for all the cluster resources"
  type        = string
  default     = "yassir-dev-cluster-web"
}

variable "key_name" {
  description = "The name of the keypair that will be generated"
  type        = string
  default     = "cluster-slave-key"
}

variable "min_size" {
  description = "The minimum number of EC2 Instances in the ASG"
  type        = number
  default     = 2 
}

variable "max_size" {
  description = "The maximum number of EC2 Instances in the ASG"
  type        = number
  default     = 3
}

variable "slave_user" {
  description = "The name of the slave user to create"
  type        = string
  default     = "ansible"
}

variable "master_public_key" {
  description = "The public ssh key of the master user"
  type        = string
}

variable "remote_bucket" {
  description = "The bucket used for the remote backend"
  type        = string
  default     = "yassir-bucket-terraform-remote-state-example"
}

variable "remote_key" {
  description = "The key name remote backend"
  type        = string
  default     = "remote-state/dev/rds/mysql/terraform.tfstate"
}

variable "remote_region" {
  description = "The region in use"
  type        = string
  default     = "eu-west-3" 
}

variable "image_to_use" {
  description = "The ami image that will be used buy the lkanche configuration"
  type        = string
  default     = "ami-089cc16f7f08c4457"
}

variable "instance_type" {
  description = "The instance type of ec2"
  type        = string
  default     = "t2.micro"
}


