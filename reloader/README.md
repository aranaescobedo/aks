<p align="center">
 <img width="100px" src="../.images/reloader-round.png" align="center" alt="Stakater Reloader" />
 <h2 align="center">Stakater Reloader</h2>
 <p align="center">This folder contains scripts that are used to interact with Stakater Reloader.</p>
</p>

To obtain the latest `Secret` as an environment variable in our pod, you need to restart it. [Secrets Store CSI Driver docs][CSI-docs] recommends using the tool [Reloader][Reloader-GitHub] by Stakater. It also check changes on the `ConfigMap` adn then perform a rolling upgrade on relevant `DeploymentConfig`, `Deployment`, `Daemonset`, `Statefulset` and `Rollout`.

To check one way of doing this check the [script.ps1](script.ps1)

[Reloader-GitHub]:https://github.com/stakater/Reloader/blob/master/README.md
[CSI-docs]:https://secrets-store-csi-driver.sigs.k8s.io/topics/secret-auto-rotation.html#enable-auto-rotation
