#!/bin/bash

kubectl create deployment nginx --image=howto:nginx

#
#
kubectl get service nginx


#
# Clean up
#
# kubectl delete service hello-server nginx
# gcloud container clusters delete first-cluster
