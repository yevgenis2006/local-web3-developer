

###  ---  Default Template  ---  ###
# Hosts / Domains
graph_host           = "graph.appflex.io"
rpc_host             = "rpc.appflex.io"

# Service names (must match the Kubernetes Services)
graph_service_name   = "graph-node"
rpc_service_name     = "eth-rpc"

graph_namespace      = "graph"
rpc_namespace        = "rpc"
graph_service_port   = 8000
rpc_service_port     = 80
tls_secret_name      = "web3-tls"
