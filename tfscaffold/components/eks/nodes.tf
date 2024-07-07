
resource "aws_eks_node_group" "eks_nodegroup_public" {
  cluster_name    = aws_eks_cluster.eks_cluster.name
  node_group_name_prefix = "${local.eks_cluster_name}-nodegroup-public"
  node_role_arn   = aws_iam_role.eks_nodegroup_iam_role.arn
  subnet_ids      = data.terraform_remote_state.vpc.outputs.public_subnets
  version = var.cluster_version

  scaling_config {
    desired_size = 1
    max_size     = 3
    min_size     = 1
  }

  update_config {
    max_unavailable = 1
  }

  ami_type = "AL2_x86_64"
  capacity_type = "ON_DEMAND"
  disk_size = 20
  instance_types = ["t3.medium"]

  remote_access {
    ec2_ssh_key = var.ec2_ssh_key
  }

  # Ensure that IAM Role permissions are created before and deleted after EKS Node Group handling.
  # Otherwise, EKS will not be able to properly delete EC2 Instances and Elastic Network Interfaces.
  depends_on = [
    aws_iam_role_policy_attachment.eks_AmazonEKSWorkerNodePolicy,
    aws_iam_role_policy_attachment.eks_AmazonEKS_CNI_Policy,
    aws_iam_role_policy_attachment.eks_AmazonEC2ContainerRegistryReadOnly,
  ]

  tags = merge(
    local.tags,
     {
      Name = "NodeGroup_Public"
     "k8s.io/cluster-autoscaler/${local.eks_cluster_name}" = "owned"
     "k8s.io/cluster-autoscaler/enabled" = "TRUE"
     }
  )
}

data "aws_iam_policy_document" "assume_node_policy" {
  statement {
    effect = "Allow"

    principals {
      type        = "Service"
      identifiers = ["ec2.amazonaws.com"]
    }

    actions = ["sts:AssumeRole"]
  }
}

resource "aws_iam_role" "eks_nodegroup_iam_role" {
  name               = "${local.eks_cluster_name}-eks-nodegroup-iam-role"
  assume_role_policy = data.aws_iam_policy_document.assume_node_policy.json
}


resource "aws_iam_role_policy_attachment" "eks_AmazonEKSWorkerNodePolicy" {
  policy_arn = "arn:aws:iam::aws:policy/AmazonEKSWorkerNodePolicy"
  role       = aws_iam_role.eks_nodegroup_iam_role.name
}

resource "aws_iam_role_policy_attachment" "eks_AmazonEKS_CNI_Policy" {
  policy_arn = "arn:aws:iam::aws:policy/AmazonEKS_CNI_Policy"
  role       = aws_iam_role.eks_nodegroup_iam_role.name
}

resource "aws_iam_role_policy_attachment" "eks_AmazonEC2ContainerRegistryReadOnly" {
  policy_arn = "arn:aws:iam::aws:policy/AmazonEC2ContainerRegistryReadOnly"
  role       = aws_iam_role.eks_nodegroup_iam_role.name
}


resource "aws_iam_role_policy_attachment" "eks_Autoscaling_Full_Access" {
  policy_arn = "arn:aws:iam::aws:policy/AutoScalingFullAccess"
  role       = aws_iam_role.eks_nodegroup_iam_role.name
}