<p align="center">
 <img width="100px" src=".images/azure-kubernetes-services.svg" align="center" alt="Azure Kubernetes Service" />
 <h2 align="center">Azure Kubernetes Service(AKS)</h2>
 <p align="center">This repository contains scripts that are used to interact with Azure Kubernetes Service (AKS).</p>
</p>

## Prerequisites

- [A valid Azure account][azure-account]
- [Azure CLI][azure-cli]
- [kubectl][kubectl]

## Usage
Each script in this folder is designed to perform a specific task with AKS. Before running a script, make sure to replace any placeholders with your own information.

## Script Descriptions

- **[create-node-pool.ps1]**: Creates a new node pool on your AKS-cluster.
- **[kubectl-commands.ps1]**: Manage Kubernetes clusters and resources with kubectl.
- TODO: ADD ESTABLISHED FEDERATED ID SCRIPT!

## Disclaimer
Please note that this is provided as-is and may not suit all use cases. Use at your own discretion and make sure to thoroughly test before deployment in a production environment.

[azure-account]: https://azure.microsoft.com/en-us/free
[azure-cli]: https://docs.microsoft.com/en-us/cli/azure
[create-node-pool.ps1]:create-node-pool.ps1
[kubectl]:https://kubernetes.io/docs/tasks/tools/
[kubectl-commands.ps1]:kubectl-commands.ps1
