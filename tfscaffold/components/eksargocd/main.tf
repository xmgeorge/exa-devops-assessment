resource "kubernetes_namespace_v1" "argocd" {
  metadata {
    name = "argocd"
  }
}

resource "helm_release" "argo_cd" {
  name             = "argo-cd"
  repository       = "https://argoproj.github.io/argo-helm"
  chart            = "argo-cd"
  version                    = "7.3.4"
  namespace        = kubernetes_namespace_v1.argocd.id
  create_namespace = false

  set {
   name  = "server.service.type"
   value = "ClusterIP"
 }

   set {
   name  = "server.service.port"
   value = "80"
 }

}
