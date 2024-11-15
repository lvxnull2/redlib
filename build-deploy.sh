#!/bin/sh

set -eu

if hash podman 2>/dev/null; then
  docker=podman
elif hash docker 2>/dev/null; then
  docker=docker
else
  echo "ERROR: Either podman or docker required."
  exit 1
fi

if [ -r .env ]; then
  set -a
  . "./.env"
  set +a
fi

full_tag="${REGISTRY}/redlib:${1:-latest}"
$docker build -t "${full_tag}" .
$docker push "${full_tag}"
