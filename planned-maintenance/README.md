<p align="center">
 <h2 align="center">👩‍🔧 Planned maintenance 👨‍🔧</h2>
 <p align="center">This folder will provide you with tools for setting up automatic upgrades on your Azure Kubernetes Service (AKS) cluster.</p>
</p>


## Descriptions

- **[add-planned-mt.ps1]**: This script is used to schedule planned maintenance on your cluster, enabling both AKS and Node OS upgrades
  
- **[aks-upgrade-status.kql]**: A Kusto query you can use to monitor how the upgrades went. It could also be pinned to your Azure dashboard.
  
- **[dev-auto-upgrade-cluster-sched.json]**: A JSON schedule for AKS upgrades, will be used by the scripts.

- **[dev-auto-upgrade-node-os-sched.json]**: A JSON schedule for Node OS upgrades, will be used by the scripts.

- **[upgrade-planned-mt.ps1]**: This script is used to update scheduled planned maintenance on your cluster, enabling both AKS and Node OS upgrades.

## Source
https://learn.microsoft.com/en-us/azure/aks/auto-upgrade-cluster?tabs=azure-cli
https://learn.microsoft.com/en-us/azure/aks/planned-maintenance?tabs=azure-cli

[add-planned-mt.ps1]:add-planned-mt.ps1
[aks-upgrade-status.kql]:aks-upgrade-status.kql
[dev-auto-upgrade-cluster-sched.json]:dev-auto-upgrade-cluster-sched.json
[dev-auto-upgrade-node-os-sched.json]:dev-auto-upgrade-node-os-sched.json
[upgrade-planned-mt.ps1]:upgrade-planned-mt.ps1
