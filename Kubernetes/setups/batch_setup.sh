#!/bin/bash

# setup_kubectl.sh 実行
echo setup_kubectl.sh 実行中...
./setup_kubectl.sh
echo setup_kubectl.sh 実行完了

# setup_coredns_on_fargate.sh 実行
echo setup_coredns_on_fargate.sh 実行中...
./setup_coredns_on_fargate.sh
echo setup_coredns_on_fargate.sh 実行完了

# setup_helm.sh 実行
echo setup_helm.sh 実行中...
./setup_helm.sh
echo setup_helm.sh 実行完了

echo 全てのスクリプト実行完了

exit 0
