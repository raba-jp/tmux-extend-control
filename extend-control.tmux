#!/usr/bin/env bash

source_path="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"
source "${source_path}/scripts/helpers.sh"

readonly extend_control_key="$(get_tmux_option "@extend_control_key" "g")"

tmux bind-key "$extend_control_key" split-window -l 10 "$source_path/scripts/extend_control.sh"

unset source_path
