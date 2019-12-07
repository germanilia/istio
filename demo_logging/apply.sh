kubectl apply -f logging-stack.yaml
kubectl apply -f ../istio-1.4.0/samples/bookinfo/telemetry/fluentd-istio.yaml
kubectl -n logging port-forward $(kubectl -n logging get pod -l app=kibana -o jsonpath='{.items[0].metadata.name}') 5601:5601 &
