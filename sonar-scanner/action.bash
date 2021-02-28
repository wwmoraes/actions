#!/bin/bash

set -Eeuo pipefail

declare GITHUB_WORKSPACE

: "${SONAR_TOKEN:?please set the sonar token to login with}"
: "${LOCAL_SONAR_USER_HOME:?local sonar user home must be set}"

: "${UID:=$(id -u)}"
: "${GID:=$(id -g)}"
: "${SONAR_USER_HOME:=/opt/sonar-scanner/.sonar}"
: "${WORK_DIR:=/usr/src}"
: "${VERSION:=4}"

mkdir -p "${LOCAL_SONAR_USER_HOME}"

echo "::set-output name=cache-path::${LOCAL_SONAR_USER_HOME}/cache"

docker run --rm -a STDOUT -a STDERR \
  --user "${UID}:${GID}" \
  -e SONAR_USER_HOME="${SONAR_USER_HOME}" \
  --mount "type=bind,source=${LOCAL_SONAR_USER_HOME},target=${SONAR_USER_HOME},consistency=cached" \
  --mount "type=bind,source=${GITHUB_WORKSPACE},target=${WORK_DIR},consistency=cached" \
  -w "${WORK_DIR}" \
  "sonarsource/sonar-scanner-cli:${VERSION}" \
  -Dsonar.login="${SONAR_TOKEN}"
