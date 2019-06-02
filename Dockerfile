FROM google/cloud-sdk:alpine

ENV HELM_VERSION v2.14.0
ENV SOPS_VERSION 3.3.0
ENV HELM_GCS_VERSION 0.2.0
ENV HELM_HOME /home/jenkins/

WORKDIR /tmp

RUN apk --no-cache update && \
    apk add --update -t deps curl tar gzip bash python && \
    curl -L http://storage.googleapis.com/kubernetes-helm/helm-${HELM_VERSION}-linux-amd64.tar.gz | tar zxv -C /tmp && \
    curl -L -o /usr/local/bin/sops https://github.com/mozilla/sops/releases/download/"${SOPS_VERSION}"/sops-"${SOPS_VERSION}".linux && \
    mv /tmp/linux-amd64/helm /usr/local/bin/helm && \
    chmod +x /usr/local/bin/helm && \
    chmod +x /usr/local/bin/sops && \
    rm -rf /var/cache/apk/* && \
    rm -rf /tmp/linux-amd64 && \
    helm init --client-only && \
    helm plugin install https://github.com/hayorov/helm-gcs.git --version $HELM_GCS_VERSION && \
    helm plugin install https://github.com/databus23/helm-diff.git && \
    helm plugin install https://github.com/futuresimple/helm-secrets.git && \
    helm version --client && \
    helm plugin list && \
    gcloud info

WORKDIR /home/jenkins/
