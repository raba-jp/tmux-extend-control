#!/usr/bin/env bash

session_choices_format() {
	local name="#{session_name}"
	local windows="#{session_windows} windows"
	local attached="#{?#{session_attached},#attached,}"
	echo "[ $name: $windows $attached ]"
}

session_choices() {
	local choices=$(tmux list-sessions -F "`session_choices_format`" 2>/dev/null)
	echo "$choices" | while read line; do
		echo "Attach ==> $line"
	done
	echo "$choices" | while read line; do
		echo "Kill ==> $line"
	done
	echo "Kill server"
	echo "Exit"
}

session_control() {
	local selected=$(echo "`session_choices`" | peco)
	local selected_id=$(echo "$selected" | awk '{print $4}' | sed "s/://g")
	case "$selected" in
		*Attach* ) tmux switch-client -t "$selected_id" ;;
		*Kill* )
			tmux kill-session -t "$selected_id"
			$(tmux has_session 2>/dev/null) && session_control
			;;
		"Kill server" ) tmux kill-server ;;
		"Exit" ) return ;;
	esac
}

session_control
