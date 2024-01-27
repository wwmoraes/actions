#!/bin/bash

set -Eeuo pipefail

declare GITHUB_OUTPUT

echo "GOCACHE=$(go env GOCACHE)" | tee -a "${GITHUB_OUTPUT}"
echo "GOMODCACHE=$(go env GOMODCACHE)" | tee -a "${GITHUB_OUTPUT}"

export GITHUB_OUTPUT
