#!/usr/bin/env bash

# Controls verbosity of the script output and logging.
KUBE_VERBOSE="${KUBE_VERBOSE:-2}"


# Print a status line.  Formatted to show up in a stream of output.
function project::log::status() {
  local V="${V:-0}"
  if (( KUBE_VERBOSE < V )); then
    return
  fi

  timestamp=$(date +"[%m%d %H:%M:%S]")
  echo "+++ ${timestamp} ${1}"
  shift
  for message; do
    echo "    ${message}"
  done
}



# Print out the stack trace
#
# Args:
#   $1 The number of stack frames to skip when printing.
function project::log::stack() {
  local stack_skip=${1:-0}
  stack_skip=$((stack_skip + 1))
  if [[ ${#FUNCNAME[@]} -gt ${stack_skip} ]]; then
    echo "Call stack:" >&2
    local i
    for ((i=1 ; i <= ${#FUNCNAME[@]} - stack_skip ; i++))
    do
      local frame_no=$((i - 1 + stack_skip))
      local source_file=${BASH_SOURCE[${frame_no}]}
      local source_lineno=${BASH_LINENO[$((frame_no - 1))]}
      local funcname=${FUNCNAME[${frame_no}]}
      echo "  ${i}: ${source_file}:${source_lineno} ${funcname}(...)" >&2
    done
  fi
}