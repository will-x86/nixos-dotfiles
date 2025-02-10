#!/bin/sh
set -e

FRAMEWORK_DIR=~/projects/nixos-dotfiles

git_no_pager() {
    GIT_PAGER=cat git "$@"
}

if [ ! -d "$FRAMEWORK_DIR" ]; then
    echo "Directory $FRAMEWORK_DIR does not exist."
    exit 1
fi

cd "$FRAMEWORK_DIR"
pwd

gen=$(sudo nix-env --list-generations --profile /nix/var/nix/profiles/system | grep current)

git_no_pager diff

git add .
git commit -m "$gen" || true

alejandra .

echo "Rebuilding NixOS and applying Home Manager configuration"
sudo nixos-rebuild switch --flake .#$HOST --show-trace

echo "NixOS and Home Manager configurations updated successfully!"

