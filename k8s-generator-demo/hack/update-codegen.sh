#!/usr/bin/env bash
#  当命令返回一个非零退出状态（失败）时退出。读取初始化文件时不设置
set -eufo pipefail

# shellcheck disable=SC2034
PROJECT_ROOT=$(dirname "${BASH_SOURCE[0]}")/..

# SCRIPT_ROOT is the root of the k8s.io/code-generator repo.
# shellcheck disable=SC2034
SCRIPT_ROOT="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd -P)/scripts"

source "${SCRIPT_ROOT}/lib/util.sh"
source "${SCRIPT_ROOT}/lib/logging.sh"

# out_dir is the output directory for generated code.
# shellcheck disable=SC2034
OUT_DIR="_output"
# PRJ_SRC_PATH is the path to the project source code.
# shellcheck disable=SC2034
PRJ_SRC_PATH="k8s.io/kubernetes"
# BOILERPLATE_FILENAME is the name of the boilerplate file.
# shellcheck disable=SC2034
BOILERPLATE_FILENAME="hack/boilerplate.go.txt"

# 判断 env.local 文件是否存在
ENV_FILE=$(pwd)/hack/env.local
if [ ! -f "${ENV_FILE}" ]; then
  echo "local.env file not found:envFile=${ENV_FILE} "
  exit 1
fi

# 读取 local.env 文件
# shellcheck disable=SC1090
source "${ENV_FILE}"

DBG_CODEGEN="${DBG_CODEGEN:-0}"
GENERATED_FILE_PREFIX="${GENERATED_FILE_PREFIX:-zz_generated.}"
UPDATE_API_KNOWN_VIOLATIONS="${UPDATE_API_KNOWN_VIOLATIONS:-}"
API_KNOWN_VIOLATIONS_DIR="${API_KNOWN_VIOLATIONS_DIR:-"${PROJECT_ROOT}/api/api-rules"}"



PROJECT_PACKAGE="${PROJECT_PACKAGE:-""}"
CLIENT_GENERATOR_OUT="${CLIENT_GENERATOR_OUT:-""}"
APIS_ROOT="${APIS_ROOT:-""}"

[ -z "$PROJECT_PACKAGE" ] && echo "PROJECT_PACKAGE env var is required" && exit 1
[ -z "$APIS_ROOT" ] && echo "APIS_ROOT env var is required" && exit 1
echo "Generating client at ${APIS_ROOT}"
# GENERATION_TARGETS=helpers,client
GENERATION_TARGETS="${GENERATION_TARGETS:-helpers,client}"

#kube::codegen::gen_helpers \
#    --boilerplate "${SCRIPT_ROOT}/hack/boilerplate.go.txt" \
#    "${SCRIPT_ROOT}"


# Any time we call sort, we want it in the same locale.
export LC_ALL="C"

# Work around for older grep tools which might have options we don't want.
unset GREP_OPTIONS

if [[ "${DBG_CODEGEN}" == 1 ]]; then
    echo "DBG: starting generated_files"
fi

function git_find() {
    # Similar to find but faster and easier to understand.  We want to include
    # modified and untracked files because this might be running against code
    # which is not tracked by git yet.
    git ls-files -cmo --exclude-standard ':!:manifests/*' ':!:third_party/*' ':!:vendor/*' "$@"
}

# protobuf generation
#
# Some of the later codegens depend on the results of this, so it needs to come
# first in the case of regenerating everything.
function codegen::protobuf() {
  # shellcheck disable=SC2034
  local apis=()

  project::util::read-array apis < <(
      git grep --untracked --null -l \
          -e '// +k8s:protobuf-gen=package' \
          -- \
          pkg \
          | xargs -0 -n1 dirname \
          | sed 's|^|github.com/costa92/k8s-generator-demo/|;s|k8s.io/kubernetes/staging/src/||' \
          | sort -u)

  project::log::status "Generating protobufs for ${#apis[@]} targets"

  if [[ "${DBG_CODEGEN}" == 1 ]]; then
      project::log::status "DBG: generating protobufs for:"
      for dir in "${apis[@]}"; do
          project::log::status "DBG:     $dir"
      done
  fi

  git_find -z \
          ':(glob)**/generated.proto' \
          ':(glob)**/generated.pb.go' \
          | xargs -0 rm -f

  "${PROJECT_ROOT}"/hack/update-generated-protobuf-dockerized.sh "${apis[@]}"
}

codegen::protobuf
