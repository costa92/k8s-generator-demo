#!/usr/bin/env bash

# 设置脚本在执行过程中遇到任何错误时立即退出
set -o errexit
# 设置脚本在使用未定义的变量时立即退出
set -o nounset
# 设置脚本在管道中的任何一个命令失败时立即退出
set -o pipefail

# shellcheck disable=SC2034
BOILERPLATE_FILENAME="hack/boilerplate.go.txt"

# shellcheck disable=SC2034
PROJECT_ROOT="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd -P)"

HACK_ROOT="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd -P)/hack"
echo "HACK_ROOT is ${HACK_ROOT}"


# corresponding to go mod init <module>
# shellcheck disable=SC2034
MODULE=pkg
# api package
# shellcheck disable=SC2034
APIS_PKG=apis
# generated output package
# shellcheck disable=SC2034
OUTPUT_PKG=generated
# group-version such as foo:v1alpha1
GROUP_VERSION=foo:v1


# generate the code with:
# --output-base    because this script should also be able to run inside the vendor dir of
#                  k8s.io/kubernetes. The output-base is needed for the generators to output into the vendor dir
#                  instead of the $GOPATH directly. For normal projects this can be dropped.
bash "${HACK_ROOT}"/generate-groups.sh "all" \
  ${MODULE}/${OUTPUT_PKG} ${MODULE}/${APIS_PKG} \
  ${GROUP_VERSION} \
	--go-header-file "${HACK_ROOT}"/boilerplate.go.txt \
	--output-base "${PROJECT_ROOT}" \
	--input-dirs "${PROJECT_ROOT}"/pkg/apis

echo ${PROJECT_ROOT}
# To use your own boilerplate text append:
#   --go-header-file "${SCRIPT_ROOT}"/hack/custom-boilerplate.go.txt
