

data "aws_eks_cluster" "eks" {
  name = data.terraform_remote_state.eks.outputs.eks_cluster_id
}

data "aws_eks_cluster_auth" "eks" {
  name = data.terraform_remote_state.eks.outputs.eks_cluster_id
}