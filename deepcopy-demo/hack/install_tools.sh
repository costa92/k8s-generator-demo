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

# echo kubebuilder | tr a-z A-Z # KUBEBUILDER :zh 将小写转换为大写
# shellcheck disable=SC2034
KUBEBUILDER_VERSION="2.3.1"
# 安装 kubebuilder 工具
install::kubebuilder() {
   mkdir -p "${INSTALL_ROOT_TEP}"
  # go env GOOS -- 获取操作系统类型，例如：linux等
  # go env GOARCH -- 获取系统架构，例如：arm或amd64等
  # go env GOROOT -- 获取go的安装路径
  # shellcheck disable=SC2046
  curl -L -o "${INSTALL_ROOT_TEP}"/kubebuilder  https://go.kubebuilder.io/dl/latest/$(go env GOOS)/$(go env GOARCH)
  # shellcheck disable=SC2046
  sudo mv "${INSTALL_ROOT_TEP}"/kubebuilder /usr/local/bin/kubebuilder  &&  sudo chmod +x /usr/local/bin/kubebuilder
}

# 删除 tmp 目录
cleanup() {
  if [ -d "${INSTALL_ROOT_TEP}" ]; then
    rm -rf "${INSTALL_ROOT_TEP}"
  fi
}

trap 'echo del INSTALL_ROOT_TEP ${INSTALL_ROOT_TEP} && cleanup' EXIT SIGINT


if [[ "$*" =~ install:: ]]; then
	# shellcheck disable=SC2048
	eval "$*"
fi


