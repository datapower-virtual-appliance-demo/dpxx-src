# DataPower automation

This repository can be used to automate the build, test and deploy of your
DataPower gateway to OpenShift Kubernetes.

## Overview

![diagram1](./docs/images/diagram1.drawio.png)

## Tutorial steps (outline)

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

