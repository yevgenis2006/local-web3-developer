<img width="1536" height="1024" alt="image" src="https://github.com/user-attachments/assets/6b9c1a3e-1199-4379-b9e1-4c4ca479dbf2" />



## Web3 | Development 
Web3 stack you are building (Ethereum + Graph Node + IPFS + RPC + Postgres) and how the components interact, both conceptually and in a Kubernetes environment like K3s. I’ll also explain why each component is needed and their roles


🧱  Key Features and Purpose
```
✅ Ethereum Node: Provides blockchain data via RPC/WS
✅ RPC Proxy: Stable load-balanced RPC endpoint for dApps/subgraphs
✅ Postgres: Stores indexed blockchain data for Graph Node
✅ IPFS: Decentralized storage for subgraph manifests and data
✅ Graph Node: Indexes Ethereum data and exposes GraphQL API
✅ Ingress + TLS: Exposes Graph Node / RPC endpoints securely
```

It’s especially helpful for:
```
✔ Developers who need a fast, disposable Kubernetes cluster on their laptop .
✔ Kubernetes integration tests quickly without cloud infrastructure.
✔ Testing multi-node setups or Kubernetes features (networking, scheduling, etc.) locally.
```

🚀 Deployment Options
```
terraform init
terraform validate
terraform plan -var-file="template.tfvars"
terraform apply -var-file="template.tfvars" -auto-approve
```

