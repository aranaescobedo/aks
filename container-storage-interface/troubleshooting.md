# 🕵️ Troubleshoot Container Storage Interface (CSI)
This README contains a collection of solutions for common troubleshooting scenarios that may arise when using CSI on AKS.

## **If you are encountering the error messages**:
  -  ```Unable to attach or mount volumes: unmounted volumes=[pvc-volume], unattached volumes=[kube-api-access-k26b8 azure-identity-token secrets-store-inline secrets-store-inline-db pvc-volume]: timed out waiting for the condition``` **or**
  - ```AttachVolume.Attach failed for volume "<PVC_NAME>" : timed out waiting for external-attacher of disk2.csi.azure.com CSI driver to attach volume /subscriptions/<SUB_NAME>/<RSG_NAME>/providers/Microsoft.Compute/disks/<DISK_NAME>"``` 
- **while trying to attach a volume to your AKS cluster, it may be due to a permission issue.**
  - If you are using your own **disk encryption set** to mount on your cluster, you need to ensure that the cluster identity has **Read permission**. Additionally, you need to make sure that the cluster identity has **Contributor permission** on the **disk**.
  -  It is important to note that this issue is more likely to occur when you create the disk or disk encryption set outside the cluster node resource group that is automatically created by Azure when you create an AKS cluster.

## When you delete a persistant volume claim (PVC) or persistant volume (PV), sometimes it may get stuck in a "Terminating" state due to pods that are still using the PVC
- Ensure that there are no pods using the PVC before deleting it.

- If you are still having issues with the Terminating state being stuck even after deleting all pods that are using the PVC, you can use the following commands:
  - ```kubectl patch pvc <PVC_NAME> -p '{"metadata":{"finalizers":null}}' -n <NAMESPACE_NAME>```
  - ``` kubectl patch pv <PV_NAME> -p '{"metadata":{"finalizers":null}}'```


