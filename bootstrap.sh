#!/usr/bin/env bash
# Set up a fresh Mac. Safe to re-run: every step skips what's already done.
#   git clone https://github.com/julesmaregiano/dotfiles.git ~/code/dotfiles && ~/code/dotfiles/bootstrap.sh
set -euo pipefail

DOTFILES="$(cd "$(dirname "$0")" && pwd)"
CODE="$HOME/code"
step() { printf '\n\033[1;34m==> %s\033[0m\n' "$*"; }

# 1. Apple command line tools (git, compilers)
step "Xcode command line tools"
if ! xcode-select -p >/dev/null 2>&1; then
  xcode-select --install
  read -rp "Finish the installer popup, then press Enter… "
fi

# 2. Homebrew
step "Homebrew"
if ! command -v brew >/dev/null 2>&1; then
  /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
fi
eval "$(/opt/homebrew/bin/brew shellenv)"

# 3. Packages & apps
step "Brewfile (dev tools)"
brew bundle --file="$DOTFILES/Brewfile"

read -rp "Also install personal apps from Brewfile.apps (Notion, Obsidian, Spotify…)? [y/N] " ans
[[ "$ans" =~ ^[Yy]$ ]] && brew bundle --file="$DOTFILES/Brewfile.apps"

# 4. Oh My Zsh
step "Oh My Zsh"
if [[ ! -d "$HOME/.oh-my-zsh" ]]; then
  RUNZSH=no KEEP_ZSHRC=yes sh -c "$(curl -fsSL https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh)"
fi

# 5. Link config files (existing files are moved to *.backup)
step "Linking config files"
link() {
  local src="$DOTFILES/$1" dst="$2"
  mkdir -p "$(dirname "$dst")"
  if [[ -e "$dst" && ! -L "$dst" ]]; then mv "$dst" "$dst.backup"; echo "  backed up $dst"; fi
  ln -sfn "$src" "$dst"
  echo "  $dst → $1"
}
APP="$HOME/Library/Application Support"
link zsh/zshrc             "$HOME/.zshrc"
link zsh/zprofile          "$HOME/.zprofile"
link zsh/p10k.zsh          "$HOME/.p10k.zsh"
link git/gitconfig         "$HOME/.gitconfig"
link git/ignore            "$HOME/.config/git/ignore"
link gh/config.yml         "$HOME/.config/gh/config.yml"
link claude/settings.json  "$HOME/.claude/settings.json"
link vscode/settings.json  "$APP/Code/User/settings.json"

# 6. SSH key + GitHub login (gh offers to upload the key)
step "SSH key & GitHub"
if [[ ! -f "$HOME/.ssh/id_ed25519" ]]; then
  ssh-keygen -t ed25519 -C "$(whoami)@$(scutil --get LocalHostName)" -f "$HOME/.ssh/id_ed25519"
fi
cat > "$HOME/.ssh/config" <<'EOF'
Host *
  AddKeysToAgent yes
  UseKeychain yes
  IdentityFile ~/.ssh/id_ed25519
EOF
ssh-add --apple-use-keychain "$HOME/.ssh/id_ed25519" 2>/dev/null || true
if ! gh auth status >/dev/null 2>&1; then
  echo "  Choose: GitHub.com → SSH → upload ~/.ssh/id_ed25519.pub → login with browser"
  gh auth login --hostname github.com --git-protocol ssh --web
fi

# 7. Clone projects
step "Cloning projects into $CODE"
mkdir -p "$CODE"
grep -vE '^\s*(#|$)' "$DOTFILES/repos.txt" | while read -r dir repo heroku_app; do
  if [[ -d "$CODE/$dir/.git" ]]; then
    echo "  $dir already cloned"
  else
    gh repo clone "$repo" "$CODE/$dir" -- --quiet </dev/null && echo "  cloned $dir"
  fi
  if [[ "$heroku_app" != "-" ]] && ! git -C "$CODE/$dir" remote | grep -qx heroku; then
    git -C "$CODE/$dir" remote add heroku "https://git.heroku.com/$heroku_app.git"
  fi
done

# 8. Ruby versions each project asks for
step "Ruby versions"
eval "$(rbenv init - bash)"
for f in "$CODE"/*/.ruby-version; do
  [[ -f "$f" ]] || continue
  v="$(tr -d '[:space:]' < "$f")"
  echo "  $v (for $(basename "$(dirname "$f")"))"
  rbenv install --skip-existing "$v" || echo "  ⚠️  could not build Ruby $v — skip for now"
done

step "Done!"
cat <<EOF
Next steps:
  1. Open a new Ghostty window (the prompt should look like before).
  2. Restore secrets from your backup (see README → Secrets).
  3. heroku login
  4. In each Rails app:  bundle install && bin/rails db:prepare
EOF
