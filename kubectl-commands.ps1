#Is used to authenticate and gain access to Azure resources and services.
az login

#Attention, if you have a lot of different subscriptions connected to your account, use.
az account set --subscription <SUBSCRIPTION_NAME>

#Authenticate your k8s cluster.
az aks get-credentials -g <RESOURCE_GROUP_NAME> -n <CLUSTER_NAME>

#List all contexts defined in your kubeconfig file.
kubectl config get-contexts

#Displays the configuration settings (context, cluster, user, etc.) and the authentication credentials being used for your Kubernetes cluster.
kubectl config view

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

#Add label on node.
kubectl label node <NODE_NAME> <LABEL_NAME>=<TAG_VALUE>

#Delete label on node.
kubectl label node <NODE_NAME> <LABEL_NAME>-

#Create a new namespace.
kubectl create namespace <NAMESPACE_NAME>

#Create a label on the namespace.
kubectl label namespace <NAMESPACE_NAME> name=<Value>

#Set a default namespace.
kubectl config set-context --current --namespace=<NAMESPACE_NAME>

#Retrieves a list of Kubernetes namespaces and displays only their names without any additional headers or formatting.
kubectl get namespaces -o custom-columns="NAMESPACE:.metadata.name" --no-headers

#Deploy a K8s object with kustomize.
kubectl apply -k <KUSTOMIZATION_DIRECTORY>

#Deploy a K8s object.
kubectl apply -f <FILEPATH>/<FILE_NAME>

#Deploy multiple K8s object.
kubectl apply -f <FILEPATH>/<FILE_NAME> -f <FILEPATH>/<FILE_NAME>

#Get deployments.
kubectl get deployments -n <NAMESPACE_NAME>

#Get ALL the deployment names
kubectl get deployments --all-namespaces -o custom-columns="DEPLOYMENT NAME:.metadata.name" | ForEach-Object { $_.Trim() }

#Retrieves JSON-formatted information about all deployments in a cluster, saving the output to a file named "deployments.json.
kubectl get deployments --all-namespaces -o json > deployments.json

#Retrieves YAML-formatted information about all deployments in a cluster, saving the output to a file named "deployments.yaml.
kubectl get deployments --all-namespaces -o yaml > deployments.yaml

#To manually scale
kubectl scale deployment <DEPLOYMENT_NAME> -n <NAMESPACE_NAME> --replicas=3
kubectl get deployment <DEPLOYMENT_NAME> -n <NAMESPACE_NAME>

#Delete a deployment (pod included).
kubectl delete deploy <DEPLOYMENT_NAME> -n <NAMESPACE_NAME>

#Get pods.
kubectl get pods -n <NAMESPACE_NAME>

#Get ALL the pod names
kubectl get pods --all-namespaces -o custom-columns="POD NAME:.metadata.name" | ForEach-Object { $_.Trim() }

#List pods in all namespaces.
kubectl get pods -A

#To describe pods specifications.
kubectl describe pods <POD_NAME> -n <NAMESPACE_NAME>

#Check logs.
kubectl logs <POD_NAME> -n <NAMESPACE_NAME>

#Retrieves information about pods in a Kubernetes cluster, including additional details such as node allocation and IP addresses, in a wide output format.
kubectl get pods -o wide

#Displays real-time CPU and memory usage statistics for the pods within the specified namespace in a Kubernetes cluster.
kubectl top pods -n <NAMESPACE_NAME> --sum=true

#Is used to list all pods in a specific namespace in a Kubernetes cluster and display their names and images. It then filters OUT any pods whose images are coming from a specified Azure Container Registry (ACR).
kubectl get pods -n <NAMESPACE_NAME> -o custom-columns='POD:.metadata.name, IMAGE:.spec.containers[*].image' | Where-Object { $_ -notmatch "<ACR_NAME>" }

#Allows interactive access to a specific pod in a given namespace, opening a bash shell within the container.
kubectl exec -it <POD_NAME> -n <NAMESPACE_NAME> -- /bin/bash

#Get services.
kubectl get svc -n <NAMESPACE_NAME>
kubectl get service -n <NAMESPACE_NAME>

#Get Service accounts.
kubectl get serviceaccounts -n <NAMESPACE_NAME>

#Delete Service accounts.
kubectl delete serviceaccount/<SERVICE_ACCOUNT_NAME>

#Get Horizontal Pod Autoscaler.
kubectl get hpa -n <NAMESPACE_NAME>

#Create the secret
kubectl create secret generic <SECRET_NAME> --from-literal=<SECRET_KEY>=<SECRET_VALUE> -n <NAMESPACE>

#Edit YAML file.
kubectl edit <K8S_RESOURCE> <RESOURCE_NAME>

#Get output of the YAML file.
kubectl get <K8S_RESOURCE> <RESOURCE_NAME> -o=yaml

#Use kubectl patch to force delete on a persistent volume.
kubectl patch pv <PERSISTENT_VOLUME_NAME> -p '{\"metadata\":{\"finalizers\":null}}'

#Lists all Custom Resource Definitions (CRDs) configured in a Kubernetes cluster, providing an overview of the custom resources available in the cluster.
kubectl get crd

#Sets up a local port forwarding that redirects traffic from a specified local port to a service's port within a given namespace,
#allowing direct access to the service from your local machine.
kubectl port-forward service/<SERVICE_NAME> <YOUR_LOCAL_PORT_NUMBER>:<SERVICE_PORT_NUMBER> -n <NAMESPACE_NAME>

#Run nslookup inside the container
kubectl exec --stdin --tty <POD_NAME> -n <NAMESPACE_NAME> -- /bin/bash
apt-get update
apt install dnsutils
nslookup <URL>

#Is a fully qualified domain name (FQDN) convention used in Kubernetes to access a service within the same cluster.
<SERVICE_NAME>.<SERVICE_NAMESPACE>.svc.cluster.local:<SERVICE_PORT_NUMBER>

#Is used to find out the internal IP address of a service in a Kubernetes cluster, helping to check if the service is correctly set up and reachable within the cluster.
nslookup <SERVICE_NAME>.<SERVICE_NAMESPACE>.svc.cluster.local

#Verify that you can access the pods, you should receive an HTTP 200 OK response by using the following command.
wget <SERVICE_NAME>.<SERVICE_NAMESPACE>.svc.cluster.local:<SERVICE_PORT_NUMBER>

#Try to send an HTTP request with a specific subpath.
curl <SERVICE_NAME>.<SERVICE_NAMESPACE>.svc.cluster.local:<SERVICE_PORT_NUMBER>/<SUB_PATH>

#Check the API version running on a specific Kubernetes resource.
kubectl get <K8S_RESOURCE> --all-namespaces -o=jsonpath="{range .items[*]}{.apiVersion}`t{.kind}`t{.metadata.name}`n{end}"
