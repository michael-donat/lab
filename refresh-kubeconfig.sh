#!/usr/bin/env bash
set -euo pipefail

CONTROL_PLANE="mikey@k8s-master.lab.donat.im"
CONTEXT_NAME="lab"
USER_NAME="lab-admin"
NAMESPACE="platform"
KUBECONFIG_DIR="$HOME/.kube/clusters"
KUBECONFIG_FILE="$KUBECONFIG_DIR/lab.yaml"
TMP_RAW=$(mktemp)

trap 'rm -f "$TMP_RAW" "$TMP_RAW.clean"' EXIT

read -rsp "Sudo password for ${CONTROL_PLANE}: " SUDO_PASS
echo

echo "Pulling admin.conf from ${CONTROL_PLANE}..."
ssh "$CONTROL_PLANE" "echo '${SUDO_PASS}' | sudo -S cat /etc/kubernetes/admin.conf 2>/dev/null" > "$TMP_RAW"

echo "Remapping kubeconfig entries..."
tr -d '\r' < "$TMP_RAW" | sed \
  -e "s|name: kubernetes-admin@kubernetes|name: ${CONTEXT_NAME}|" \
  -e "s|current-context: kubernetes-admin@kubernetes|current-context: ${CONTEXT_NAME}|" \
  -e "s|user: kubernetes-admin|user: ${USER_NAME}|" \
  -e "s|cluster: kubernetes|cluster: ${CONTEXT_NAME}|" \
  -e "s|name: kubernetes|name: ${CONTEXT_NAME}|" \
> "$TMP_RAW.clean"

kubectl --kubeconfig "$TMP_RAW.clean" config set-context "$CONTEXT_NAME" --namespace="$NAMESPACE" > /dev/null

mkdir -p "$KUBECONFIG_DIR"
mv "$TMP_RAW.clean" "$KUBECONFIG_FILE"

echo "Written to ${KUBECONFIG_FILE}"
echo "Verifying..."
kubectl --kubeconfig "$KUBECONFIG_FILE" get nodes
