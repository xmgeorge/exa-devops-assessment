data "terraform_remote_state" "vpc" {
  backend = "s3"

  config = {
    bucket = "${var.project}-tfscaffold-${var.state_account}-${var.region}"
    key    = "${var.project}/${var.state_account}/${var.region}/${var.environment}/vpc/vpc.tfstate"
    region = var.region
  }
}

data "terraform_remote_state" "eks" {
  backend = "s3"

  config = {
    bucket = "${var.project}-tfscaffold-${var.state_account}-${var.region}"
    key    = "${var.project}/${var.state_account}/${var.region}/${var.environment}/eks/eks.tfstate"
    region = var.region
  }
}


data "aws_eks_cluster" "eks" {
  name = data.terraform_remote_state.eks.outputs.eks_cluster_id
}

data "aws_eks_cluster_auth" "eks" {
  name = data.terraform_remote_state.eks.outputs.eks_cluster_id
}



data "http" "aws_load_balancer_controller_policy" {
  url = "https://raw.githubusercontent.com/kubernetes-sigs/aws-load-balancer-controller/v2.7.2/docs/install/iam_policy.json"

  # Optional request headers
  request_headers = {
    Accept = "application/json"
  }
}

output "aws_load_balancer_controller_policy" {
  value = data.http.aws_load_balancer_controller_policy.response_body
}