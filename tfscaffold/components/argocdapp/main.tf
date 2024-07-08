
resource "kubernetes_manifest" "sample_app" {
  manifest = {
    apiVersion = "argoproj.io/v1alpha1"
    kind       = "Application"

    metadata = {
      name      = "sample-app"
      namespace = "${data.terraform_remote_state.eksargocd.outputs.argocd_namespace}"
    }

    spec = {
      project = "default"
      source = {
        repoURL        = "https://github.com/xmgeorge/sample-app.git"
        targetRevision = "main"
        path           = "k8s-manifests"
      }
      destination = {
        server    = "https://kubernetes.default.svc"
        namespace = "default"
      }
      syncPolicy = {
        automated = {
          prune      = true
          selfHeal   = true
          allowEmpty = false
        }
      }
    }
  }
}
