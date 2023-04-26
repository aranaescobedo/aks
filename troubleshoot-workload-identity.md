# Troubleshoot workload identity

## 403
-  ```error: code = Unknown desc = failed to mount objects, error: failed to get objectType:secret, objectName:application-insight-connection-string, objectVersion:: keyvault.BaseClient#GetSecret: Failure responding to request: StatusCode=403 -- Original Error: autorest/azure: Service returned an error. Status=403 Code="Forbidden" Message="Client address is not authorized and caller is not a trusted service.\r\nClient address: <IP_ADDRESS> from unknown subnet\ r\nVault: <KEY_VAULT_NAME>;location=westeurope" InnerError={"code":"ForbiddenByFirewall"}:``` You may need to add your cluster's virtual network to your Key Vault network to establish connectivity.

## 404
  - ```error: reply status code was 400: {"error":"invalid_request","error_description":"AADSTS70021: No matching federated identity record found for presented assertion:```Check that you have the correct ClientID in your SecretProviderClass YAML file.
  - ```error: failed to get keyvault client: failed to get authorizer for keyvault client: nmi response failed with status code: 404, response body: getting assigned identities for pod <POD_NAME> in CREATED state failed after 16 attempts, retry duration [5]s, error: <nil>. Check MIC pod logs for identity assignment errors:``` Ensure that the SecretProviderClass YAML file contains a valid ClientID and is not empty.
 
