# Set the environment
ENV=$1

K8S_SECRET_NAME=${2:- "istio-credentials"}  # Use 'istio-credentials' as default if no argument is provided

# Define variables for Key Vault access and Kubernetes integration
CERT_NAME=""
KV_NAME=""
K8S_NAMESPACE="aks-istio-ingress"
SUBSCRIPTION_NAME=""

# Set the subscription
az account set --subscription $SUBSCRIPTION_NAME

echo "[*] Create a certificate temporary folder"
FOLDER_NAME="cert_temp"
mkdir $FOLDER_NAME

echo "[*] Download certificate from Key Vault"
az keyvault certificate download \
    --vault-name "$KV_NAME" \
    --name "$CERT_NAME" \
    --file $FOLDER_NAME/tls.crt

echo "[*] Download private key from Key Vault"
az keyvault secret download \
    --vault-name "$KV_NAME" \
    --name "$CERT_NAME" \
    --file $FOLDER_NAME/encrypted-tls.key \
    --encoding base64

echo "[*] Decrypting the private key (removing passphrase)"
openssl rsa -in $FOLDER_NAME/encrypted-tls.key -out $FOLDER_NAME/tls.key

# *** This code snippet will be commented because it will be handled by the Azure pipeline. ***
echo "[*] Create secret $K8S_SECRET_NAME on cluster"
kubectl create secret tls $K8S_SECRET_NAME \
   --cert=$FOLDER_NAME/tls.crt \
   --key=$FOLDER_NAME/tls.key \
   --namespace $K8S_NAMESPACE

echo "[*] Remove temporary folder"
rm -rf $FOLDER_NAME

# ****************************************************************