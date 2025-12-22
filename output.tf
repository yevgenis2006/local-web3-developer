
output "postgres_service" {
  value = kubernetes_service.postgres.metadata[0].name
}

output "postgres_host" {
  value = kubernetes_service.postgres.spec[0].cluster_ip
}

output "postgres_port" {
  value = kubernetes_service.postgres.spec[0].port[0].port
}

# -----------------------------
# IPFS
# -----------------------------
output "ipfs_service" {
  value = kubernetes_service.ipfs.metadata[0].name
}

output "ipfs_api_url" {
  value = "http://${kubernetes_service.ipfs.spec[0].cluster_ip}:5001"
}

output "ipfs_gateway_url" {
  value = "http://${kubernetes_service.ipfs.spec[0].cluster_ip}:8080"
}

# -----------------------------
# Geth / Ethereum RPC
# -----------------------------
output "geth_rpc_service" {
  value = kubernetes_service.geth_rpc.metadata[0].name
}

output "geth_rpc_http" {
  value = "http://${kubernetes_service.geth_rpc.spec[0].cluster_ip}:8545"
}

output "geth_rpc_ws" {
  value = "ws://${kubernetes_service.geth_rpc.spec[0].cluster_ip}:8546"
}

# -----------------------------
# Graph Node
# -----------------------------
output "graph_node_service" {
  value = kubernetes_service.graph_node.metadata[0].name
}

output "graph_node_graphql_url" {
  value = "http://${kubernetes_service.graph_node.spec[0].cluster_ip}:8000/graphql"
}

output "graph_node_admin_url" {
  value = "http://${kubernetes_service.graph_node.spec[0].cluster_ip}:8030"
}

output "graph_node_ws_url" {
  value = "ws://${kubernetes_service.graph_node.spec[0].cluster_ip}:8040"
}

# -----------------------------
# RPC NGINX
# -----------------------------
output "eth_rpc_service" {
  value = kubernetes_service.eth_rpc.metadata[0].name
}

output "eth_rpc_url" {
  value = "http://${kubernetes_service.eth_rpc.spec[0].cluster_ip}"
}
