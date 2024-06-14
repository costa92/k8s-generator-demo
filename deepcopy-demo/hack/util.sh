#!/usr/bin/env bash

# 获取当前脚本的绝对路径
function realpath() {
  OURPWD=$PWD
  # shellcheck disable=SC2164
  cd "$(dirname "$1")"
  LINK=$(readlink "$(basename "$1")")
  while [ "$LINK" ]; do
    # shellcheck disable=SC2164
    cd "$(dirname "$LINK")"
    LINK=$(readlink "$(basename "$1")")
  done
  REALPATH="$PWD/$(basename "$1")"
  # shellcheck disable=SC2164
  cd "$OURPWD"
  echo "$REALPATH"
}