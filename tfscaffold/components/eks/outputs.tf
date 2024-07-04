output "eks_cluster_id" {
  description = "The ID of the EKS cluster."
  value       = aws_eks_cluster.eks_cluster.id
}

output "eks_cluster_endpoint" {
  description = "Endpoint for your Kubernetes API server"
  value       = aws_eks_cluster.eks_cluster.endpoint
}

output "kubeconfig_certificate_authority_data" {
  description = "Certificate data"
  value       = aws_eks_cluster.eks_cluster.certificate_authority[0].data
}

output "eks_cluster_arn" {
  description = "ARN of the cluster"
  value       = aws_eks_cluster.eks_cluster.arn
}

output "eks_cluster_version" {
  description = "EKS version for the cluster."
  value       = aws_eks_cluster.eks_cluster.version
}
