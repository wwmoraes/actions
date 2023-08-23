#!/bin/bash

set -Eeuo pipefail

: "${GOLANG_COVERAGE_PACKAGES:=}"
: "${GOLANG_COVERPROFILE:=coverage.out}"
: "${GOLANG_PACKAGES:=./...}"
: "${GOLANG_REPORTFILE:=test-report.json}"
: "${GOLANG_RUN_FLAGS:=-race}"
: "${GOCOVERDIR:=coverage}"
export GOCOVERDIR

GOLANG_COVERAGE_PACKAGES=$(echo -n -e "${GOLANG_COVERAGE_PACKAGES}" | tr '\n' ',')

echo "cover-profile=${GOLANG_COVERPROFILE}" >> "${GITHUB_OUTPUT}"
echo "report-file=${GOLANG_REPORTFILE}" >> "${GITHUB_OUTPUT}"

mkdir -p "${GOCOVERDIR}"

echo "================================================================================"
echo "running instrumented code"
# we run once out directly to get any error messages printed
go run -cover ${GOLANG_RUN_FLAGS} ${GOLANG_PACKAGES} &
go tool test2json go run -cover ${GOLANG_RUN_FLAGS} ${GOLANG_PACKAGES} > "${GOLANG_REPORTFILE}" &
wait
echo "================================================================================"
echo "converting coverage data"
go tool covdata textfmt -i="${GOCOVERDIR}" -o "${GOLANG_COVERPROFILE}" -pkg="${GOLANG_COVERAGE_PACKAGES}"

echo "generating coverage report"
echo "================================================================================"
go tool cover -func="${GOLANG_COVERPROFILE}"
