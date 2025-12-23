
resource "kubernetes_ingress_v1" "web3_ingress" {
  metadata {
    name      = "web3-ingress"
    namespace = var.graph_namespace
    annotations = {
      "kubernetes.io/ingress.class"    = "nginx"
      #"cert-manager.io/cluster-issuer" = var.cluster_issuer
    }
  }

  spec {
    # Graph service
    rule {
      host = var.graph_host
      http {
        path {
          path      = "/graphql"
          path_type = "Prefix"
          backend {
            service {
              name = var.graph_service_name
              port {
                number = var.graph_service_port
              }
            }
          }
        }
      }
    }

    # RPC service
    rule {
      host = var.rpc_host
      http {
        path {
          path      = "/"
          path_type = "Prefix"
          backend {
            service {
              name = var.rpc_service_name
              port {
                number = var.rpc_service_port
              }
            }
          }
        }
      }
    }

    # Admin service
    rule {
      host = var.admin_host
      http {
        path {
          path      = "/admin"
          path_type = "Prefix"
          backend {
            service {
              name = var.admin_service_name
              port {
                number = 8030
              }
            }
          }
        }
      }
    }

    # TLS for all hosts
    tls {
      hosts       = [var.graph_host, var.rpc_host, var.admin_host]
      secret_name = var.tls_secret_name
    }
  }
}
