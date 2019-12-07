#cleanup
./cleanup.sh

#install istio
kubectl apply -f istio-1.4.0/install/kubernetes/helm/helm-service-account.yaml && \
helm init --service-account tiller && \
helm install istio-1.4.0/install/kubernetes/helm/istio-init --name istio-init --namespace istio-system && \
kubectl -n istio-system wait --for=condition=complete job --all && \
helm install istio-1.4.0/install/kubernetes/helm/istio --name istio --namespace istio-system \
    --values istio-1.4.0/install/kubernetes/helm/istio/values-istio-demo.yaml

# deploy demo application
kubectl create ns demo && \
kubectl config set-context istio-sdp --namespace demo && \
kubectl label ns demo istio-injection=enabled && \
kubectl apply -f istio-1.4.0/samples/bookinfo/platform/kube/bookinfo.yaml
#ingress
kubectl apply -f istio-1.4.0/samples/bookinfo/networking/bookinfo-gateway.yaml && \
kubectl get gateway

kubectl apply -f istio-1.4.0/samples/bookinfo/networking/bookinfo-gateway.yaml && \
export INGRESS_HOST=$(kubectl -n istio-system get service istio-ingressgateway -o jsonpath='{.status.loadBalancer.ingress[0].hostname}') && \
export INGRESS_PORT=$(kubectl -n istio-system get service istio-ingressgateway -o jsonpath='{.spec.ports[?(@.name=="http2")].port}') && \
export SECURE_INGRESS_PORT=$(kubectl -n istio-system get service istio-ingressgateway -o jsonpath='{.spec.ports[?(@.name=="https")].port}') && \
export GATEWAY_URL=$INGRESS_HOST:$INGRESS_PORT

#default rules
kubectl apply -f istio-1.4.0/samples/bookinfo/networking/destination-rule-all.yaml && \
kubectl get destinationrules -o yaml
echo "url: $GATEWAY_URL/productpage"