#!/usr/bin/env bash
#  当命令返回一个非零退出状态（失败）时退出。读取初始化文件时不设置
set -o errexit  
# 读取初始化文件时不设置
set -o nounset 
# 管道命令失败时，不继续执行
set -o pipefail
#  判断是否已经安装protoc
if command -v protoc >/dev/null 2>&1; then
    echo "protoc is already installed on this system. protoc version: $(protoc --version)"
    exit 0
fi
# 用于指定protoc的版本
PROTOC_VERSION=3.19.4
# 用于指定protoc-gen-go的版本
SCRIPT_ROOT=$(dirname "${BASH_SOURCE[0]}")
# 获取当前系统的操作系统
OS=$(uname -s)
# 获取当前系统的架构
ARCH=$(uname -ms)
# 用于指定下载地址
download_folder="protoc-v${PROTOC_VERSION}-${OS}-${ARCH}"
echo "download_folder: ${download_folder}"
download_file="${download_folder}.zip"
# 用于指定下载地址
cd "${SCRIPT_ROOT}" || return 1

# 安装protoc
function install_protoc() {
    # 下载protoc
    if [[ $(readlink protoc) != "${download_folder}" ]]; then
        url=""
        if [[ ${OS} == "darwin" ]]; then  # MacOS
            url="https://github.com/protocolbuffers/protobuf/releases/download/v${PROTOC_VERSION}/protoc-${PROTOC_VERSION}-osx-x86_64.zip"
        elif [[ ${OS} == "linux" && ${ARCH} == "amd64" ]]; then  # Linux
            url="https://github.com/protocolbuffers/protobuf/releases/download/v${PROTOC_VERSION}/protoc-${PROTOC_VERSION}-linux-x86_64.zip"
        elif [[ ${OS} == "linux" && ${ARCH} == "arm64" ]]; then   # ARM64
            url="https://github.com/protocolbuffers/protobuf/releases/download/v${PROTOC_VERSION}/protoc-${PROTOC_VERSION}-linux-aarch_64.zip"
        else
            echo "This install script does not support ${OS}/${ARCH}" 1>&2
        fi
        # 下载protoc
        if [[ -n "${url}" ]]; then
            echo "Downloading protoc from ${url}"
            curl -fsSL --retry 3 --keepalive-time 2 "${url}" -o "${download_file}"
            unzip -o "${download_file}" -d "${download_folder}"
            ln -fns "${download_folder}" protoc
            mv protoc/bin/protoc protoc/protoc
            chmod -R +rX protoc/protoc
            rm -fr protoc/include
            rm "${download_file}"
        fi
    fi
}

install_protoc