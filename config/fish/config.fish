set -g fish_greeting

# Environment
set -x GPG_TTY (tty)

# Homebrew
if test -x /opt/homebrew/bin/brew
    # Keep `brew install` responsive; update Homebrew explicitly when desired.
    set -x HOMEBREW_NO_AUTO_UPDATE 1
    set -x HOMEBREW_NO_ENV_HINTS 1
    eval (/opt/homebrew/bin/brew shellenv)
end

# PATH
# fish_add_path ~/.local/bin

# Local secrets
# set -x OPENAI_API_KEY "your-api-key"
if test -f ~/.config/fish/secrets.fish
    source ~/.config/fish/secrets.fish
end

if type -q zoxide
    zoxide init --cmd cd fish | source
end
