#!/bin/bash
runAsRoot() {
  if [ "$EUID" -eq 0 ]; then
    # Already root, run command directly
    "$@"
  else
    # Not root, invoke with sudo
    sudo "$@"
  fi
}

deleteIfExists() {
  local dir="$1"
  local use_root="${2:-false}"  # Optional second parameter, defaults to false

  if [ -d "$dir" ]; then
    if [ "$use_root" = true ]; then
      runAsRoot rm -rf "$dir"
    else
      rm -rf "$dir"
    fi
    echo "Directory '$dir' has been deleted."
  elif [ -f "$dir" ]; then
    if [ "$use_root" = true ]; then
      runAsRoot rm -f "$dir"
    else
      rm -f "$dir"
    fi
    echo "File '$dir' has been deleted."
  else
    echo "Directory/File '$dir' does not exist."
  fi
}


current_dir=$(pwd)
config_dir="/home/erik/.config"
local_dir="/home/erik/.local"
services_dir="/etc/systemd/system"

# Alacritty
deleteIfExists "$config_dir/alacritty"
ln -s $current_dir/alacritty $config_dir/alacritty

# KDE globals
deleteIfExists "$config_dir/kdeglobals"
ln -s $current_dir/kdeglobals $config_dir/kdeglobals

# Hyprland
deleteIfExists "$config_dir/hypr"
ln -s $current_dir/hypr $config_dir/hypr

# Quickshell
deleteIfExists "$config_dir/quickshell"
ln -s $current_dir/quickshell $config_dir/quickshell

# Xdg Desktop Portal
deleteIfExists "$config_dir/xdg-desktop-portal"
ln -s $current_dir/xdg-desktop-portal $config_dir/xdg-desktop-portal

# Scripts
deleteIfExists "$config_dir/scripts"
ln -s $current_dir/scripts $config_dir/scripts

# Fonts
deleteIfExists "$local_dir/share/fonts"
ln -s $current_dir/fonts $local_dir/share/fonts
fc-cache -f

# Services
deleteIfExists "$config_dir/services"
ln -s $current_dir/services $config_dir/services

# Services

# GTK4
gsettings set org.gnome.desktop.interface color-scheme "prefer-dark"

# Qt
deleteIfExists "$config_dir/qt"
ln -s $current_dir/qt $config_dir/qt
