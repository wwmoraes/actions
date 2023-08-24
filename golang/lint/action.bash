#!/bin/bash

set -Eeuo pipefail

declare GITHUB_WORKSPACE

: "${VERSION:?no docker image version provided}"
: "${OUTPUT_FORMAT:?no output format provided}"
: "${OUTPUT_FILE:?no output file provided}"
: "${WORK_DIR:?no work dir provided}"

: "${GOMODCACHE:=$(go env GOMODCACHE)}"
: "${GOCACHE:=$(go env GOCACHE)}"
: "${CACHE_DIR:=${HOME}/.cache/golangci-lint}"

# CACHE_DIR=$(golangci-lint cache status | awk '$1 == "Dir:" {print $2}')

mkdir -p "${GOMODCACHE}";
mkdir -p "${GOCACHE}";
mkdir -p "${CACHE_DIR}";

echo "report-file=${OUTPUT_FILE}" >> "${GITHUB_OUTPUT}"

docker run --rm -a STDOUT -a STDERR \
  --mount "type=bind,source=${GOMODCACHE},target=/go/pkg/mod,consistency=cached" \
  --mount "type=bind,source=${GOCACHE},target=/root/.cache/go-build,consistency=cached" \
  --mount "type=bind,source=${CACHE_DIR},target=/root/.cache/golangci-lint,consistency=cached" \
  --mount "type=bind,source=${GITHUB_WORKSPACE},target=${WORK_DIR},consistency=cached" \
  -w "${WORK_DIR}" \
  "golangci/golangci-lint:${VERSION}" \
  golangci-lint run -v --out-format "${OUTPUT_FORMAT}" > "${OUTPUT_FILE}"
