# DataPower automation

This repository can be used to automate the build, test and deploy of your
DataPower gateway to OpenShift Kubernetes.

## Overview

![diagram1](./docs/images/diagram1.drawio.png)

## Comments

- The following works on OpenShift and minikube
- Need to move from Kaniko to Buildah

## Tutorial steps (outline pt I)

- Fork repository from Template (all branches) e.g. mygituser/dp01src
- `git clone` dp01src to local machine
- cd to dp01src repo
- `git checkout pipelines` branch
- Install kubernetes cluster
  - minikube, OCP options initally
- kubectl login to cluster
- new namespace 
  - dp01-ns
- install Tekton 
  - operator hub or CLI (minikube)?  
  - (manual Tekton install: kubectl apply -f https://storage.googleapis.com/tekton-releases/pipeline/previous/v0.16.3/release.yaml)
  - (manual approval)
- install sample hello-world task
  - `oc apply -f hello-world.yaml`
  - `task.tekton.dev/hello created`
- run sample task
  - `oc create -f hello-world-run.yaml`
  - `taskrun.tekton.dev/hello-task-run-v8q99 created` (e.g.)
- view task log
  - `tkn taskrun logs hello-task-run-v8q99`
  - `[echo] Hello World`
- review task
  - (brief walk through of YAMLs)
  - explore in console (optional for openshift) 
- Set up pipeline
  - `√ sample % oc apply -f goodbye-world.yaml`
  - `task.tekton.dev/goodbye created`
  - `√ sample % oc apply -f hello-goodbye-pipeline.yaml`
  - `pipeline.tekton.dev/hello-goodbye created`
- run sample pipeline
  - `√ sample % oc create  -f hello-goodbye-pipeline-run.yaml`
  - `pipelinerun.tekton.dev/hello-goodbye-run-v5wmb created`
  - `√ sample % tkn pipelinerun logs hello-goodbye-run-v5wmb`
  - `Pipeline still running ...`
  - `[hello : echo] Hello World`
  - `[goodbye : goodbye] Goodbye World!`
- review pipeline
  - (brief walk through of YAMLs) 
  - explore in console (optional for openshift) 

## Tutorial (outline pt II)

- Work on `dp-build` pipeline
- Locate pipeline and tasks
  - `cd /../dev-build`
  - `ls`
- Apply tasks and pipeliens
  - `√ dev-build % oc apply -f dp-clone.yaml`
  - `task.tekton.dev/git-clone created`
  - `√ dev-build % oc apply -f dp-image.yaml`
  - `task.tekton.dev/kaniko created`
  - `?127 dev-build % oc apply -f dp-task-01.yaml`
  - `task.tekton.dev/dp-task-01 created`
  - `√ dev-build % oc apply -f dp-image-pipeline.yaml`
  - `pipeline.tekton.dev/dp-build-run created`
- Run pipeline
  - `√ dev-build % oc create -f dp-image-pipelinerun.yaml`
  - `pipelinerun.tekton.dev/dp-build-run-dfwrg created`
  - `√ dev-build % tkn pipelinerun logs dp-build-run-dfwrg`       
  - `Pipeline still running ...`  
  - (include tkn pipelinerun log output)
- Fails in Kaniko step
  - Need to swap to `Buildah`

