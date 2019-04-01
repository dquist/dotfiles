#!/usr/bin/env bash
# ----------------------------------------------------------------------------
# DESCRIPTION
#   Installs the project dotfiles on the local system
#
# EXAMPLES
#   install.sh
#
# OPTIONS
#   -c        Copy the dotfiles instead of using symlinks (Windows)
#
# ----------------------------------------------------------------------------
# --- Env --------------------------------------------------------------------
export DOTFILES="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"
readonly BACKUP="$HOME/.dotbackup"

# --- Strict Mode ------------------------------------------------------------
set -euo pipefail

# --- Options ----------------------------------------------------------------
copy_flag=''

OPTIND=1
while getopts 'c' flag; do
  case "${flag}" in
    c) copy_flag='true' ;;
    *) error "Unexpected option ${flag}" ;;
  esac
done

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

# Installs a single dotfile, backing up any existing file
install_dotfile() {
  echo "  → $1"
  SRC="$DOTFILES/$1"
  DEST="$HOME/$1"

  if [[ -f $DEST ]]; then
    cp $DEST $BACKUP
  fi

  rm -f $DEST
  if [[ $copy_flag == 'true' ]]; then
    cp $SRC $DEST
  else
    ln -s $SRC $DEST 
  fi
}

# Installs all the configured dotfiles as symlinks
install_dotfiles() {
  echo
  echo 'Installing dotfiles ...'
  for i in "${INSTALL_FILES[@]}"
  do
    : 
  install_dotfile $i
  done
}


# --- Body -------------------------------------------------------------------
init
create_dirs
install_dotfiles
