
resource "helm_release" "cluster_autoscaler_release" {
  depends_on = [aws_iam_role.cluster_autoscaler_iam_role]
  name       = "${local.eks_cluster_name}-ca"

  repository = "https://kubernetes.github.io/autoscaler"
  chart      = "cluster-autoscaler"

  namespace = "kube-system"

  set {
    name  = "cloudProvider"
    value = "aws"
  }

  set {
    name  = "autoDiscovery.clusterName"
    value = data.terraform_remote_state.eks.outputs.eks_cluster_id
  }

  set {
    name  = "awsRegion"
    value = var.region
  }

  set {
    name  = "rbac.serviceAccount.create"
    value = "true"
  }

  set {
    name  = "rbac.serviceAccount.name"
    value = "cluster-autoscaler"
  }

  set {
    name  = "rbac.serviceAccount.annotations.eks\\.amazonaws\\.com/role-arn"
    value = aws_iam_role.cluster_autoscaler_iam_role.arn
  }


}




resource "helm_release" "metrics_server_release" {
  name       = "${local.eks_cluster_name}-metrics-server"
  repository = "https://kubernetes-sigs.github.io/metrics-server/"
  chart      = "metrics-server"
  namespace  = "kube-system"
}