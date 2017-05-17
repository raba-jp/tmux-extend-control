#!/usr/bin/env bash

source_path="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"
source "${source_path}/scripts/helpers.sh"
source "${source_path}/scripts/extend_control.sh"

readonly extend_control="$(get_tmux_option "@extend_control", "g")"

tmux bind-key "$extend_control" split-window -l 10 "operation"

unset source_path
