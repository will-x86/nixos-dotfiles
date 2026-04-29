#!/bin/sh
set -e
FRAMEWORK_DIR=~/projects/nixos-dotfiles
BUILDER=false

while [ "$#" -gt 0 ]; do
    case "$1" in
        --builder) BUILDER=true ;;
        *) echo "Unknown parameter: $1"; exit 1 ;;
    esac
    shift
done


if [ ! -d "$FRAMEWORK_DIR" ]; then
    echo "Directory $FRAMEWORK_DIR does not exist."
    exit 1
fi

cd "$FRAMEWORK_DIR"
pwd

#alejandra .
gen=$(sudo nix-env --list-generations --profile /nix/var/nix/profiles/system | grep current)
git --no-pager diff
git add .
git commit -m "$gen" || true

echo "Rebuilding NixOS and applying Home Manager configuration"
if [ "$BUILDER" = true ]; then
    sudo nixos-rebuild --builders 'ssh://root@nixos-vm' switch --flake ".#$HOST" --show-trace
else
    sudo nixos-rebuild switch --flake ".#$HOST" --show-trace
fi

# nix-collect-garbage -d ( --delete-older-than 10d )
echo "NixOS and Home Manager configurations updated successfully!"
