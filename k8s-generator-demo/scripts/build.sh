#!/usr/bin/env bash

set -o errexit
set +o nounset
set -o pipefail

# shellcheck disable=SC2112
# shellcheck disable=SC2039
function project::build::test() {
    echo 11
}

project::build::test