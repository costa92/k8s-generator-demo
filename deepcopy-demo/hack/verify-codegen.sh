#!/usr/bin/env bash

set -o errexit
set -o nounset
set -o pipefail

# This script verifies that the codegen output is up to date.
SCRIPT_ROOT="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd -P)"
echo "SCRIPT_ROOT: ${SCRIPT_ROOT}"

# Ensure we're in the repo root
DIFFROOT="${SCRIPT_ROOT}"

# Create a temporary directory to copy the generated code into  so we can diff it
# zh: 创建一个临时目录，将生成的代码复制到其中，以便我们可以对其进行比较
TMP_DIFFROOT="$(mktemp -d -t "$(basename "$0").XXXXXX")"

cleanup() {
  rm -rf "${TMP_DIFFROOT}"
}
# Clean up the temp directory  trap use doc https://www.junmajinlong.com/shell/script_course/shell_trap/
# zh: 清理临时目录
trap 'echo del TMP_DIFFROOT ${TMP_DIFFROOT} && cleanup' EXIT SIGINT

cleanup

# Copy the generated code into the temp directory
mkdir -p "${TMP_DIFFROOT}"
cp -a "${DIFFROOT}"/* "${TMP_DIFFROOT}"

# Generate the code
"${SCRIPT_ROOT}/hack/update-codegen.sh"
echo "diffing ${DIFFROOT} against freshly generated codegen"


ret=0
diff -Naupr "${DIFFROOT}" "${TMP_DIFFROOT}" || ret=$?
if [[ $ret -eq 0 ]]; then
  echo "${DIFFROOT} up to date."
else
  echo "${DIFFROOT} is out of date. Please run hack/update-codegen.sh"
  exit 1
fi

## smoke test
echo "Smoke testing examples by compiling..."
pushd "${SCRIPT_ROOT}"
  go build "k8s.io/code-generator/examples/crd/..."
popd