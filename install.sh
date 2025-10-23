#!/bin/bash

deleteIfExists() {
  local dir="$1"
  if [ -d "$dir" ]; then
    rm -rf "$dir"
    echo "Directory '$dir' has been deleted."
  else
    echo "Directory '$dir' does not exist."
  fi
}

config_dir="/home/erik/.config"

# Alacritty
deleteIfExists "$config_dir/alacritty"
ln -s ./alacritty $config_dir/alacritty

# Hyprland
deleteIfExists "$config_dir/hypr"
ln -s ./hypr $config_dir/hypr

# Quickshell
deleteIfExists "$config_dir/quickshell"
ln -s ./quickshell $config_dir/quickshell
