# Only major and minor version should be specified here
REQUIRED_APOLLO_CODEGEN_VERSION=0.17

# Part of this code has been adapted from https://github.com/facebook/react-native/blob/master/packager/react-native-xcode.sh

# This script is supposed to be invoked as part of the Xcode build process
# and relies on environment variables set by Xcode

# We consider versions to be compatible if the major and minor versions match

export PATH=/usr/bin:/bin:/usr/sbin:/sbin:/usr/local/bin:$PATH

if [[ -z "$CONFIGURATION" ]]; then
    echo "$0 must be invoked as part of an Xcode script phase"
    exit 1
fi

# Define NVM_DIR and source the nvm.sh setup script
[[ -z "$NVM_DIR" ]] && export NVM_DIR="$HOME/.nvm"

if [[ -s "$HOME/.nvm/nvm.sh" ]]; then
  . "$HOME/.nvm/nvm.sh"
elif [[ -x "$(command -v brew)" && -s "$(brew --prefix nvm)/nvm.sh" ]]; then
  . "$(brew --prefix nvm)/nvm.sh"
fi

# Set up the nodenv node version manager if present
if [[ -x "$HOME/.nodenv/bin/nodenv" ]]; then
  eval "$("$HOME/.nodenv/bin/nodenv" init -)"
fi

# Print commands before executing them (useful for troubleshooting)
set -x

echo $PATH
env
which node
exec apollo-codegen "$@"
