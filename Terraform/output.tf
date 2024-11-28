output "cluster_id" {
  value = aws_eks_cluster.microservicesapp.id
}

output "node_group_id" {
  value = aws_eks_node_group.microservicesapp.id
}

output "vpc_id" {
  value = aws_vpc.microservicesapp_vpc.id
}

output "subnet_ids" {
  value = aws_subnet.microservicesapp_subnet[*].id
}
# Output the Cluster Endpoint and Token
output "cluster_endpoint" {
  value = data.aws_eks_cluster.microservicesapp.endpoint
}

output "cluster_token" {
  value = data.aws_eks_cluster_auth.microservicesapp.token
  sensitive = true
}