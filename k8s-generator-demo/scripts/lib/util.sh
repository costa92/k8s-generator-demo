#!/usr/bin/env bash

# Copyright 2023 The Kubernetes Authors.
#
# Licensed under the Apache License, Version 2.0 (the "License");
# you may not use this file except in compliance with the License.
# You may obtain a copy of the License at
#
#     http://www.apache.org/licenses/LICENSE-2.0
#
# Unless required by applicable law or agreed to in writing, software
# distributed under the License is distributed on an "AS IS" BASIS,
# WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
# See the License for the specific language governing permissions and
# limitations under the License.

# This script is convenience to download and install protoc in third_party.
# Usage: `hack/install-protoc.sh`.


# project::util::read-array
# Reads in stdin and adds it line by line to the array provided. This can be
# used instead of "mapfile -t", and is bash 3 compatible.  If the named array
# exists and is an array, it will be used.  Otherwise it will be unset and
# recreated.
#
# Assumed vars:
#   $1 (name of array to create/modify)
#
# Example usage:
#   project::util::read-array files < <(ls -1)
#
# When in doubt:
#  $ W=abc         # a string
#  $ X=(a b c)     # an array
#  $ declare -A Y  # an associative array
#  $ unset Z       # not set at all
#  $ declare -p W X Y Z
#  declare -- W="abc"
#  declare -a X=([0]="a" [1]="b" [2]="c")
#  declare -A Y
#  bash: line 26: declare: Z: not found
#  $ onex::util::read-array W < <(echo -ne "1 1\n2 2\n3 3\n")
#  bash: W is defined but isn't an array
#  $ onex::util::read-array X < <(echo -ne "1 1\n2 2\n3 3\n")
#  $ onex::util::read-array Y < <(echo -ne "1 1\n2 2\n3 3\n")
#  bash: Y is defined but isn't an array
#  $ onex::util::read-array Z < <(echo -ne "1 1\n2 2\n3 3\n")
#  $ declare -p W X Y Z
#  declare -- W="abc"
#  declare -a X=([0]="1 1" [1]="2 2" [2]="3 3")
#  declare -A Y
#  declare -a Z=([0]="1 1" [1]="2 2" [2]="3 3")
function project::util::read-array {
  if [[ -z "$1" ]]; then
    echo "usage: ${FUNCNAME[0]} <varname>" >&2
    return 1
  fi
  if [[ -n $(declare -p "$1" 2>/dev/null) ]]; then
    if ! declare -p "$1" 2>/dev/null | grep -q '^declare -a'; then
      echo "${FUNCNAME[0]}: $1 is defined but isn't an array" >&2
      return 2
    fi
  fi
  # shellcheck disable=SC2034 # this variable _is_ used
  local __read_array_i=0
  while IFS= read -r "$1[__read_array_i++]"; do :; done
  if ! eval "[[ \${$1[--__read_array_i]} ]]"; then
    unset "$1[__read_array_i]" # ensures last element isn't empty
  fi
}