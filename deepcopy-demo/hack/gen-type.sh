#!/usr/bin/env bash

set -o errexit
set -o nounset
set -o pipefail

# zh: 获取项目脚本的目录
PROJECT_ROOT="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd -P)"
# shellcheck disable=SC2034

# 执行 type-scaffold 命令生成代码 到 pkg/apis/ 目录下

if [ ! -d "${PROJECT_ROOT}/pkg/apis/v1" ]; then
    mkdir -p "${PROJECT_ROOT}/pkg/apis/v1"
fi

# 判断是否存在 types.go 文件，不存在则创建
if [ ! -f "${PROJECT_ROOT}/pkg/apis/v1/types.go" ]; then
   type-scaffold --kind=NodeCache --namespaced=true >> "${PROJECT_ROOT}/pkg/apis/v1/types.go"
fi

