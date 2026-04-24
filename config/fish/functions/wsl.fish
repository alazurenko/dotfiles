function wsl --description "List configured Zellij workspaces"
    python3 -c "
import tomllib, pathlib
p = pathlib.Path.home() / '.config/workspaces.toml'
if not p.exists():
    raise SystemExit('Missing ~/.config/workspaces.toml')
data = tomllib.loads(p.read_text())
for k in data.get('workspaces', {}):
    print(k)
"
end
