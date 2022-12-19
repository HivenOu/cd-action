#!/bin/sh

set -e

version="$1"
command="$2"
binaries_url="$3"

if [ "${KCONFIG}" == "" ]; then
  echo "KUBECONFIG Data is null"
  exit 1
fi

if [ -z "$binaries_url" ]; then
  if [ "$version" = "latest" ]; then
    version=$(curl -Ls https://dl.k8s.io/release/stable.txt)
  fi

  echo "using kubectl@$version"

  curl -sLO "https://dl.k8s.io/release/$version/bin/linux/amd64/kubectl" -o kubectl
else
  echo "downloading kubectl binaries from $binaries_url"
  curl -sLO $binaries_url -o kubectl
fi

chmod +x kubectl
#mv kubectl /usr/local/bin

# Extract the base64 encoded config data and write this to the KUBECONFIG
echo "${KCONFIG}" | base64 -d > /tmp/config
export KUBECONFIG=/tmp/config

sh -c "./kubectl $command"
