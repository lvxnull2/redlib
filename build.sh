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

$docker build -t "${REGISTRY}/redlib:${1:-latest}" .
