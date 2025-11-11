tmux_start () {
    session="daily"

    if tmux has-session -t $session 2>/dev/null; then
        printf "%s\n" "Session is started"
        exit 1
    fi

	tmux start-server
	tmux new-session -d -s $session

	tmux rename-window -t $session "[btop]"
	tmux selectp -t 0
	tmux send-keys "btop" C-m

	tmux new-window -t $session -n "[journalctl]"
	tmux selectp -t 1
	tmux send-keys "doas journalctl -f" C-m

    tmux attach-session -t $session
}

tmux_start