#!/bin/bash

# Patch the coredns deployment to remove a specific annotation
kubectl patch deployment coredns \
    -n kube-system \
    --type json \
    -p='[{"op": "remove", "path": "/spec/template/metadata/annotations/eks.amazonaws.com~1compute-type"}]'

# Restart the rollout of the coredns deployment
kubectl rollout restart -n kube-system deployment coredns

exit 0
