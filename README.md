# DataPower automation

This repository can be used to automate the build, test and deploy of your
DataPower gateway to OpenShift Kubernetes.

## Overview

The following diagram shows a GitOps CICD pipeline for DataPower:

![diagram1](./docs/images/diagram1.drawio.png)

Notice how: 

- The git repository `dp01-src` holds the source configuration for the DataPower `dp01`
- This repository also holds the source for a multi-protocol gateway
- A Tekton pipeline usese the source repository to build, package, test, version and deliver changes to the `dp01` component.
- If the pipeline is successful, then the YAMLs that define `dp01` are stored in the operational repository `dp01-ops`. The container image for `dp01` is stored in an image registry.
- Shortly after the changes are committed to the git repository, an ArgoCD application detects the updated YAMLs. It applies them to the cluster to update the running `dp01`

This tutorial will walk you through the process of setting up this configuration.

---

## Install Kubernetes

Cover Minikube OCP options -->links

---

## install Tekton 
  - operator hub or CLI (minikube)?  
  - (manual Tekton install: kubectl apply -f https://storage.googleapis.com/tekton-releases/pipeline/previous/v0.16.3/release.yaml)
  - (manual approval)

---

## Fork repository
[Fork this repository](https://github.com/dp-auto/dpxx-src/generate) from a `Template`. 
  - Ensure you include all branches by tickinging `Include all branches`. 
  - Fork the respository to **your Git user** e.g. `<mygituser>/dp01src`

---

## Clone repository to your local machine

Open new Terminal

Set userid, to your userid, e.g. `odowdaibm`

```bash
export GITUSER=odowdaibm
```

```bash
mkdir -p $HOME/git/datapower
cd $HOME/git/datapower
git clone git@github.com:$GITUSER/dp01src.git
```

---

## Work on pipelines

```bash
cd dp01src
git checkout pipelines
```

---

## Login to cluster

```bash
oc login
```

---

## Create namespace for dp01

```bash
oc create namespace dp01-dev
```

---

## install sample hello-world task
  - `oc apply -f hello-world.yaml`
  - `task.tekton.dev/hello created`

---

## run sample task
  - `oc create -f hello-world-run.yaml`
  - `taskrun.tekton.dev/hello-task-run-v8q99 created` (e.g.)

---

## view task log
  - `tkn taskrun logs hello-task-run-v8q99`
  - `[echo] Hello World`

---

## review task
  - (brief walk through of YAMLs)
  - explore in console (optional for openshift) 

---

## Set up pipeline
  - `√ sample % oc apply -f goodbye-world.yaml`
  - `task.tekton.dev/goodbye created`
  - `√ sample % oc apply -f hello-goodbye-pipeline.yaml`
  - `pipeline.tekton.dev/hello-goodbye created`

---

## run sample pipeline
  - `√ sample % oc create  -f hello-goodbye-pipeline-run.yaml`
  - `pipelinerun.tekton.dev/hello-goodbye-run-v5wmb created`
  - `√ sample % tkn pipelinerun logs hello-goodbye-run-v5wmb`
  - `Pipeline still running ...`
  - `[hello : echo] Hello World`
  - `[goodbye : goodbye] Goodbye World!`

---

## review pipeline
  - (brief walk through of YAMLs) 
  - explore in console (optional for openshift) 

---

## Locate Datapower pipeline

```bash
cd $HOME/git/datapower/dp01-src/dev-build
ls
```

## Apply tasks and pipeliens
  
```bash  
oc apply -f dp-clone.yaml
```

```bash
oc apply -f dp-image.yaml
```

```bash
oc apply -f dp-task-01.yaml
```

```bash
oc apply -f dp-push.yaml
```

```bash
oc apply -f dp-image-pipeline.yaml
```

## Generate ssh keys for GitHub access

```bash
ssh-keygen -t rsa -b 4096 -C "your_email@example.com" -f ./.ssh/id_rsa -q -N ""
```

```bash
ssh-keyscan -t rsa github.com | tee ./.ssh/github-key-temp | ssh-keygen -lf - && cat ./.ssh/github-key-temp >> ./.ssh/known_hosts
```

```bash
oc create secret generic dp01-ssh-credentials -n dp01-dev --from-file=id_rsa=./.ssh/id_rsa --from-file=known_hosts=./.ssh/known_hosts --from-file=./.ssh/config --dry-run=client -o=yaml
```

```bash
oc create secret generic dp01-ssh-credentials -n dp01-dev --from-file=id_rsa=./.ssh/id_rsa --from-file=known_hosts=./.ssh/known_hosts --from-file=./.ssh/config --dry-run=client -o yaml > dp-git-credentials.yaml
```

```bash
oc apply -f dp-git-credentials.yaml
```

## Copy ssh credential into Github

Need to add ssh public key to GitHub to authorise access:

```bash
https://github.com/settings/keys
```

![diagram2](./docs/images/diagram2.png)


Copy public key to clipboard

```bash
pbcopy < ./.ssh/id_rsa.pub
```

* Add name
* Paste key into box

![diagram3](./docs/images/diagram3.png)

* Hit `Add SSH key` button

### Path `pipeline` serviceaccount

```bash
oc patch serviceaccount pipeline \
    --namespace dp01-dev \
    --type merge \
    --patch '{"secrets":[{"name":"dp01-ssh-credentials"}]}'
```

## Run pipeline

```bash
oc create -f dp-image-pipelinerun.yaml
```

```bash
tkn pipelinerun logs dp-build-run-dfwrg -n dp01-dev
```
