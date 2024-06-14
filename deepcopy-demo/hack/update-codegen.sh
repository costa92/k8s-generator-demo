#!/usr/bin/env bash

set -o errexit
set -o nounset
set -o pipefail


SCRIPT_DIR="$(dirname "${BASH_SOURCE[0]}")"  # zh: 获取当前脚本的目录
SCRIPT_ROOT="${SCRIPT_DIR}/.." # zh: 获取当前脚本的上级目录


KUBE_ROOT=${GOPATH}/src/github.com/kubernetes/kubernetes
#echo "KUBE_ROOT: ${KUBE_ROOT}"
#API_KNOWN_VIOLATIONS_DIR="${API_KNOWN_VIOLATIONS_DIR:-"${KUBE_ROOT}/api/api-rules"}"


CODEGEN_PKG="${CODEGEN_PKG:-"${SCRIPT_ROOT}"}" # zh: 代码生成器的包路径，默认为当前脚本的上级目录
source "${CODEGEN_PKG}/kube_codegen.sh" # zh: 导入代码生成器脚本

THIS_PKG="github.com/costa92/k8s-generator-demo/deepcopy-demo" # zh: 当前包的路径
# zh: 生成代码
kube::codegen::gen_helpers \
    --boilerplate "${SCRIPT_DIR}/boilerplate.go.txt" \
    "${SCRIPT_ROOT}"


update_report="--update-report"
if [[ -n "${API_KNOWN_VIOLATIONS_DIR:-}" ]]; then
    report_filename="${API_KNOWN_VIOLATIONS_DIR}/codegen_violation_exceptions.list"
    if [[ "${UPDATE_API_KNOWN_VIOLATIONS:-}" == "true" ]]; then
       update_report="--update-report"
    fi
fi


# 判断 generated 目录是否存在，不存在则创建，存在删除其中的文件
if [ ! -d "${SCRIPT_ROOT}/pkg/generated" ]; then
    mkdir -p "${SCRIPT_ROOT}/pkg/generated"
else
    rm -rf "${SCRIPT_ROOT}/pkg/generated"
    mkdir -p "${SCRIPT_ROOT}/pkg/generated"
fi


# https://github.com/kubernetes/code-generator/blob/master/examples/hack/update-codegen.sh

# zh: 生成openapi代码
kube::codegen::gen_openapi \
    --output-dir "${SCRIPT_ROOT}/pkg/generated/openapi" \
    --output-pkg "${THIS_PKG}/pkg/generated/openapi" \
    --report-filename "${report_filename:-"/dev/null"}" \
    ${update_report:+"${update_report}"} \
    --boilerplate "${SCRIPT_DIR}/boilerplate.go.txt" \
    "${SCRIPT_ROOT}/pkg/apis"


kube::codegen::gen_client \
    --with-watch \
    --output-dir "${SCRIPT_ROOT}/pkg/generated" \
    --output-pkg "${THIS_PKG}/pkg/generated" \
    --boilerplate "${SCRIPT_DIR}/boilerplate.go.txt" \
    "${SCRIPT_ROOT}/pkg"
