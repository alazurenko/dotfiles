function ws --description "Open a configured Zellij workspace"
    if test (count $argv) -lt 1
        echo "Usage: ws <workspace-name>"
        return 1
    end

    set -l workspace_name $argv[1]
    set -l config_path "$HOME/.config/workspaces.toml"
    set -l layout_name "__workspace_$workspace_name"
    set -l layout_path "$HOME/.config/zellij/layouts/$layout_name.kdl"
    set -l renderer "$HOME/.config/zellij/scripts/render-workspace-layout.py"

    if not test -f $config_path
        echo "Missing workspace config: $config_path"
        return 1
    end

    if not test -x $renderer
        echo "Missing workspace renderer: $renderer"
        return 1
    end

    set -l session_name (python3 -c '
import pathlib
import sys
import tomllib

workspace_name = sys.argv[1]
config_path = pathlib.Path(sys.argv[2])
with config_path.open("rb") as fh:
    data = tomllib.load(fh)

workspace = data["workspaces"][workspace_name]
print(workspace.get("session", workspace_name))
' $workspace_name $config_path
    )
    or return 1

    set -l sessions (zellij list-sessions 2>/dev/null | string replace -ra '\e\[[0-9;]*m' '')
    if string match -qr "^$session_name\\b" $sessions
        if string match -qr "^$session_name\\b.*EXITED" $sessions
            zellij delete-session $session_name >/dev/null 2>&1
        else
            zellij attach $session_name
            return
        end
    end

    python3 $renderer $workspace_name $config_path $layout_path
    or return 1

    zellij --session $session_name --new-session-with-layout $layout_name
end
