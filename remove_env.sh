#!/bin/bash

# --- Configuration ---
# List of formulae to uninstall, in alphabetical order
declare -a formulae=(
  docker
  git
  python
  terraform
)

# List of casks to uninstall, in alphabetical order
declare -a casks=(
  alt-tab
  appcleaner
  boop
  docker
  dockdoor
  ghostty
  gifox
  iina
  keka
  keepingyouawake
  monitorcontrol
  onyx
  postman
  rectangle
  stats
  virtualbox
  visual-studio-code
  yubico-yubikey-manager
  zen-browser
)

# --- Global Variables ---
DRY_RUN=false  # Set to true to enable dry-run mode

# --- Functions ---

# Function to check if a command exists
command_exists() {
  command -v "$1" &> /dev/null
}

# Function to execute a command, handling dry-run and errors
execute_command() {
  local cmd="$1"
  local error_message="$2"
  if $DRY_RUN; then
    echo "[DRY RUN] Would execute: $cmd"
  else
    echo "Executing: $cmd"
    if ! bash -c "$cmd"; then
      # Print the error, but don't exit. Continue with other uninstalls.
      echo "ERROR: $error_message" >&2
    fi
  fi
}

# Function to uninstall a Homebrew formula, handling errors
uninstall_formula() {
  local formula_name="$1"
    # Check if the formula is installed before trying to uninstall
    if $DRY_RUN; then
        echo "[DRY RUN] Would check if formula $formula_name is installed."
    elif ! brew list "$formula_name" &> /dev/null; then
        echo "Formula $formula_name is not installed. Skipping."
        return 0 # Skip to the next one
    fi

  execute_command "brew uninstall $formula_name" "Failed to uninstall formula $formula_name"
}

# Function to uninstall a Homebrew cask, handling errors
uninstall_cask() {
  local cask_name="$1"
     # Check if the cask is installed before trying to uninstall
    if $DRY_RUN; then
        echo "[DRY RUN] Would check if cask $cask_name is installed."
    elif ! brew list --cask "$cask_name" &> /dev/null; then
        echo "Cask $cask_name is not installed. Skipping."
        return 0  # Skip to the next one
    fi
  execute_command "brew uninstall --cask $cask_name" "Failed to uninstall cask $cask_name"
}

# --- Main Script ---

# Check for dry-run flag
if [[ "$1" == "--dry-run" ]]; then
  DRY_RUN=true
  echo "Running in DRY-RUN mode. No changes will be made."
fi

# User confirmation prompt (skip in dry-run mode)
if ! $DRY_RUN; then
  echo "This script will attempt to uninstall the following Homebrew formulae and casks:"
  echo "Formulae: $(IFS=,; echo "${formulae[*]}")"  # Print the formulae list
  echo "Casks: $(IFS=,; echo "${casks[*]}")"  # Print the cask list

    # Check that brew exists
    if ! command_exists brew; then
        echo "Homebrew is not installed.  Cannot proceed with uninstallation."
        exit 1
    fi

  read -r -p "Are you sure you want to continue? (y/N) " response
  case "$response" in
    [yY][eE][sS]|[yY])
      # Proceed with uninstallation
      ;;
    *)
      echo "Uninstallation cancelled."
      exit 0
      ;;
  esac
fi


# 1. Uninstall Formulae
for formula in "${formulae[@]}"; do
  uninstall_formula "$formula"
done

# 2. Uninstall Casks
for cask in "${casks[@]}"; do
  uninstall_cask "$cask"
done

echo "Uninstallation (or dry-run) complete!"
exit 0