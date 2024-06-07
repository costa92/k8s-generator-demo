#!/usr/bin/env bash

set -o errexit
set -o nounset
set -o pipefail

OUTPUT_PKG=generated
MODULE=foo

#SCRIPT_ROOT= "$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd -P)/hack"

SCRIPT_ROOT="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd -P)"

echo "SCRIPT_ROOT is ${SCRIPT_ROOT}"

DIFFROOT="${SCRIPT_ROOT}/pkg/${OUTPUT_PKG}"
TMP_DIFFROOT="${SCRIPT_ROOT}/_tmp/${OUTPUT_PKG}"
_tmp="${SCRIPT_ROOT}/_tmp"

cleanup() {
	rm -rf "${_tmp}"
}
trap "cleanup" EXIT SIGINT

cleanup

mkdir -p "${TMP_DIFFROOT}"
if [ -d "${DIFFROOT}" ]; then
	cp -a "${DIFFROOT}"/* "${TMP_DIFFROOT}"
fi

"${SCRIPT_ROOT}/hack/update-codegen.sh"
echo "copying generated ${SCRIPT_ROOT}/${MODULE}/${OUTPUT_PKG} to ${DIFFROOT}"
cp -r "${SCRIPT_ROOT}/${MODULE}/${OUTPUT_PKG}"/* "${DIFFROOT}"

echo "diffing ${DIFFROOT} against freshly generated codegen"
ret=0
diff -Naupr "${DIFFROOT}" "${TMP_DIFFROOT}" || ret=$?
cp -a "${TMP_DIFFROOT}"/* "${DIFFROOT}"
if [[ $ret -eq 0 ]]; then
	echo "${DIFFROOT} up to date."
else
	echo "${DIFFROOT} is out of date. Please run hack/update-codegen.sh"
	exit 1
fi