.PHONY: cluster install alerts-secret demo grafana load down
cluster:
	kind create cluster --name obs
install:
	kubectl create namespace monitoring --dry-run=client -o yaml | kubectl apply -f -
	kubectl -n monitoring get secret alertmanager-slack-webhook >/dev/null 2>&1 || \
	  kubectl -n monitoring create secret generic alertmanager-slack-webhook \
	    --from-literal=url="https://hooks.slack.com/services/REPLACE/ME"
	helm repo add prometheus-community https://prometheus-community.github.io/helm-charts
	helm repo add grafana https://grafana.github.io/helm-charts
	helm repo update
	helm upgrade --install kps prometheus-community/kube-prometheus-stack -n monitoring -f values/kube-prometheus-stack.yaml --wait
	helm upgrade --install loki grafana/loki -n monitoring -f values/loki.yaml
	helm upgrade --install promtail grafana/promtail -n monitoring -f values/promtail.yaml
	kubectl apply -f dashboards/
alerts-secret:
	@read -p "Slack webhook URL for critical alerts: " url; \
	kubectl -n monitoring create secret generic alertmanager-slack-webhook \
	  --from-literal=url="$$url" \
	  --dry-run=client -o yaml | kubectl apply -f -
demo:
	kubectl create namespace demo --dry-run=client -o yaml | kubectl apply -f -
	kubectl apply -f manifests/
grafana:
	kubectl -n monitoring port-forward svc/kps-grafana 3000:80
load:
	kubectl -n demo port-forward svc/podinfo 9898:9898 & sleep 3; k6 run load-test/k6.js
down:
	kind delete cluster --name obs
