#!/bin/sh
set -e

FRAMEWORK_DIR=~/projects/nixos-dotfiles
UPGRADE=false

# Parse command line arguments
while [ "$#" -gt 0 ]; do
    case "$1" in
        --upgrade) UPGRADE=true ;;
        *) echo "Unknown parameter: $1"; exit 1 ;;
    esac
    shift
done

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
if [ "$UPGRADE" = true ]; then
    sudo nixos-rebuild switch --flake .#$HOST --show-trace --upgrade
else
    sudo nixos-rebuild switch --flake .#$HOST --show-trace
fi
# nix-collect-garbage -d ( --delete-older-than 10d ) 

echo "NixOS and Home Manager configurations updated successfully!"

