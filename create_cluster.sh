# Create cluster
eksctl create cluster \
--name istio-sdp \
--version 1.14 \
--region eu-west-2 \
--nodegroup-name istio-sdp-workers \
--node-type t3.medium \
--nodes 3 \
--nodes-min 1 \
--nodes-max 4 \
--managed