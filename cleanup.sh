#uninstall istio
helm delete --purge istio ; \
helm delete --purge istio-init ; \
helm delete --purge istio-cni ; \
kubectl delete namespace istio-system ; \
kubectl delete namespace demo