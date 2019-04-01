#!/usr/bin/env bash
# --- Env --------------------------------------------------------------------
export DOTFILES="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"
readonly BACKUP="$HOME/.dotbackup"

# --- Strict Mode ------------------------------------------------------------
set -euo pipefail


# --- Data -------------------------------------------------------------------
set -euo pipefail

INSTALL_FILES=(
  '.aliases'
  '.bash_logout'
  '.bash_profile'
  '.bashrc'
  '.env'
  '.functions'
  '.vimrc'
  '.zshrc'
  )


# --- Functions --------------------------------------------------------------
init() {
  echo 'Setting up ...'
  source "$DOTFILES/.env"
  mkdir -p $BACKUP
}

# Creates the dev directory structure
create_dirs() {
  echo
  echo 'Creating directories ...'
  for i in "${DEV_PATHS[@]}"
  do
    : 
  echo "  → $i"
  mkdir -p $i
  done
}

# Backsup and creates a single dotfile symlink
install_symlink() {
  echo "  → $1"
  SRC="$DOTFILES/$1"
  DEST="$HOME/$1"

  if [[ -f $DEST ]]; then
    cp $DEST $BACKUP
  fi

  rm -f $DEST
  ln -s $SRC $DEST 
}

# Installs all the configured dotfiles as symlinks
install_symlinks() {
  echo
  echo 'Installing symlinks ...'
  for i in "${INSTALL_FILES[@]}"
  do
    : 
  install_symlink $i
  done
}


# --- Body -------------------------------------------------------------------
init
create_dirs
install_symlinks
