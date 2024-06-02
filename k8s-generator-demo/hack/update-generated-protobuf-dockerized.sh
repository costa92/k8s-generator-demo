#!/usr/bin/env bash

set -o errexit
set -o nounset
set -o pipefail

PROJECT_ROOT=$(cd "$(dirname "${BASH_SOURCE[0]}")"/.. && pwd -P)
if [ -f "${PROJECT_ROOT}/scripts/lib/init.sh" ]; then
  source "${PROJECT_ROOT}/scripts/lib/init.sh"
fi

echo "Generating protobuf code... PROJECT_ROOT is ${PROJECT_ROOT}"
# shellcheck disable=SC2034
GO111MODULE=on GOPROXY=off go install k8s.io/code-generator/cmd/go-to-protobuf
# shellcheck disable=SC2034
GO111MODULE=on GOPROXY=off go install k8s.io/code-generator/cmd/go-to-protobuf/protoc-gen-gogo


gotoprotobuf=go-to-protobuf

# boilerplate.go.txt 其实就是为每个生成的代码文件头部添加上下面的开源协议声明：
# requires the 'proto' tag to build (will remove when ready)
# searches for the protoc-gen-gogo extension in the output directory
# satisfies import of github.com/gogo/protobuf/gogoproto/gogo.proto and the
# core Google protobuf types
PATH="${PROJECT_ROOT}/_output/bin:${PATH}" \
  "${gotoprotobuf}" \
  --proto-import="${PROJECT_ROOT}/third_party" \
  --packages="$(IFS=, ; echo "$*")" \
  --go-header-file "${PROJECT_ROOT}/hack/boilerplate.go.txt"

