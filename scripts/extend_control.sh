#!/usr/bin/env bash

kill_session_choices() {
	local choices=$(tmux list-window -F "`session_choices_format`" 2>/dev/null)
	echo "$choices" | while read line; do
		[[ "$line" =~ "attached" ]] && local line="$line"
		echo "Kill ==> $line"
	done
	local string="Kill ==> [ Server ]"
	[ $(echo "$choices" | grep -c '') = 1 ] || echo "$string"
}

kill_session() {
	local result=$(echo "`kill_session_choices`" | peco --select-1)
	case "$result" in
		*Kill*Server* )
			tmux kill-server
			operation
			;;
		*Kill*windows* )
			tmux kill-session -t $(echo "$result" | awk '{print $4}' | sed "s/://g")
			$(tmux has_session 2>/dev/null) && kill_session
	esac
}

kill_window_choices() {
	local choices=$(tmux list-windows -F "`window_choices_format`")
	echo "$choices" | while read line; do
		[[ "$line" =~ "active" ]] && local line="$line"
		[[ "$line" =~ "previous" ]] && local line="$line"
		echo "Kill ==> $line"
	done
}

kill_window() {
	local result=$(echo "`kill_window_choices`" | peco | awk '{print $4}' | sed "s/://g")
	if [ "$result" =~ "Kill" ]; then
		tmux kill-window -t "$result"
		kill_window
	fi
}

started() {
	tmux list-windows -F "`window_choices_format`" | while read line; do
		echo "Switch ==> $line"
	done
	echo "Create ==> [ new window ]"
	echo "Kill windows"
}

not_started() {
	local choices=$(tmux list-sessions -F "`session_choices_format`" 2>/dev/null)
	echo $choices | while read line; do
		[[ "$line" =~ "attached" ]] && local line="$line"
		echo "Attach ==> $line"
	done
	echo "Create ==> [ new session ]"
}

operation_choices() {
	if [ `is_tmux_started` = 'true' ]; then
		started
	else
		not_started
	fi
	tmux has-session 2>/dev/null && echo "Kill sessions"
}

operation() {
	local choices=`operation_choices`
	local target=$(echo "$choices" | peco --select-1)
	local selected=$(echo "$target" | awk '{print $4}' | sed "s/://g")
	case "$target" in
		*new\ session* ) tmux new-session ;;
		*new\ window* ) tmux new-window ;;
		"Kill sessions" ) kill_session ;;
		"Kill windows" ) kill_window ;;
		*Switch* ) tmux select-window -t "$selected" ;;
		*Attach* ) tmux attach -t "$selected" ;;
	esac
}

is_tmux_started() {
	[[ -n $TMUX ]] && echo "true" || echo "false"
}

window_choices_format() {
	local index="#{window_index}"
	local command="#{pane_current_command}"
	local panes="(#{window_panes} panes)"
	local active_window="#{?#{window_active},#active,}"
	local last_used_window="#{?#{window_last_flag},#last_used,}"
	echo "[ $index: $command $panes ] $active_window$last_used_window"
}

session_choices_format() {
	local name="#{session_name}"
	local windows="#{session_windows} windows"
	local attached="#{?#{session_attached},#attached,}"
	echo "[ $name: $windows $attached ]"
}

operation
