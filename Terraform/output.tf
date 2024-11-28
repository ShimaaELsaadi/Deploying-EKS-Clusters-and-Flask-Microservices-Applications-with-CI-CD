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