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

$docker build --build-arg=GIT_HASH="$(git rev-parse HEAD)" "$@" .
