#!/bin/bash

set -Eeuo pipefail

: "${GOLANG_BUILD_FLAGS:=}"
: "${GOLANG_OUTPUT_DIR:=.}"
: "${GOLANG_OUTPUT_BIN:=}"
: "${GOLANG_PACKAGES:=./...}"

: "${GOLANG_FLAGS:=-race -mod=vendor}"

mkdir -p "${GOLANG_OUTPUT_DIR}"

# shellcheck disable=SC2086
go build ${GOLANG_FLAGS} ${GOLANG_BUILD_FLAGS} \
  -o "${GOLANG_OUTPUT_DIR}/${GOLANG_OUTPUT_BIN}" \
  ${GOLANG_PACKAGES}
