#Retrieve namespace details and save them to a JSON file:
kubectl get namespace <NAMESPACE_NAME> -o json > temp.json

#Open the temp.json file and remove the content inside the spec.finalizers section.

#Establish a connection to your Kubernetes cluster by running the following command:
kubectl proxy

#In a new terminal session, run the following command:
curl -k -H "Content-Type: application/json" -X PUT --data-binary "@temp.json" http://127.0.0.1:8001/api/v1/namespaces/<NAMESPACE_NAME>/finalize

#For Linux or Bash:
#curl -k -H "Content-Type: application/json" -X PUT --data-binary @temp.json http://127.0.0.1:8001/api/v1/namespaces/<NAMESPACE_NAME>/finalize

#Once the deletion is complete, don't forget to stop the kubectl proxy by pressing Ctrl + C.

