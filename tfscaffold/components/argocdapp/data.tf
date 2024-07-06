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

data "terraform_remote_state" "eksargocd" {
  backend = "s3"

  config = {
    bucket = "${var.project}-tfscaffold-${var.state_account}-${var.region}"
    key    = "${var.project}/${var.state_account}/${var.region}/${var.environment}/eksargocd/eksargocd.tfstate"
    region = var.region
  }
}


data "aws_eks_cluster" "eks" {
  name = data.terraform_remote_state.eks.outputs.eks_cluster_id
}

data "aws_eks_cluster_auth" "eks" {
  name = data.terraform_remote_state.eks.outputs.eks_cluster_id
}
