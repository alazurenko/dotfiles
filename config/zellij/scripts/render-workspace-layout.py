#!/usr/bin/env python3

import pathlib
import sys
import tomllib


def q(value: str) -> str:
    return '"' + value.replace("\\", "\\\\").replace('"', '\\"') + '"'


def main() -> int:
    if len(sys.argv) != 4:
        print("Usage: render-workspace-layout.py <workspace> <config> <output>", file=sys.stderr)
        return 1

    workspace_name = sys.argv[1]
    config_path = pathlib.Path(sys.argv[2]).expanduser()
    output_path = pathlib.Path(sys.argv[3]).expanduser()

    try:
        with config_path.open("rb") as fh:
            data = tomllib.load(fh)
        workspace = data["workspaces"][workspace_name]
        tabs = workspace["tabs"]
    except FileNotFoundError:
        print(f"Workspace config not found: {config_path}", file=sys.stderr)
        return 1
    except KeyError as exc:
        print(f"Missing workspace config key: {exc}", file=sys.stderr)
        return 1

    if not isinstance(tabs, list) or not tabs:
        print(f"Workspace '{workspace_name}' must define at least one tab", file=sys.stderr)
        return 1

    lines = [
        "layout {",
        "    default_tab_template {",
        "        pane size=1 borderless=true {",
        '            plugin location="tab-bar"',
        "        }",
        "        children",
        "        pane size=1 borderless=true {",
        '            plugin location="status-bar"',
        "        }",
        "    }",
        "",
    ]

    for index, tab in enumerate(tabs):
        if not isinstance(tab, dict) or "name" not in tab or "cwd" not in tab:
            print(
                f"Workspace '{workspace_name}' tabs must define both 'name' and 'cwd'",
                file=sys.stderr,
            )
            return 1

        focus = " focus=true" if index == 0 else ""
        lines.append(f"    tab name={q(tab['name'])}{focus} cwd={q(tab['cwd'])} {{")
        lines.append("        pane")
        lines.append("    }")
        lines.append("")

    lines.append("}")

    output_path.parent.mkdir(parents=True, exist_ok=True)
    output_path.write_text("\n".join(lines) + "\n")
    return 0


if __name__ == "__main__":
    raise SystemExit(main())
