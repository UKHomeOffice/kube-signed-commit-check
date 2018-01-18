#!/usr/bin/env bash -e

export DRONE_DEPLOY_TO=${DRONE_DEPLOY_TO:-acp-ops}
export KUBE_NAMESPACE="signed-commit-check"
export VERSION="v1.0.0"

case "${DRONE_DEPLOY_TO}" in
  acp-ops)
    export DNS_ZONE="acp.homeoffice.gov.uk"
    export KUBE_SERVER="${KUBE_SERVER_ACP_OPS}"
    export KUBE_TOKEN="${KUBE_TOKEN_ACP_OPS}"
    ;;
  *)
    echo "The environment: ${DRONE_DEPLOY_TO} does is not configured"
    exit 1
    ;;
esac
