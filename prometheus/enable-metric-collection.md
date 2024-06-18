LATEST=$(curl -s https://api.github.com/repos/prometheus-operator/prometheus-operator/releases/latest | jq -cr .tag_name)
curl https://raw.githubusercontent.com/prometheus-operator/prometheus-operator/$LATEST/example/prometheus-operator-crd/monitoring.coreos.com_servicemonitors.yaml | kubectl create -f -
