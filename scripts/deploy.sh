#!/usr/bin/env bash

source scripts/env.sh

log() {
  (2>/dev/null echo -e "$@")
}

info()   { log "--- $@"; }
error()  { log "[error] $@"; }
failed() { log "[failed] $@"; exit 1; }

info "kube api url: ${KUBE_SERVER}"
info "namespace: ${KUBE_NAMESPACE}"

info "downloading ca for kube api"
if ! curl --silent --fail --retry 5 \
    https://raw.githubusercontent.com/UKHomeOffice/acp-ca/master/${DRONE_DEPLOY_TO}.crt -o /tmp/ca.crt; then
  failed "downloading ca for kube api"
  exit 1
fi

info "deploying to environment"
kd --certificate-authority=/tmp/ca.crt \
   --check-interval=5s \
   --timeout=5m \
   --namespace=${KUBE_NAMESPACE} \
   -f kube/deployment.yml \
   -f kube/service.yml \
   -f kube/ingress.yml
if [[ $? -ne 0 ]]; then
  failed "rollout of deployment"
  exit 1
fi

exit $?
