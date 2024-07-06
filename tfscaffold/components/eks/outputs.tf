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

output "eks_cluster_security_group_ids" {
  description = "List of security group IDs"
  value       = aws_eks_cluster.eks_cluster.vpc_config[0].security_group_ids
}

output "eks_cluster_master_iam_role_arn" {
  description = "eks_cluster_master_iam_role_arn"
  value       = aws_iam_role.eks_master_iam_role.arn
}

output "eks_cluster_master_iam_role_name" {
  description = "eks_cluster_master_iam_role_name"
  value       = aws_iam_role.eks_master_iam_role.name
}

output "eks_cluster_oidc_issue_url" {
  value = aws_eks_cluster.eks_cluster.identity[0].oidc[0].issuer
}

output "public_node_group_id" {
  value = aws_eks_node_group.eks_nodegroup_public.id
}

output "public_node_group_status" {
  value = aws_eks_node_group.eks_nodegroup_public.status
}

output "public_node_group_arn" {
  value = aws_eks_node_group.eks_nodegroup_public.arn
}

output "public_node_group_version" {
  value = aws_eks_node_group.eks_nodegroup_public.version
}

output "public_node_group_iam_role_arn" {

  value = aws_iam_role.eks_nodegroup_iam_role.arn
}

output "openid_connect_provider_arn" {
  description = "The OpenID Connect identity provider ARN"
  value       = aws_iam_openid_connect_provider.name.arn
}

output "openid_connect_provider_arn_extract" {
  description = "The OpenID Connect identity provider ARN extract"
  value       = local.openid_connect_provider_arn_extract
}


output "eks_connect" {
  description = "Command to update kubeconfig to connect to the EKS cluster"
  value       = "aws eks --region ${var.region} update-kubeconfig --name ${aws_eks_cluster.eks_cluster.id}"
}