#!/usr/bin/env bash

# 设置脚本在执行过程中遇到任何错误时立即退出
set -o errexit
# 设置脚本在使用未定义的变量时立即退出
set -o nounset
# 设置脚本在管道中的任何一个命令失败时立即退出
set -o pipefail

# shellcheck disable=SC2034
BOILERPLATE_FILENAME="hack/boilerplate.go.txt"

HACK_ROOT="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd -P)/hack"
echo "HACK_ROOT is ${HACK_ROOT}"
# generate the code with:
# --output-base    because this script should also be able to run inside the vendor dir of
#                  k8s.io/kubernetes. The output-base is needed for the generators to output into the vendor dir
#                  instead of the $GOPATH directly. For normal projects this can be dropped.
${HACK_ROOT}/generate-groups.sh "applyconfiguration,client,deepcopy,informer,lister" \
	foo-controller/pkg/generated \
	foo-controller/pkg/apis \
	"foo:v1" \
	--go-header-file $(pwd)/boilerplate.go.txt \
	--output-base $(pwd)/../../

# To use your own boilerplate text append:
#   --go-header-file "${SCRIPT_ROOT}"/hack/custom-boilerplate.go.txt
