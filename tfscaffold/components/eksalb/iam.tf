


resource "aws_iam_policy" "aws_load_balancer_controller_policy" {
  name        = "${var.project}-${var.component}-${var.environment}-aws-load-balancer-controller-policy"
  path        = "/"
  policy      = data.http.aws_load_balancer_controller_policy.response_body
  description = "aws_load_balancer_controller_policy"
}

output "aws_load_balancer_controller_policy_arn" {
  value = aws_iam_policy.aws_load_balancer_controller_policy.arn
}

resource "aws_iam_role" "aws_load_balancer_controller_role" {
  name = "${var.project}-${var.component}-${var.environment}-aws-load-balancer-controller-role"

  # Terraform's "jsonencode" function converts a
  # Terraform expression result to valid JSON syntax.
  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Action = "sts:AssumeRoleWithWebIdentity"
        Effect = "Allow"
        Sid    = ""
        Principal = {
          Federated = "${data.terraform_remote_state.eks.outputs.openid_connect_provider_arn}"
        }

        Condition = {
          StringEquals = {
            "${data.terraform_remote_state.eks.outputs.openid_connect_provider_arn_extract}:sub" : "system:serviceaccount:kube-system:aws-load-balancer-controller",
            "${data.terraform_remote_state.eks.outputs.openid_connect_provider_arn_extract}:aud" : "sts.amazonaws.com"
          }
        }
      },
    ]
  })

  tags = merge(local.tags,
    {
      Name = "aws_load_balancer_controller"
    }
  )
}

resource "aws_iam_policy_attachment" "aws_load_balancer_controller_policy_attachment" {
  name       = "${var.project}-${var.component}-${var.environment}-aws-load-balancer-controller-role-attachment"
  policy_arn = aws_iam_policy.aws_load_balancer_controller_policy.arn
  roles      = [aws_iam_role.aws_load_balancer_controller_role.name]
}
