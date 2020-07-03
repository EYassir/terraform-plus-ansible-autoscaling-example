variable "my_server_port" {
  description = "The port the server will use for HTTP requests"
  type        = number
}

variable "my_cluster_name" {
  description = "The name to use for all the cluster resources"
  type        = string
}

variable "my_key_name" {
  description = "The name to use for the key pair"
  type        = string
}

variable "min_size" {
  description = "The minimum number of EC2 Instances in the ASG"
  type        = number
}

variable "max_size" {
  description = "The maximum number of EC2 Instances in the ASG"
  type        = number
}

variable "my_slave_user" {
  description = "The name of the slave user to create"
  type        = string
}

variable "my_master_public_key" {
  description = "The public ssh key of the master user"
  type        = string
}

variable "my_remote_bucket" {
  description = "The bucket used for the remote backend"
  type        = string
}

variable "my_remote_key" {
  description = "The key name remote backend"
  type        = string
}

variable "my_remote_region" {
  description = "The region in use"
  type        = string
}

variable "my_image_to_use" {
  description = "The ami image that will be used buy the lkanche configuration"
  type        = string
}

variable "my_instance_type" {
  description = "The instance type of ec2"
  type        = string
}
