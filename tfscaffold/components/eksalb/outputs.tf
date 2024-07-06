


output "alb_helm_metadata" {
  value = helm_release.aws_load_balancer_controller.metadata
}

output "alb_iam_role_arn" {
  value = aws_iam_role.aws_load_balancer_controller_role.arn
}

output "alb_iam_policy_arn" {
  value = aws_iam_policy.aws_load_balancer_controller_policy.arn
}