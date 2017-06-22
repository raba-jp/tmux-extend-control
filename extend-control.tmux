#!/usr/bin/env bash

source_path="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"
source "${source_path}/scripts/helpers.sh"

tmux bind-key "$(get_tmux_option "@window_control_key" "w")" \
	split-window -l 10 "$source_path/scripts/window.sh"
tmux bind-key "$(get_tmux_option "@session_control_key", "s")" \
	split-window -l 10 "$source_path/scripts/session.sh"


unset source_path
