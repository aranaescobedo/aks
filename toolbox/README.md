manifests/toolbox.yaml

- <ACR_LOGIN_SERVER_NAME>: Add the Azure Container Registry server name.

azure-pipelines-toolbox-build.yaml

- <AGENT_NAME>: The agent pool name or use the Microsoft hosted agent.
- <ACR_SERVICE_CONNECTION_NAME>: The name of the Azure Container Registry service connection.

azure-pipelines-toolbox-deploy.yaml
- <AGENT_NAME>: The agent pool name or use the Microsoft hosted agent.
- <ACR_LOGIN_SERVER_NAME>: Add the Azure Container Registry server name.
- <AKS_SERVICE_CONNECTION_NAME>: The name of the Azure Kubernetes Service service connection.
- <NAMESPACE_NAME>: The namespace where you want to deploy your toolbox container.
