output "cluster_name" {
  value = aws_eks_cluster.eks.cluster_name
}

output "cluster_endpoint" {
  value = aws_eks_cluster.eks.cluster_endpoint
}

