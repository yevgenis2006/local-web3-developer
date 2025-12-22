<img width="1874" height="1338" alt="greenfield-architecture-e4af81f907fccbcb8b1b6af2965ca1f9" src="https://github.com/user-attachments/assets/86ccbb78-b08e-4fc7-8f45-af2e0f2a21b0" />


## Camunda | Development 
MCP Server that can connect to a Kubernetes cluster and manage it. Supports loading kubeconfig from multiple sources in priority order.


🧱  Key Features and Purpose
```
✔ Connectivity and Interoperability:
Agentgateway connects different components of an AI system, including agents, tools (like OpenAPI endpoints), and LLM providers, in a scalable and secure way. It supports emerging AI protocols such as the Agent-to-Agent (A2A) and Model Context Protocol (MCP).
✔ Security and Governance: It offers robust security features, including JWT authentication, external authorization policies (e.g., via Open Policy Agent), and API key management for LLM providers. This helps prevent data leaks and tool poisoning attacks.
✔ Observability: The platform includes built-in metrics and tracing capabilities, providing visibility into agent and tool interactions.
✔ Deployment Flexibility: Agentgateway can be deployed as a standalone binary or in a Kubernetes environment using the kgateway project, which offers native support for the Kubernetes Gateway API.
✔ Dynamic Configuration: It supports dynamic configuration updates via an xDS interface without requiring system downtime.
```

It’s especially helpful for:
```
✅ Developers who need a fast, disposable Kubernetes cluster on their laptop .
✅ Kubernetes integration tests quickly without cloud infrastructure.
✅ Testing multi-node setups or Kubernetes features (networking, scheduling, etc.) locally.
```


🚀 Deployment Options
```
terraform init
terraform validate
terraform plan -var-file="template.tfvars"
terraform apply -var-file="template.tfvars" -auto-approve
```


🏗️ Verify that the agentgateway proxy is created
```
kubectl get gateway agentgateway -n kgateway-system
kubectl get deployment agentgateway -n kgateway-system
```
