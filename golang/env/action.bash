#!/bin/bash

set -Eeuo pipefail

declare GITHUB_ENV

echo "GOCACHE=$(go env GOCACHE)" >> "${GITHUB_ENV}"
echo "GOMODCACHE=$(go env GOMODCACHE)" >> "${GITHUB_ENV}"

export GITHUB_ENV
