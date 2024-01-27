#!/usr/bin/env bats

load "${PACKAGES}/bats-support/load.bash"
load "${PACKAGES}/bats-assert/load.bash"
load "${PACKAGES}/bats-mock/stub.bash"

SCRIPT=$(basename -s .bats "${BATS_TEST_FILENAME}").bash

GOCACHE=/root/.cache/go-build
GOMODCACHE=/go/pkg/mod

function setup() {
  export GITHUB_OUTPUT=$(mktemp)
  stub go \
    "env GOCACHE : echo '${GOCACHE}'" \
    "env GOMODCACHE : echo '${GOMODCACHE}'"
}

function teardown() {
  unstub go
  rm "${GITHUB_OUTPUT}"
  unset GITHUB_OUTPUT
}

@test "golang env set successfully" {
  run "${BATS_TEST_DIRNAME}/${SCRIPT}"
  [ "$status" -eq 0 ]
}

@test "golang env set GOCACHE successfully" {
  WANT="GOCACHE=${GOCACHE}"

  run "${BATS_TEST_DIRNAME}/${SCRIPT}"
  assert_line "${WANT}"

  run cat "${GITHUB_OUTPUT}"
  assert_line "${WANT}"
}

@test "golang env set GOMODCACHE successfully" {
  WANT="GOMODCACHE=${GOMODCACHE}"

  run "${BATS_TEST_DIRNAME}/${SCRIPT}"
  assert_line "${WANT}"

  run cat "${GITHUB_OUTPUT}"
  assert_line "${WANT}"
}
