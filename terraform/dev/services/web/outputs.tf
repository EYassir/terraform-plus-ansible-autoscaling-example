output "alb_dns_name" {
  value       = module.my_module.alb_dns_name
  description = "The domain name of the load balancer"
}
