
resource "aws_iam_openid_connect_provider" "name" {
  client_id_list  = ["sts.${data.aws_partition.current.dns_suffix}"]
  thumbprint_list = [data.tls_certificate.eks.certificates[0].sha1_fingerprint]
  url             = aws_eks_cluster.eks_cluster.identity[0].oidc[0].issuer

  tags = merge(
    {
      Name = "OpenID_EKS"
    },
    local.tags
  )
}

locals {
  openid_connect_provider_arn_extract = element(split("oidc-provider/", "${aws_iam_openid_connect_provider.name.arn}"), 1)
}