#!/usr/bin/env bash

set -o errexit
set -o nounset
set -o pipefail

# zh: 获取项目脚本的目录
PROJECT_ROOT="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd -P)"
# shellcheck disable=SC2034
CRD_ROOT="${PROJECT_ROOT}/manifests/crd"

# zh: 判断 CRD_ROOT 目录是否存在，不存在则创建
if [ ! -d "${CRD_ROOT}" ]; then
    mkdir -p "${CRD_ROOT}"
fi


# zh: 生成 CRD
controller-gen paths="${PROJECT_ROOT}/pkg/apis/..." \
    rbac:roleName=manager-role crd webhook \
    output:crd:artifacts:config="${CRD_ROOT}"  # 生成的 CRD 文件存放在 manifests/crd 目录下