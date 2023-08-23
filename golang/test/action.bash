#!/bin/bash

set -Eeuo pipefail

: "${GOLANG_TEST_FLAGS:=}"
: "${GOLANG_COVERPROFILE:=coverage.out}"
: "${GOLANG_PACKAGES:=./...}"
: "${GOLANG_REPORTFILE:=test-report.json}"

: "${GOLANG_FLAGS:=-race -mod=vendor}"

echo "cover-profile=${GOLANG_COVERPROFILE}" >> "${GITHUB_OUTPUT}"
echo "report-file=${GOLANG_REPORTFILE}" >> "${GITHUB_OUTPUT}"

# shellcheck disable=SC2086
go test ${GOLANG_FLAGS} ${GOLANG_TEST_FLAGS} \
  -cover -coverprofile="${GOLANG_COVERPROFILE}" \
  -json ${GOLANG_PACKAGES} > "${GOLANG_REPORTFILE}"
