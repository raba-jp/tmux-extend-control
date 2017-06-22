#!/usr/bin/env bash

window_choices_format() {
	local index="#{window_index}"
	local command="#{pane_current_command}"
	local panes="(#{window_panes} panes)"
	local active_window="#{?#{window_active},#active,}"
	local last_used_window="#{?#{window_last_flag},#last_used,}"
	echo "[ $index: $command $panes ] $active_window$last_used_window"
}

window_choices() {
	local choices=$(tmux list-windows -F "`window_choices_format`")
	echo "$choices" | while read line; do
		echo "Switch => $line"
	done
	echo "$choices" | while read line; do
		echo "Kill ==> $line"
	done
	echo "Create window"
	echo "Exit"
}

control_window() {
	local selected=$(echo "`window_choices`" | peco)
	local selected_id=$(echo "$selected" | awk '{print $4}' | sed "s/://g")
	case "$selected" in
		*Switch* ) tmux select-window -t "$selected_id" ;;
		*Kill* ) tmux kill-window -t "$selected_id" ;;
		"Create window" ) tmux new-window ;;
		"Exit" ) return ;;
	esac
	control_window
}

control_window
