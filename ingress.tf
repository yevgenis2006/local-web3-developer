# -----------------------------
# Web3 Ingress with TLS
# -----------------------------
resource "kubernetes_ingress" "web3_ingress" {
  metadata {
    name      = "web3-ingress"
    namespace = "graph"
    annotations = {
      "kubernetes.io/ingress.class"    = "nginx"

    }
  }

  spec {
    tls {
      hosts       = ["graph.appflex.io", "rpc.appflex.io"]
      secret_name = "web3-tls"
    }

    rule {
      host = "graph.appflex.io"
      http {
        path {
          path = "/"
          backend {
            service {
              name = "graph-node" # must match your Graph Node Service name
              port { number = 8000 }
            }
          }
        }
      }
    }

    rule {
      host = "rpc.appflex.io"
      http {
        path {
          path = "/"
          backend {
            service {
              name = "eth-rpc" # must match your RPC NGINX Service name
              port { number = 80 }
            }
          }
        }
      }
    }
  }
}
