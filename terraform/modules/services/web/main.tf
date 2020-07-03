#MODULE/SERVICES/WEB/MAIN.TF
terraform {
  required_version = ">= 0.12, < 0.13"
}

data "terraform_remote_state" "db_mysql" {
    backend = "s3"
    config = {
      bucket = var.my_remote_bucket 
      key    = var.my_remote_key    
      region = var.my_remote_region
    }
}

// resource "tls_private_key" "example" {
//   algorithm = "RSA"
//   rsa_bits  = 4096
// }

// resource "aws_key_pair" "generated_key" {
//   key_name   = var.my_key_name
//   public_key = tls_private_key.example.public_key_openssh
// }

resource "aws_launch_configuration" "example_lc" {
  image_id        = var.my_image_to_use
  instance_type   = var.my_instance_type
  security_groups = [aws_security_group.web_instance_sg.id]
  //key_name=aws_key_pair.generated_key.key_name
  key_name=var.my_key_name
  user_data = data.template_file.user_data.rendered
  
  lifecycle {
    create_before_destroy = true
  }
}

data "template_file" "user_data" {
  template = file("${path.module}/user_data.sh")

  vars = {
    slave_user = var.my_slave_user
    master_public_key = var.my_master_public_key    
  }
}


resource "aws_autoscaling_group" "example_asg" {
  launch_configuration = aws_launch_configuration.example_lc.name
  
  vpc_zone_identifier  = data.aws_subnet_ids.default_subnets_ids.ids

  target_group_arns = [aws_lb_target_group.example_tg.arn]
  health_check_type = "ELB"

  min_size = var.min_size
  max_size = var.max_size

  tag {
    key                 = "Name"
    value               = var.my_cluster_name
    propagate_at_launch = true
  }
}

resource "aws_security_group" "web_instance_sg" {
  name = "${var.my_cluster_name}-web-instance-sg"

  ingress {
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    from_port   = var.my_server_port
    to_port     = var.my_server_port
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

}

#utiliser pour récupérer les informations d'une ressource distante
data "aws_vpc" "default" {
  default = true
}

data "aws_subnet_ids" "default_subnets_ids" {
  vpc_id = data.aws_vpc.default.id
}



resource "aws_lb_target_group" "example_tg" {

  name = var.my_cluster_name

  port     = var.my_server_port
  protocol = "HTTP"
  vpc_id   = data.aws_vpc.default.id

  health_check {
    path                = "/"
    protocol            = "HTTP"
    matcher             = "200"
    interval            = 15
    timeout             = 3
    healthy_threshold   = 2
    unhealthy_threshold = 2
  }
}


resource "aws_lb" "example_lb" {

  name = var.my_cluster_name

  load_balancer_type = "application"
  subnets            = data.aws_subnet_ids.default_subnets_ids.ids
  security_groups    = [aws_security_group.alb.id]
}

resource "aws_lb_listener" "http" {
  load_balancer_arn = aws_lb.example_lb.arn
  port              = 80
  protocol          = "HTTP"

  # By default, return a simple 404 page
  default_action {
    type = "fixed-response"

    fixed_response {
      content_type = "text/plain"
      message_body = "404: page not found"
      status_code  = 404
    }
  }
}

resource "aws_lb_listener_rule" "example_lb_listner" {
  listener_arn = aws_lb_listener.http.arn
  priority     = 100

  condition {
    path_pattern {
      values = ["*"]
    }
  }

  action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.example_tg.arn
  }
}

resource "aws_security_group" "alb" {

  name = "${var.my_cluster_name}-alb-sg"

  # Allow inbound HTTP requests
  ingress {
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  # Allow all outbound requests
  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}
