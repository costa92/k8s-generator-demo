#!/usr/bin/env bash

# #表示有报错即退出 跟set -e含义一样
set -o errexit
# #执行脚本的时候，如果遇到不存在的变量，Bash 默认忽略它 ,跟 set -u含义一样
set -o nounset
# 只要一个子命令失败，整个管道命令就失败，脚本就会终止执行 
set -o pipefail
# SCRIPT_ROOT is the root of the k8s.io/code-generator repo.
SCRIPT_ROOT="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd -P)"
# DIFFROOT 项目的根目录
DIFFROOT="${SCRIPT_ROOT}"
TMP_DIFFROOT="$(mktemp -d -t "$(basename "$0").XXXXXX")"
cleanup() {
  rm -rf "${TMP_DIFFROOT}"
}
# 退出时执行cleanup
trap "cleanup" EXIT SIGINT
#  cleanup 用于清理临时目录
cleanup

mkdir -p "${TMP_DIFFROOT}"
#  将DIFFROOT目录下的文件复制到TMP_DIFFROOT目录下
cp -a "${DIFFROOT}"/* "${TMP_DIFFROOT}"
