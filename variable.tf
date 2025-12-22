
variable "kubeconfig_path" {
  type        = string
  description = "Path to kubeconfig for the target cluster"
  default     = "~/.kube/config"
}

variable "graph_namespace" {
  type    = string
  default = "graph"
}

variable "rpc_namespace" {
  type    = string
  default = "rpc"
}

variable "graph_host" {
  type    = string
  default = "graph.appflex.io"
}

variable "rpc_host" {
  type    = string
  default = "rpc.appflex.io"
}

variable "graph_service_name" {
  type    = string
  default = "graph-node"
}

variable "rpc_service_name" {
  type    = string
  default = "eth-rpc"
}

variable "admin_host" {
  type        = string
  default     = "graph-admin.appflex.io"
}

variable "admin_service_name" {
  type        = string
  default     = "admin-service"
}

variable "admin_service_port" {
  description = "Port for the Admin service"
  type        = number
  default     = 8030
}

variable "graph_service_port" {
  type    = number
  default = 8000
}

variable "rpc_service_port" {
  type    = number
  default = 80
}

variable "tls_secret_name" {
  type    = string
  default = "web3-tls"
}
