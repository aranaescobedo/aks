# 🕵️ Troubleshoot Container Storage Interface (CSI)

- AttachVolume.Attach failed for volume "<PVC_NAME>" : timed out waiting for external-attacher of disk2.csi.azure.com CSI driver to attach volume /subscriptions/<SUB_NAME>/<RSG_NAME>/providers/Microsoft.Compute/disks/<DISK_NAME>

- Unable to attach or mount volumes: unmounted volumes=[pvc-volume], unattached volumes=[kube-api-access-k26b8 azure-identity-token secrets-store-inline secrets-store-inline-db pvc-volume]: timed out waiting for the condition
  - If you are using your own Disk Encryption Set to mount on your cluster you need to make sure that the cluster identity has read permission.
  - Check also that the cluster identity has Contributor permission on the disk
  - This issues is more often to accure when your not creating the **disk** or **disk encryption set** inside the cluster node resurs group that is created automatically by Azure when you create a AKS.


- When you delete a persistant volume claim (PVC) or persistant volume (PV), sometimes it may get stuck in a "Terminating" state due to pods that are still using the PVC. To resolve this issue, **you need to ensure that there are no pods using the PVC before deleting it.**

- If you are still having issues with the Terminating state being stuck even after deleting all pods that are using the PVC, you can use the following commands:
  - ```kubectl patch pvc <PVC_NAME> -p '{"metadata":{"finalizers":null}}' -n <NAMESPACE_NAME>```
  - ``` kubectl patch pv <PV_NAME> -p '{"metadata":{"finalizers":null}}'```


