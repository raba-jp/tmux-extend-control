#!/usr/bin/env bash

source_path="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"
source "${source_path}/scripts/helpers.sh"

window_cmd_key="$(get_tmux_option "@window_control_key" "w")"
tmux unbind "C-$window_cmd_key"
tmux bind-key "$window_cmd_key" split-window -l 10 "$source_path/scripts/window.sh"

session_cmd_key="$(get_tmux_option "@session_control_key", "s")"
tmux unbind "C-$session_cmd_key"
tmux bind-key "$session_cmd_key" split-window -l 10 "$source_path/scripts/session.sh"


unset source_path
