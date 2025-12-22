
resource "kubernetes_namespace" "graph" {
  metadata {
    name = "graph"
  }
}

resource "kubernetes_namespace" "ethereum" {
  metadata {
    name = "ethereum"
  }
}

resource "kubernetes_namespace" "rpc" {
  metadata {
    name = "rpc"
  }
}

