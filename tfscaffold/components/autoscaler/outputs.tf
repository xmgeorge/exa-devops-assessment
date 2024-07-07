output "cluster_autoscaler_iam_role_arn" {
  description = "Cluster Autoscaler IAM Role ARN"
  value       = aws_iam_role.cluster_autoscaler_iam_role.arn
}

output "cluster_autoscaler_helm_metadata" {
  description = "Metadata Block outlining status of the deployed release."
  value       = helm_release.cluster_autoscaler_release.metadata
}


output "metrics_server_helm_metadata" {
  description = "Metadata Block outlining status of the deployed release."
  value = helm_release.metrics_server_release.metadata
}