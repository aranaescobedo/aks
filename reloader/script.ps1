#https://github.com/stakater/Reloader/tree/master
#This scenario is possible provided that you have a Key Vault and a cluster setup that can access your Azure Key Vault using workload identity.
#If not check -> https://github.com/aranaescobedo/workload-id-csi-aks or https://github.com/aranaescobedo/workload-id-app-aks

$kvName = "<ADD_KEY_VAULT_NAME>"
$secretName = "<ADD_SECRET_NAME>"
$namespaceName = "demo"

#Install Reloader with HELM.
helm repo add stakater https://stakater.github.io/stakater-charts
helm repo update

helm install <HELM_NAME> stakater/reloader `
			 --namespace kube-system `
			 --set reloader.watchGlobally=true `
			 --set namespaceSelector="reloader=true" `
			 --set reloader.deployment.nodeSelector.agentpool=<NODE_POOL_NAME>

#If you need to delete the HELM chart.
#helm uninstall <HELM_NAME> --namespace kube-system

#Create namespace.
kubectl create namespace $namespaceName

#Add label to namecespace.
kubectl label namespaces $namespaceName reloader=true

#Apply the Reloader label into the pod resource
echo @"
apiVersion: v1
kind: Pod
metadata:
  name: demo-app
  namespace: $namespace
  labels:
    name: demo-pod
  annotations:
    reloader.stakater.com/auto: "true"
spec:
  containers:
    - image: docker.io/aranaescobedo/workload-id-app-aks:1.0
      name: demo-container
      env:
        - name: KEYVAULT_NAME
          value: $kvName
        - name: SECRET_NAME
          value: $mySecretName
"@ > pod.yaml | kubectl apply -f pod.yaml
