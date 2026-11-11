# Dev essentials — installed by bootstrap.sh
# Update after installing something new:  brew bundle dump --file=- | less  (then copy the lines you want here)

tap "heroku/brew"

# --- Shell
brew "powerlevel10k"
brew "zsh-autosuggestions"
brew "zsh-syntax-highlighting"
brew "coreutils"
brew "btop"

# --- Git & cloud CLIs
brew "git"
brew "gh"
brew "heroku/brew/heroku", trusted: true
brew "stripe-cli"
brew "awscli"

# --- Languages
brew "rbenv"
brew "ruby-build"
brew "node"
brew "yarn"
brew "python@3.13"

# --- Databases
brew "postgresql@14", restart_service: :changed
brew "libpq"

# --- Native libs needed by gems (nokogiri, ruby-vips, rgeo…)
brew "cmake"
brew "make"
brew "gcc@11"
brew "libxml2"
brew "libxslt"
brew "vips"
brew "proj"
brew "ffmpeg"
brew "lowdown"

# --- Dev apps
cask "ghostty"
cask "visual-studio-code"
cask "cursor"
cask "claude"
cask "1password"
cask "google-chrome"
cask "firefox"
cask "rectangle"
cask "ngrok"
cask "pgadmin4"
cask "sequel-ace"

# --- Global npm packages
npm "@anthropic-ai/claude-code"
npm "@hubspot/cli"
npm "openclaw"

# --- VS Code extensions
vscode "castwide.solargraph"
vscode "craigmaslowski.erb"
vscode "groksrc.ruby"
vscode "hoovercj.ruby-linter"
vscode "marcoroth.herb-lsp"
vscode "marcoroth.stimulus-lsp"
vscode "miguel-savignano.ruby-symbols"
vscode "ms-python.debugpy"
vscode "ms-python.python"
vscode "ms-python.vscode-pylance"
vscode "ms-python.vscode-python-envs"
vscode "shopify.ruby-extensions-pack"
vscode "shopify.ruby-lsp"
vscode "sorbet.sorbet-vscode-extension"
vscode "vayan.haml"
vscode "vortizhe.simple-ruby-erb"
vscode "walkme.ruby-extension-pack"
