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

## Fork repository
[Fork this repository](https://github.com/dp-auto/dpxx-src/generate) from a `Template`. 
  - Ensure you include all branches by ticking `Include all branches`. 
  - Fork the respository to **your Git user** e.g. `<mygituser>/dp01-src`

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
git clone git@github.com:$GITUSER/dp01-src.git
```

---

## Work on pipelines

```bash
cd dp01-src
git checkout pipelines
```

---

## Login to cluster

```bash
oc login
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

## Locate Datapower pipeline source

```bash
cd $HOME/git/datapower/dp01-src/pipelines/dev-build
ls
```

---

## Create cluster pipeline resources
  
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

---

## Create dp01-ops repository

We're almost ready to run the pipeline. When it runns, it will place its output in the `dp01-ops` repository.

Follow [these instructions](https://github.com/dp-auto/dpxx-ops/blob/main/README.md) to create the `dp01-ops` repository.

When you have completed this task, proceed to the [next step](##run-pipeline) in this tutorial.

---

## Run pipeline

```bash
oc create -f dp-image-pipelinerun.yaml
```

In the following command replace `xxxxx` with the new pipeline run identifier:

```bash
tkn pipelinerun logs dp-build-run-xxxxx -n dp01-dev -f
```

## View pipelinerun in the web console



