az login

#Attention, if you have a lot of different subscriptions connected to your account use.
az account set --subscription <SUBSCRIPTION_NAME>

#Authenticate your k8s cluster.
az aks get-credentials -g <RESOURCE_GROUP_NAME> -n <CLUSTER_NAME>

#List all contexts defiend in your kubeconfig file.
kubectl config get-contexts

#Change context.
kubectl config use-context <CONTEXT_NAME>

#Show the details for a managed Kubernetes cluster.
az aks show -g <RESOURCE_GROUP_NAME> -n <CLUSTER_NAME>

#Get nodes.
kubectl get nodes

#Displays real-time CPU and memory usage statistics for the nodes in a Kubernetes cluster.
kubectl top nodes

#Filter on node name.
kubectl top nodes | Where-Object { $_ -like "*<NODE_NAME>*" }

#Provides detailed information about a node in the Kubernetes cluster, including its labels, capacity, usage, conditions, and other relevant details.
kubectl describe node <NODE_NAME>

#Create new namespace.
kubectl create namespace <NAMESPACE_NAME>

#Create label on namespace.
kubectl label namespace <NAMESPACE_NAME> name=<Value>

#Set a default namespace.
kubectl config set-context --current --namespace=<NAMESPACE_NAME>

#Deploy a K8s object.
kubectl apply -f <FILEPATH>/<FILE_NAME>

#Deploy multiple K8s object.
kubectl apply -f <FILEPATH>/<FILE_NAME> -f <FILEPATH>/<FILE_NAME>

#Get deployments.
kubectl get deployments -n <NAMESPACE_NAME>

#Get pods.
kubectl get pods -n <NAMESPACE_NAME>

#To describe pods specification.
kubectl describe pods <POD_NAME> -n <NAMESPACE_NAME>

#Check logs.
kubectl logs podName -n <NAMESPACE_NAME>

#Edit YAML file.
kubectl edit <K8S_RESOURCE> <RESOURCE_NAME>

#Get outpot of the YAML file.
kubectl get <K8S_RESOURCE> <RESOURCE_NAME> -o=yaml

#Retrieves information about pods in a Kubernetes cluster, including additional details such as node allocation and IP addresses, in a wide output format.
kubectl get pods -o wide

#Displays real-time CPU and memory usage statistics for the pods within the specified namespace in a Kubernetes cluster.
kubectl top pods -n <NAMESPACE_NAME>

#Get services.
kubectl get svc -n <NAMESPACE_NAME>
kubectl get service -n <NAMESPACE_NAME>

#Get Service accounts.
kubectl get serviceaccounts -n <NAMESPACE_NAME>

#Delete Service accounts
kubectl delete serviceaccount/<SERVICE_ACCOUNT_NAME>

#Get Horizontal Pod Autoscaler.
kubectl get hpa -n <NAMESPACE_NAME>

#Lists all Custom Resource Definitions (CRDs) configured in a Kubernetes cluster, providing an overview of the custom resources available in the cluster.
kubectl get crd

#Is a fully qualified domain name (FQDN) convention used in Kubernetes to access a service within the same cluster.
<service-name>.<service-namespace>.svc.cluster.local
