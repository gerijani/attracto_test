# modules/nginx/main.tf
resource "kubernetes_namespace" "ingress_nginx" {
  metadata {
    name = "ingress-nginx"
  }
}

resource "helm_release" "nginx_ingress" {
  name       = "nginx-ingress"
  namespace  = kubernetes_namespace.ingress_nginx.metadata[0].name
  repository = "https://kubernetes.github.io/ingress-nginx"
  chart      = "ingress-nginx"
  version    = "4.7.1"

  set {
    name  = "controller.service.type"
    value = "LoadBalancer"
  }

  set {
    name  = "controller.replicaCount"
    value = "2"
  }

  values = [
    <<-EOF
    controller:
      config:
        use-forwarded-headers: "true"
        proxy-body-size: "50m"
      metrics:
        enabled: true
    EOF
  ]
}

resource "kubernetes_ingress_v1" "main_ingress" {
  metadata {
    name      = "${var.project_name}-ingress"
    namespace = kubernetes_namespace.ingress_nginx.metadata[0].name
    
    annotations = {
      "kubernetes.io/ingress.class"               = "nginx"
      "nginx.ingress.kubernetes.io/rewrite-target" = "/"
      "nginx.ingress.kubernetes.io/ssl-redirect"   = "false"
    }
  }

  spec {
    rule {
      http {
        path {
          path = "/api"
          backend {
            service {
              name = "dotnet-backend-service"
              port {
                number = 80
              }
            }
          }
        }

        path {
          path = "/"
          backend {
            service {
              name = "react-frontend-service"
              port {
                number = 80
              }
            }
          }
        }
      }
    }
  }

  depends_on = [helm_release.nginx_ingress]
}