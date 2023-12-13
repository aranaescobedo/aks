<#
    .DESCRIPTION
	Use this script to add the Reloader tool to an existing cluster.
	This scenario is possible provided that you have a Key Vault and a cluster setup that can access your Azure Key Vault using workload identity.
 	If you don't have the setup, you can check the following resources:
  	  https://github.com/aranaescobedo/workload-id-app-aks
	  https://github.com/aranaescobedo/workload-id-csi-aks
    .NOTES
        AUTHOR: Alexander Arana E
        LASTEDIT: Dec 05, 2023
#>


$helmName = "<ADD_HELM_NAME>"
$idClientId = "<ADD_CLIENT_ID_FROM_USER_ASSIGNED_IDENTITY>"
$kvName = "<ADD_KEY_VAULT_NAME>"
$secretName = "<ADD_SECRET_NAME>"
$serviceAccountName = "<SERVICE_ACCOUNT_NAME>"
$namespaceName = "demo"
$nodePoolName = "<ADD_POOL_NAME>"
$tenantId = "<ADD_TENANT_ID>"

#Install Reloader with HELM.
helm repo add stakater https://stakater.github.io/stakater-charts
helm repo update

helm install $helmName stakater/reloader `
		 --namespace kube-system `
		 --set reloader.watchGlobally=true `
		 --set reloader.namespaceSelector="reloader=true" `
		 --set reloader.deployment.nodeSelector.agentpool=$nodePoolName

#If you need to delete the HELM chart.
#helm uninstall $helmName --namespace kube-system

#Create namespace.
kubectl create namespace $namespaceName

#Add label to namecespace.
kubectl label namespaces $namespaceName reloader=true

#Apply the Reloader label into the pod resource
echo @"
apiVersion: apps/v1
kind: Deployment
metadata:
  name: reloader-deploy
  annotations:
    reloader.stakater.com/auto: "true"
  namespace: $namespaceName
  labels:
    app: reloader-app
spec:
  replicas: 1
  selector:
    matchLabels:
      name: reloader-deploy
  strategy:
    type: RollingUpdate
    rollingUpdate:
      maxSurge: 1
      maxUnavailable: 0
  template:
    metadata:
      labels:
        name: reloader-deploy
        app: reloader-app
        azure.workload.identity/use: "true"
    spec:
      serviceAccountName: $serviceAccountName
      nodeSelector:
        agentpool: $nodePoolName
      securityContext:
        runAsUser: 999
        runAsGroup: 999
        runAsNonRoot: true
      containers:
      - name: reloader-container
        image: docker.io/aranaescobedo/workload-id-app-aks:1.0
        imagePullPolicy: IfNotPresent
        envFrom:
          - secretRef:
              name: secret-creds
        volumeMounts:
          - name: secrets-store-inline
            mountPath: "/mnt/secrets-store"
            readOnly: true
      volumes:
        - name: secrets-store-inline
          csi:
            driver: secrets-store.csi.k8s.io
            readOnly: true
            volumeAttributes:
              secretProviderClass: secret-spc
---
apiVersion: secrets-store.csi.x-k8s.io/v1
kind: SecretProviderClass
metadata:
  name: secret-spc
  namespace: $namespaceName
spec:
  provider: azure
  secretObjects:
  - secretName: secret-creds
    data:
    - key: SECRET_NAME
      objectName: $secretName 
    type: Opaque
  parameters:
    usePodIdentity: "false"
    useVMManagedIdentity: "false"
    clientID: $idClientId 
    keyvaultName: $kvName
    cloudName: ""
    objects:  |
      array:
        - |
          objectName: $secretName
          objectType: secret
          objectVersion: ""
    tenantId: $tenantId
"@ > deploy.yaml | kubectl apply -f deploy.yaml
