output "alb_dns_name" {
  description = "DNS name do Application Load Balancer"
  value       = aws_lb.main.dns_name
}

output "ecs_cluster_name" {
  description = "Nome do ECS Cluster"
  value       = aws_ecs_cluster.main.name
}

output "ecs_service_name" {
  description = "Nome do ECS Service"
  value       = aws_ecs_service.main.name
}

output "app_url" {
  description = "URL da aplicação"
  value       = "http://${aws_lb.main.dns_name}"
}

output "admin_url" {
  description = "URL do admin Strapi"
  value       = "http://${aws_lb.main.dns_name}/admin"
}

