# dotfiles

My Mac setup: shell, git, editors, apps and projects. One command on a new machine.

## New Mac

```sh
git clone https://github.com/julesmaregiano/dotfiles.git ~/code/dotfiles
~/code/dotfiles/bootstrap.sh
```

The script installs Homebrew and everything in `Brewfile`, sets up Oh My Zsh, links the
config files below into place, creates an SSH key and logs into GitHub, clones every project
from `repos.txt` into `~/code` (with Heroku remotes), and installs the Ruby versions they need.
It's safe to re-run.

Then restore your secrets (below), run `heroku login`, and `bundle install && bin/rails db:prepare` in each Rails app.

## What's here

| File | Linked to |
|---|---|
| `zsh/zshrc`, `zsh/zprofile`, `zsh/p10k.zsh` | `~/.zshrc`, `~/.zprofile`, `~/.p10k.zsh` |
| `git/gitconfig` | `~/.gitconfig` |
| `git/ignore` | `~/.config/git/ignore` (global gitignore) |
| `gh/config.yml` | `~/.config/gh/config.yml` |
| `claude/settings.json` | `~/.claude/settings.json` |
| `vscode/settings.json` | VS Code user settings |
| `Brewfile` / `Brewfile.apps` | Dev tools / personal apps (`brew bundle`) |
| `repos.txt` | Projects to clone |

Files are **symlinked**, so editing `~/.zshrc` edits this repo, so commit the change.

## Keeping it up to date

- New brew package or app → add a line to `Brewfile` (`brew bundle dump --file=-` shows everything installed).
- New project → add a line to `repos.txt`.
- Commit and push whenever you change something.

## Secrets: never in this repo (it's public)

Put machine-only values in `~/.zshrc.local` or `~/.gitconfig.local` (both untracked).
Store these in an encrypted backup and restore them by hand:

- Rails keys: `config/master.key`, `config/credentials/*.key` (diary, restoleads)
- `.env` files: parsion/backend, save2ai/backend, shipup/*
- `~/.aws` (or re-run `aws configure`)

The old 2017 Le Wagon setup is kept under the `legacy-2017` tag.
