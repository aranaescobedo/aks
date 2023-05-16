# 🕵️ Troubleshoot workload identity
This README contains a collection of solutions for common troubleshooting scenarios that may arise when using workload identity on AKS.

## **If you are encountering these error messages**:

### 401
- ```error: code = Unknown desc = failed to mount objects, error: failed to get keyvault client: failed to get authorizer for keyvault client: failed to acquire token: FromAssertion(): http call(https://login.microsoftonline.com/<TENANT_ID>/oauth2/v2.0/token)(POST) error: reply status code was 401: {"error":"unauthorized_client","error_description":"AADSTS70021: No matching federated identity record found for presented assertion. Assertion Issuer: 'https://westeurope.oic.prod-aks.azure.com/<TENANT_ID>/<FEDERATED_IDENTITY_ID>/'. Assertion Subject: 'system:serviceaccount:serviceportal:<SERVICE_ACCOUNT_NAME>'. Assertion Audience: 'api://AzureADTokenExchange'. https://docs.microsoft.com/en-us/azure/active-directory/develop/workload-identity-federation\r\nTrace ID: <TRACE_ID>\r\nCorrelation ID: <CORRELATION_ID>\r\nTimestamp: <TIMESTAMP>","error_codes":[70021],"timestamp":"<TIMESTAMP>","trace_id":"<TRACE_ID>","correlation_id":"<CORRELATION_ID>","error_uri":"https://login.microsoftonline.com/error?code=70021"}```
  - **Recreate the federated identity credential with the specific user-assigned identity.**

- ```error: code = Unknown desc = failed to mount objects, error: failed to get keyvault client: failed to get authorizer for keyvault client: failed to acquire token: FromAssertion(): http call(https://login.microsoftonline.com/<TENANT_ID>/oauth2/v2.0/token)(POST) error: reply status code was 401:{"error":"unauthorized_client","error_description":"AADSTS70021: No matching federated identity record found for presented assertion. Assertion Issuer: 'https://westeurope.oic.prod-aks.azure.com/<TENANT_ID>/<FEDERATED_IDENTITY_ID>/'. Assertion Subject: 'system:serviceaccount:<NAMESPACE>:<SERVICE_ACCOUNT_NAME>'. Assertion Audience: 'api://AzureADTokenExchange'. https://docs.microsoft.com/en-us/azure/active-directory/develop/workload-identity-federation\r\nTrace ID: <TRACE_ID>\r\nCorrelation ID: <CORRELATION_ID>\r\nTimestamp: <TIMESTAMP>","error_codes":[70021],"timestamp":"<TIMESTAMP>","trace_id":"<TRACE_ID>","correlation_id":"<CORRELATION_ID>","error_uri":"https://login.microsoftonline.com/error?code=70021"}```
  - **Ensure that the SecretProviderClass YAML file contains a valid ClientID and is not empty or has the wrong value.**

### 403
-  ```error: code = Unknown desc = failed to mount objects, error: failed to get objectType:secret, objectName:<SECRETNAME>, objectVersion:: keyvault.BaseClient#GetSecret: Failure responding to request: StatusCode=403 -- Original Error: autorest/azure: Service returned an error. Status=403 Code="Forbidden" Message="Client address is not authorized and caller is not a trusted service.\r\nClient address: <IP_ADDRESS> from unknown subnet\ r\nVault: <KEY_VAULT_NAME>;location=westeurope" InnerError={"code":"ForbiddenByFirewall"}```

   -  **You may need to add your cluster's virtual network to your Key Vault network to establish connectivity.**

### 404
  - ```error: reply status code was 400: {"error":"invalid_request","error_description":"AADSTS70021: No matching federated identity record found for presented assertion```
    - **Check that you have the correct ClientID in your SecretProviderClass YAML file.**

  - ```error: failed to get keyvault client: failed to get authorizer for keyvault client: nmi response failed with status code: 404, response body: getting assigned identities for pod <POD_NAME> in CREATED state failed after 16 attempts, retry duration [5]s, error: <nil>. Check MIC pod logs for identity assignment errors```
    - **Ensure that the SecretProviderClass YAML file contains a valid ClientID and is not empty.**
 
