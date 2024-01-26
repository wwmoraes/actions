#!/bin/bash

set -Eeuo pipefail

declare GITHUB_OUTPUT

echo "GOCACHE=$(go env GOCACHE)" >> "${GITHUB_OUTPUT}"
echo "GOMODCACHE=$(go env GOMODCACHE)" >> "${GITHUB_OUTPUT}"

export GITHUB_OUTPUT
