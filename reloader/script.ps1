#https://github.com/stakater/Reloader/tree/master
#This scenario is possible provided that you have a Key Vault and a cluster setup that can access your Azure Key Vault using workload identity.
#If not check -> https://github.com/aranaescobedo/workload-id-csi-aks or https://github.com/aranaescobedo/workload-id-app-aks

#Create namespace.
kubectl create namespace <NAMESPACE_NAME>

#Add label to namecespace.
kubectl label namespaces <NAMESPACE_NAME> reloader=true

#Install Reloader with HELM.
helm repo add stakater https://stakater.github.io/stakater-charts
helm repo update

helm install <HELM_NAME> stakater/reloader `
			 --namespace kube-system `
			 --set reloader.watchGlobally=true `
			 --set namespaceSelector="reloader=true" `
			 --set reloader.deployment.nodeSelector.agentpool=<NODE_POOL_NAME>

#If you need to delete the HELM chart.
helm uninstall <HELM_NAME> --namespace kube-system

#Apply the Reloader label into the deployment resource
kubectl apply -f pod.yaml -n <NAMESPACE_NAME>
