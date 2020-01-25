export NS=test-monitoring
export NAME_PREFIX=test
rm kustomization.yaml
kubectl delete namespace $NS
kubectl create namespace $NS
kustomize create --autodetect
sed PrometheusOperator.yaml -e "s/- my-prometheus/- $NS/g" -i
cat << EOF >> kustomization.yaml
namePrefix: $NAME_PREFIX-
namespace: $NS
vars:
  - name: NAMESPACE
    objref:
      kind: Prometheus
      name: example
      apiVersion: monitoring.coreos.com/v1
    fieldref:
      fieldPath: metadata.namespace
EOF

kustomize build > main.yaml
kubectl apply -f main.yaml
