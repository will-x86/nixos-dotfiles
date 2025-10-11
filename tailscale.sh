#!/bin/sh

CONFIG_FILE="$HOME/.tailscale_config"

log_error() {
    echo "Error: $1" >&2
    exit 1
}

check_tailscale() {
    if ! command -v tailscale &> /dev/null; then
        log_error "Tailscale is not installed. Please install from https://tailscale.com/download"
    fi
}

set_exit_node() {
    local exit_node=$1

    if [ "$exit_node" = "uk" ]; then
        exit_node="gb-mnc-wg-201.mullvad.ts.net"
    fi
    if [ "$exit_node" = "usa" ]; then
        exit_node="us-chi-wg-301.mullvad.ts.net"
    fi

    if [ -z "$exit_node" ]; then
        if [ -f "$CONFIG_FILE" ]; then
            exit_node=$(cat "$CONFIG_FILE")
        else
            log_error "No exit node specified. Usage: $0 mullvad <exit-node-hostname>"
        fi
    fi

    echo "Setting exit node to: $exit_node"
    sudo tailscale set --exit-node="$exit_node" --exit-node-allow-lan-access=true
    
    echo "$exit_node" > "$CONFIG_FILE"
}

advertise_routes() {
    echo "Advertising local network routes"
    sudo tailscale up --advertise-routes=10.0.0.0/16
}

reset_routes() {
    echo "Resetting route advertisements"
    sudo tailscale up --advertise-routes=
}

accept_routes() {
    echo "Accepting routes"
    local exit_node=$1
    if [ -z "$exit_node" ]; then
        if [ -f "$CONFIG_FILE" ]; then
            exit_node=$(cat "$CONFIG_FILE")
        else
            log_error "No exit node specified. Usage: $0 accept-routes <exit-node-hostname>"
        fi
    fi
    if [ "$exit_node" = "uk" ]; then
        exit_node="gb-glw-wg-001.mullvad.ts.net"
    fi
    echo "Setting exit node to: $exit_node"
    
    echo "$exit_node" > "$CONFIG_FILE"

    sudo tailscale up --accept-routes=true --exit-node-allow-lan-access=true --exit-node="$exit_node"
}

tailscale_up() {
    echo "Bringing Tailscale up"
    sudo tailscale up
}

main() {
    check_tailscale

    case "$1" in
        mullvad)
            set_exit_node "$2"
            ;;
        advertise)
            advertise_routes
            ;;
        advertise-reset)
            reset_routes
            ;;
        accept-routes)
            accept_routes "$2"
            ;;
        up)
            tailscale_up
            ;;
        *)
            echo "Usage:"
            echo "  $0 mullvad [exit-node]     - Set exit node (optional hostname)"
            echo "  $0 advertise               - Advertise local network routes"
            echo "  $0 advertise-reset         - Reset route advertisements"
            echo "  $0 accept-routes           - Accept routes"
            echo "  $0 up                      - Bring Tailscale up"
            exit 1
            ;;
    esac
}

main "$@"
