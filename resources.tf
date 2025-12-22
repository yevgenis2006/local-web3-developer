
resource "kubernetes_deployment" "postgres" {
  metadata {
    name      = "postgres"
    namespace = kubernetes_namespace.graph.metadata[0].name
  }

  spec {
    replicas = 1

    selector {
      match_labels = {
        app = "postgres"
      }
    }

    template {
      metadata {
        labels = {
          app = "postgres"
        }
      }

      spec {
        container {
          name  = "postgres"
          image = "postgres:15"

          env {
            name  = "POSTGRES_DB"
            value = "graph"
          }

          env {
            name  = "POSTGRES_USER"
            value = "graph"
          }

          env {
            name  = "POSTGRES_PASSWORD"
            value = "graph"
          }

          env {
            name  = "POSTGRES_INITDB_ARGS"
            value = "--encoding=UTF8 --locale=C"
          }

          port {
            container_port = 5432
          }

          volume_mount {
            name       = "pgdata"
            mount_path = "/var/lib/postgresql/data"
          }
        }

        volume {
          name = "pgdata"
          empty_dir {}
        }
      }
    }
  }
}

resource "kubernetes_service" "postgres" {
  metadata {
    name      = "postgres"
    namespace = kubernetes_namespace.graph.metadata[0].name
  }

  spec {
    selector = {
      app = "postgres"
    }

    port {
      port        = 5432
      target_port = 5432
      name        = "postgres"
    }
  }
}

# -----------------------------
# 3️⃣ IPFS
# -----------------------------
resource "kubernetes_deployment" "ipfs" {
  metadata {
    name      = "ipfs"
    namespace = kubernetes_namespace.graph.metadata[0].name
  }

  spec {
    replicas = 1

    selector {
      match_labels = {
        app = "ipfs"
      }
    }

    template {
      metadata {
        labels = {
          app = "ipfs"
        }
      }

      spec {
        container {
          name  = "ipfs"
          image = "ipfs/kubo:v0.30.0"

          port {
            container_port = 5001
          }

          port {
            container_port = 8080
          }
        }
      }
    }
  }
}

resource "kubernetes_service" "ipfs" {
  metadata {
    name      = "ipfs"
    namespace = kubernetes_namespace.graph.metadata[0].name
  }

  spec {
    selector = {
      app = "ipfs"
    }

    port {
      port        = 5001
      target_port = 5001
      name        = "api"
    }

    port {
      port        = 8080
      target_port = 8080
      name        = "gateway"
    }
  }
}

# -----------------------------
# 4️⃣ Geth (Ethereum node)
# -----------------------------
resource "kubernetes_stateful_set" "geth" {
  metadata {
    name      = "geth"
    namespace = kubernetes_namespace.ethereum.metadata[0].name
  }

  spec {
    service_name = "geth-headless"
    replicas     = 1

    selector {
      match_labels = {
        app = "geth"
      }
    }

    template {
      metadata {
        labels = {
          app = "geth"
        }
      }

      spec {
        container {
          name  = "geth"
          image = "ethereum/client-go:v1.14.7"

          args = [
            "--syncmode=snap",
            "--http",
            "--http.addr=0.0.0.0",
            "--http.api=eth,net,web3",
            "--ws",
            "--ws.addr=0.0.0.0",
            "--cache=4096"
          ]
          # ✅ Unset the problematic GETH_PORT env
          env {
            name  = "GETH_PORT"
            value = ""
          }
          port {
            container_port = 8545
          }

          port {
            container_port = 8546
          }

          volume_mount {
            name       = "data"
            mount_path = "/root/.ethereum"
          }
        }
        volume {
          name = "data"
          empty_dir {}
        }
      }
    }

    volume_claim_template {
      metadata {
        name = "data"
      }

      spec {
        access_modes = ["ReadWriteOnce"]
        resources {
          requests = {
            storage = "10Gi"
          }
        }
      }
    }
  }
}

resource "kubernetes_service" "geth_rpc" {
  metadata {
    name      = "geth-rpc"
    namespace = kubernetes_namespace.ethereum.metadata[0].name
  }

  spec {
    selector = {
      app = "geth"
    }

    port {
      port        = 8545
      target_port = 8545
      name        = "http"
    }

    port {
      port        = 8546
      target_port = 8546
      name        = "ws"
    }
  }
}

# -----------------------------
# 5️⃣ RPC NGINX
# -----------------------------
resource "kubernetes_config_map" "rpc_nginx" {
  metadata {
    name      = "rpc-nginx"
    namespace = kubernetes_namespace.rpc.metadata[0].name
  }

  data = {
    "default.conf" = <<-EOT
      server {
        listen 80;
        location / {
          proxy_pass http://geth-rpc.ethereum.svc.cluster.local:8545;
          proxy_set_header Host $host;
        }
      }
    EOT
  }
}

resource "kubernetes_deployment" "eth_rpc" {
  metadata {
    name      = "eth-rpc"
    namespace = kubernetes_namespace.rpc.metadata[0].name
  }

  spec {
    replicas = 2

    selector {
      match_labels = {
        app = "eth-rpc"
      }
    }

    template {
      metadata {
        labels = {
          app = "eth-rpc"
        }
      }

      spec {
        container {
          name  = "rpc"
          image = "nginx:alpine"

          volume_mount {
            name       = "config"
            mount_path = "/etc/nginx/conf.d"
          }
        }

        volume {
          name = "config"
          config_map {
            name = kubernetes_config_map.rpc_nginx.metadata[0].name
          }
        }
      }
    }
  }
}

resource "kubernetes_service" "eth_rpc" {
  metadata {
    name      = "eth-rpc"
    namespace = kubernetes_namespace.rpc.metadata[0].name
  }

  spec {
    selector = {
      app = "eth-rpc"
    }

    port {
      port        = 80
      target_port = 80
    }
  }
}

# -----------------------------
# 6️⃣ Graph Node
# -----------------------------
resource "kubernetes_deployment" "graph_node" {
  metadata {
    name      = "graph-node"
    namespace = kubernetes_namespace.graph.metadata[0].name
  }

  spec {
    replicas = 1

    selector {
      match_labels = {
        app = "graph-node"
      }
    }

    template {
      metadata {
        labels = {
          app = "graph-node"
        }
      }

      spec {
        container {
          name  = "graph-node"
          image = "graphprotocol/graph-node:v0.35.1"

          env {
            name  = "postgres_host"
            value = "postgres"
          }

          env {
            name  = "postgres_user"
            value = "graph"
          }

          env {
            name  = "postgres_pass"
            value = "graph"
          }

          env {
            name  = "postgres_db"
            value = "graph"
          }

          env {
            name  = "ethereum"
            value = "mainnet:http://geth-rpc.ethereum.svc.cluster.local:8545"
          }

          env {
            name  = "ipfs"
            value = "http://ipfs.graph.svc.cluster.local:5001"
          }

          env {
            name  = "GRAPH_LOG"
            value = "info"
          }

          port {
            container_port = 8000
          }

          port {
            container_port = 8030
          }

          port {
            container_port = 8040
          }
        }
      }
    }
  }
}

resource "kubernetes_service" "graph_node" {
  metadata {
    name      = "graph-node"
    namespace = kubernetes_namespace.graph.metadata[0].name
  }

  spec {
    selector = {
      app = "graph-node"
    }

    port {
      port        = 8000
      target_port = 8000
      name        = "graphql"
    }

    port {
      port        = 8030
      target_port = 8030
      name        = "admin"
    }

    port {
      port        = 8040
      target_port = 8040
      name        = "ws"
    }
  }
}
