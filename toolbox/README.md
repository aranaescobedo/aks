# Toolbox-container 🧰

Before using the toolbox container, make sure that you have replaced all the placeholders with your values.

### Dockerfile

- ```FROM```: Using Ubuntu:18.04, if you are using a newer version, don't forget to update the FROM instruction.
- If you are missing a specific package you want to install to troubleshoot your issue more easily, simply add it to the Dockerfile.

### manifests/deployment.yaml

- ```<ACR_LOGIN_SERVER_NAME>```: Add the Azure Container Registry server name.

### azure-pipelines-toolbox-build.yaml

- ```<AGENT_NAME>```: The agent pool name or use the Microsoft hosted agent.
- ```<ACR_SERVICE_CONNECTION_NAME>```: The name of the Azure Container Registry service connection.

### azure-pipelines-toolbox-deploy.yaml
- ```<ADD_DEFAULT_ENV_VALUE>```: Add the default value for your environment deploy.
- ```<AGENT_NAME>```: The agent pool name or use the Microsoft hosted agent.
- ```<ACR_LOGIN_SERVER_NAME>```: Add the Azure Container Registry server name.
- ```<AKS_SERVICE_CONNECTION_NAME>```: The name of the Azure Kubernetes Service service connection.
- ```<NAMESPACE_NAME>```: The namespace where you want to deploy your toolbox container.

- ```<PICK_AZURE_DEVOPS_PROJECT_NAME>```: Specify the Azure DevOps project from which to download the build artifacts.
- ```<PICK_BUILD_PIPELINE_NAME>```: Choose the name of the build pipeline.
