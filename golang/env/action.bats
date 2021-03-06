#!/usr/bin/env bats

load "${PACKAGES}/bats-support/load.bash"
load "${PACKAGES}/bats-assert/load.bash"
load "${PACKAGES}/bats-mock/stub.bash"

SCRIPT=$(basename -s .bats "${BATS_TEST_FILENAME}").bash

GOCACHE=/root/.cache/go-build
GOMODCACHE=/go/pkg/mod

function setup() {
  export GITHUB_ENV=$(mktemp)
  stub go \
    "env GOCACHE : echo '${GOCACHE}'" \
    "env GOMODCACHE : echo '${GOMODCACHE}'"
}

function teardown() {
  unstub go
  rm "${GITHUB_ENV}"
  unset GITHUB_ENV
}

@test "golang env set successfully" {
  run "${BATS_TEST_DIRNAME}/${SCRIPT}"
  [ "$status" -eq 0 ]
  [ "$output" = "" ]
}

@test "golang env set GOCACHE successfully" {
  WANT="GOCACHE=${GOCACHE}"

  run "${BATS_TEST_DIRNAME}/${SCRIPT}"
  run cat "${GITHUB_ENV}"
  assert_line "${WANT}"
}

@test "golang env set GOMODCACHE successfully" {
  WANT="GOMODCACHE=${GOMODCACHE}"

  run "${BATS_TEST_DIRNAME}/${SCRIPT}"
  run cat "${GITHUB_ENV}"
  assert_line "${WANT}"
}
