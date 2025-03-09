#!/usr/bin/env bash

set -o errexit
set -o nounset
set -o pipefail

SCRIPT_DIR="$(dirname "${BASH_SOURCE[0]}")"
SCRIPT_ROOT="${SCRIPT_DIR}/.."
CODEGEN_PKG="${CODEGEN_PKG:-"${SCRIPT_ROOT}"}"
BOILERPLATE="${SCRIPT_ROOT}/hack/boilerplate.go.txt"

source "${CODEGEN_PKG}/hack/kube_codegen.sh"

THIS_PKG="github.com/costa92/k8s-generator-demo/code-generator-demo"

# 生成客户端、informers、listers 等代码
kube::codegen::gen_client \
    --with-watch \
    --output-dir "${SCRIPT_ROOT}/pkg/generated" \
    --output-pkg "${THIS_PKG}/pkg/generated" \
    --boilerplate "${BOILERPLATE}" \
    "${SCRIPT_ROOT}/pkg/apis"


# 生成深拷贝函数
kube::codegen::gen_helpers \
    --boilerplate "${BOILERPLATE}" \
    "${SCRIPT_ROOT}/pkg/apis"

# 生成 OpenAPI 规范
kube::codegen::gen_openapi \
    --output-dir "${SCRIPT_ROOT}/pkg/generated/openapi" \
    --output-pkg "${THIS_PKG}/pkg/generated/openapi" \
    --report-filename "${report_filename:-"/dev/null"}" \
    ${update_report:+"${update_report}"} \
    --boilerplate "${BOILERPLATE}" \
    "${SCRIPT_ROOT}/pkg/apis"