# Environment
set -x GPG_TTY (tty)

# PATH
# fish_add_path ~/.local/bin

# Local secrets
# set -x OPENAI_API_KEY "your-api-key"
if test -f ~/.config/fish/secrets.fish
    source ~/.config/fish/secrets.fish
end

zoxide init --cmd cd fish | source
