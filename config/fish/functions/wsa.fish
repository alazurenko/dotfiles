function wsa --description "Attach to a running Zellij session via fzf"
    set -l session (
        zellij list-sessions 2>/dev/null \
            | string replace -ra '\e\[[0-9;]*m' '' \
            | fzf --prompt="session: "
    )
    or return 0

    set -l name (string match -r '^\S+' $session)
    zellij attach $name
end
