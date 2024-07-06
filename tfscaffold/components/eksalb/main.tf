resource "helm_release" "aws_load_balancer_controller" {
  depends_on      = [aws_iam_policy_attachment.aws_load_balancer_controller_policy_attachment, aws_iam_role.aws_load_balancer_controller_role]
  name            = "aws-load-balancer-controller"
  repository      = "https://aws.github.io/eks-charts"
  chart           = "aws-load-balancer-controller"
  namespace       = "kube-system"
  cleanup_on_fail = true

  set {
    name  = "serviceAccount.create"
    value = "true"
  }

  set {
    name  = "serviceAccount.name"
    value = "aws-load-balancer-controller"
  }

  set {
    name  = "serviceAccount.annotations.eks\\.amazonaws\\.com/role-arn"
    value = aws_iam_role.aws_load_balancer_controller_role.arn
  }

  set {
    name  = "vpcId"
    value = data.terraform_remote_state.vpc.outputs.vpc_id
  }

  set {
    name  = "region"
    value = var.region
  }

  set {
    name  = "clusterName"
    value = data.aws_eks_cluster.eks.id
  }
}



resource "kubernetes_ingress_class_v1" "aws_alb_ingress_class" {
  depends_on = [helm_release.aws_load_balancer_controller]
  metadata {
    name = "my-aws-ingress-class"
    annotations = {
      "ingressclass.kubernetes.io/is-default-class" = "true"
    }
  }

  spec {
    controller = "ingress.k8s.aws/alb"
  }
}