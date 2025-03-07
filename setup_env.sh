#!/bin/bash

# --- Configuration ---
# List of formulae (command-line tools) to install, in alphabetical order
declare -a formulae=(
  docker
  docker-compose
  git
  python
  terraform
)

# List of casks (GUI applications) to install, in alphabetical order
declare -a casks=(
  appcleaner
  boop
  dash
  docker
  gifox
  github
  iina
  iterm2
  jordanbaird-ice
  keepingyouawake
  keka
  maintenance
  monitorcontrol
  parallels
  rectangle
  stats
  visual-studio-code
)

# --- Functions ---
# Function to check if a command exists
command_exists() {
  command -v "$1" &> /dev/null
}

# Function to install Xcode Command Line Tools, handling errors
install_xcode_tools() {
    echo "Installing Xcode Command Line Tools..."
    # Trigger the installation and handle potential errors.
    if ! xcode-select --install; then
        echo "ERROR: Failed to initiate Xcode Command Line Tools installation." >&2
        echo "Please install them manually and then re-run this script." >&2
        exit 1
    fi

    # Wait for the installation to finish.  We can't directly check the exit
    # status of the installer GUI, so we'll use a loop and check for the
    # presence of a file that's created upon successful installation.
    echo "Waiting for Xcode Command Line Tools installation to complete..."
    while [[ ! -f /Library/Developer/CommandLineTools/usr/bin/git ]]; do
        sleep 5
    done

     # Verify git is installed which means the command line tools installation has completed
    if command_exists git; then
        echo "Xcode Command Line Tools installed successfully."
    else
        echo "ERROR: Failed to install Xcode Command Line Tools installation seems to have failed." >&2
        echo "Please check the installation manually." >&2
        exit 1
    fi
}

# Function to install a Homebrew formula, handling errors
install_formula() {
  local formula_name="$1"
  echo "Installing $formula_name..."
  if ! brew install "$formula_name"; then
    echo "ERROR: Failed to install $formula_name" >&2  # Error to stderr
    exit 1
  fi
  echo "Successfully installed $formula_name."
}

# Function to install a Homebrew cask, handling errors
install_cask() {
  local cask_name="$1"
  echo "Installing $cask_name..."
  if ! brew install --cask "$cask_name"; then
    echo "ERROR: Failed to install $cask_name" >&2  # Error to stderr
    exit 1
  fi
  echo "Successfully installed $cask_name."
}

# --- Main Script ---

# 1. Install Xcode Command Line Tools (if not already installed)
#   - We keep this check, even though we're installing git via Homebrew,
#     because other tools might depend on the full Xcode CLT package.
if ! command_exists git; then
  install_xcode_tools
else
    echo "Xcode Command Line Tools are already installed (git found)."
fi

# 2. Install Homebrew (if not already installed)
if ! command_exists brew; then
  echo "Installing Homebrew..."
  # Let the user see the initial Homebrew installation output.
  /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"

  # Determine Homebrew's bin directory (works on both Intel and Apple Silicon)
  export HOMEBREW_PREFIX=$(brew --prefix)

  # Add Homebrew to the PATH, if not already there, idempotently
  if ! grep -q "eval \"\$($HOMEBREW_PREFIX/bin/brew shellenv)\"" ~/.zprofile; then
      echo 'eval "$('$HOMEBREW_PREFIX'/bin/brew shellenv)"' >> ~/.zprofile
  fi
  eval "$($HOMEBREW_PREFIX/bin/brew shellenv)"

  echo "Homebrew installed."
else
  echo "Homebrew is already installed."
fi

# 3. Update Homebrew
echo "Updating Homebrew package list..."
if ! brew update; then
  echo "ERROR: Failed to update Homebrew" >&2
  exit 1
fi

# 4. Install Formulae
for formula in "${formulae[@]}"; do
  install_formula "$formula"
done

# 5. Install Casks
for cask in "${casks[@]}"; do
  install_cask "$cask"
done

echo "Installation complete!"
exit 0