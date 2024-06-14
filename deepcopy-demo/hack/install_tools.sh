#!/usr/bin/env bash

set -o errexit
set -o nounset
set -o pipefail

INSTALL_ROOT_TEP="$(realpath "$(dirname "${BASH_SOURCE[0]}")/../tmp")"
echo "INSTALL_ROOT_TEP: ${INSTALL_ROOT_TEP}"


# 安装 controller-tools 工具  controller-gen type-scaffold
install::controller-tools() {
    mkdir -p "${INSTALL_ROOT_TEP}"
    [ -d "${INSTALL_ROOT_TEP}/controller-tools" ] || git clone https://github.com/kubernetes-sigs/controller-tools.git "${INSTALL_ROOT_TEP}/controller-tools"
    cd "${INSTALL_ROOT_TEP}/controller-tools"  &&  go mod tidy &&  go install ./cmd/{controller-gen,type-scaffold}
}

# 删除 tmp 目录
cleanup() {
  rm -rf "${INSTALL_ROOT_TEP}"
}

trap 'echo del INSTALL_ROOT_TEP ${INSTALL_ROOT_TEP} && cleanup' EXIT SIGINT


if [[ "$*" =~ install:: ]]; then
	# shellcheck disable=SC2048
	eval "$*"
fi