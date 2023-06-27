#Displays real-time CPU and memory usage statistics for the nodes in a Kubernetes cluster.
kubectl top nodes

#Filter on node name
kubectl top nodes | Where-Object { $_ -like "*<NODE_NAME>*" }

#Displays real-time CPU and memory usage statistics for the pods within the specified namespace in a Kubernetes cluster.
kubectl top pods -n <NAMESPACE_NAME>

#Provides detailed information about a node in the Kubernetes cluster, including its labels, capacity, usage, conditions, and other relevant details.
kubectl describe node <NODE_NAME>
