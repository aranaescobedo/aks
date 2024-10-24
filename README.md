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

- **[add-ons]**: Scripts for installing various add-ons to enhance the functionality of the AKS cluster.
  
- **[container-storage-interface]**: Contains a collection of solutions for common troubleshooting scenarios that may arise when using CSI on AKS.
  
- **[planned-maintenance]**: This folder will provide you with tools for setting up automatic upgrades on your Azure Kubernetes Service (AKS) cluster.

- **[reloader]**: This folder contains scripts that are used to interact with Stakater Reloader.
  
- **[toolbox]**: Create a toolbox container to more easily troubleshoot issues within your AKS cluster, including Azure DevOps pipelines.
  
- **[workload-identity]**: Contains a collection of solutions for common troubleshooting scenarios that may arise when using workload identity on AKS.
  
- **[create-node-pool.ps1]**:  Creates a new node pool on your AKS-cluster.
  
- **[delete-namespace.ps1]**: This script resolves a stuck Kubernetes namespace with a "Terminating" status.

- **[establish-federated-id.ps1]**: This script is used to establish federated identity credential for a new application on the AKS cluster.

- **[images-vulnerability-findings-mdvm-all.kql]**: Identifies vulnerabilities in container images for specific CVE vulnerabilities, powered by Microsoft Defender Vulnerability Management

- **[images-vulnerability-findings-mdvm.kql]**: Identifies vulnerabilities in container images running on your Kubernetes clusters for specific CVE vulnerabilities, powered by powered by Microsoft Defender Vulnerability Management.

- **[images-vulnerability-findings-qualys-all.kql]**: Identifies vulnerabilities in container images for specific CVE vulnerabilities, powered by Qualys.

- **[images-vulnerability-findings-qualys.kql]**: Identifies vulnerabilities in container images running on your Kubernetes clusters for specific CVE vulnerabilities, powered by Qualys.
  
- **[kubectl-commands.ps1]**: Manage Kubernetes clusters and resources with kubectl.

## Disclaimer
Please note that this is provided as-is and may not suit all use cases. Use at your own discretion and make sure to thoroughly test before deployment in a production environment.

[add-ons]:add-ons
[azure-account]: https://azure.microsoft.com/en-us/free
[azure-cli]: https://docs.microsoft.com/en-us/cli/azure
[container-storage-interface]: container-storage-interface/troubleshooting.md
[planned-maintenance]:planned-maintenance
[create-node-pool.ps1]:create-node-pool.ps1
[delete-namespace.ps1]:delete-namespace.ps1
[establish-federated-id.ps1]:establish-federated-id.ps1
[images-vulnerability-findings-mdvm-all.kql]:images-vulnerability-findings-mdvm-all.kql
[images-vulnerability-findings-mdvm.kql]:images-vulnerability-findings-mdvm.kql
[images-vulnerability-findings-qualys-all.kql]:images-vulnerability-findings-qualys-all.kql
[images-vulnerability-findings-qualys.kql]:images-vulnerability-findings-qualys.kql
[kubectl]:https://kubernetes.io/docs/tasks/tools/
[kubectl-commands.ps1]:kubectl-commands.ps1
[toolbox]:toolbox
[reloader]:reloader
[workload-identity]: workload-identity/troubleshooting.md

