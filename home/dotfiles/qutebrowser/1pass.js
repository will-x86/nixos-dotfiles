#!/usr/bin/env bash

set +e # Keep this, as rofi can be cancelled

# JS field injection code
javascript_escape() {
    # shellcheck disable=SC2001
    sed "s,[\\\\'\"\/],\\\\&,g" <<< "$1"
}

js() {
cat <<EOF
    function isVisible(elem) {
        if (!elem) return false;
        var style = elem.ownerDocument.defaultView.getComputedStyle(elem, null);
        if (style.getPropertyValue("visibility") !== "visible" ||
            style.getPropertyValue("display") === "none" ||
            style.getPropertyValue("opacity") === "0") {
            return false;
        }
        return elem.offsetWidth > 0 && elem.offsetHeight > 0;
    };
    function hasPasswordField(form) {
        if (!form) return false;
        var inputs = form.getElementsByTagName("input");
        for (var j = 0; j < inputs.length; j++) {
            if (inputs[j].type == "password") return true;
        }
        return false;
    };
    function loadData2Form (form) {
        if (!form) return;
        var inputs = form.getElementsByTagName("input");
        var username_filled = false;
        for (var j = 0; j < inputs.length; j++) {
            var input = inputs[j];
            if (!username_filled && isVisible(input) && (input.type == "text" || input.type == "email" || input.type == "tel" || input.type == "url" || input.type == "number")) {
                input.focus(); input.value = "$(javascript_escape "${USERNAME}")";
                input.dispatchEvent(new Event('change', { bubbles: true })); input.blur();
                username_filled = true;
            }
            if (input.type == "password" && isVisible(input)) {
                input.focus(); input.value = "$(javascript_escape "${PASSWORD}")";
                input.dispatchEvent(new Event('change', { bubbles: true })); input.blur();
            }
        }
    };
    var forms = document.getElementsByTagName("form");
    if("$(javascript_escape "${QUTE_URL}")" == window.location.href) {
        var form_to_fill = null;
        for (var i = 0; i < forms.length; i++) {
            if (hasPasswordField(forms[i])) {
                form_to_fill = forms[i]; break;
            }
        }
        if (!form_to_fill && forms.length > 0) form_to_fill = forms[0];
        if (form_to_fill) {
            loadData2Form(form_to_fill);
        } else if (document.body) {
            var inputs = document.getElementsByTagName("input");
            var username_filled = false;
            for (var j = 0; j < inputs.length; j++) {
                var input = inputs[j];
                if (!username_filled && isVisible(input) && (input.type == "text" || input.type == "email")) {
                     input.focus(); input.value = "$(javascript_escape "${USERNAME}")";
                     input.dispatchEvent(new Event('change', { bubbles: true })); input.blur(); username_filled = true;
                }
                if (input.type == "password" && isVisible(input)) {
                     input.focus(); input.value = "$(javascript_escape "${PASSWORD}")";
                     input.dispatchEvent(new Event('change', { bubbles: true })); input.blur();
                }
            }
        }
    } else {
        alert("Secrets will not be inserted.\\nUrl of this page (" + window.location.href + ") and the one where the user script was started (" + "$(javascript_escape "${QUTE_URL}")" + ") differ.");
    }
EOF
}

log_debug() { :; }


if [ -z "$QUTE_FIFO" ]; then echo "Error: QUTE_FIFO not set." >&2; exit 1; fi
if [ -z "$QUTE_URL" ]; then echo "message-error 'QUTE_URL not set.'" >> "$QUTE_FIFO"; exit 1; fi

URL_HOSTNAME=$(echo "$QUTE_URL" | awk -F/ '{print $3}' | sed 's/^www\.//g')
TOKEN_TMPDIR="${TMPDIR:-/tmp}"
TOKEN_CACHE="$TOKEN_TMPDIR/1password-session.token"

log_debug "QUTE_URL is '$QUTE_URL'"
log_debug "URL_HOSTNAME is '$URL_HOSTNAME'"
echo "message-info '1Password: Looking for credentials for $URL_HOSTNAME...'" >> "$QUTE_FIFO"

OP_SESSION_ARGS=""
if op whoami > /dev/null 2>&1; then
    log_debug "Using existing session (Desktop App integration)."
else
    log_debug "Desktop App integration not active/locked. Trying cached token..."
    if [ -f "$TOKEN_CACHE" ]; then
        CACHED_TOKEN=$(cat "$TOKEN_CACHE")
        if op whoami --session="$CACHED_TOKEN" > /dev/null 2>&1; then
            log_debug "Using cached session token."
            OP_SESSION_ARGS="--session=$CACHED_TOKEN"
        else
            log_debug "Cached token invalid/expired."; > "$TOKEN_CACHE"
        fi
    fi
    if [ -z "$OP_SESSION_ARGS" ]; then
        log_debug "No active session. Prompting for master password..."
        if ! command -v rofi > /dev/null; then echo "message-error '1P: rofi missing.'" >> "$QUTE_FIFO"; exit 1; fi
        MASTER_PASSWORD=$(rofi -dmenu -password -p "1Password Master Password: " -mesg "Enter master password")
        if [ -z "$MASTER_PASSWORD" ]; then log_debug "MP entry cancelled."; echo "message-error '1P: MP cancelled.'" >> "$QUTE_FIFO"; exit 1; fi
        NEW_TOKEN=$(echo "$MASTER_PASSWORD" | op signin --raw 2>/dev/null)
        if [ -n "$NEW_TOKEN" ]; then
            log_debug "signin --raw successful."
            install -m 600 /dev/null "$TOKEN_CACHE"; echo "$NEW_TOKEN" > "$TOKEN_CACHE"
            OP_SESSION_ARGS="--session=$NEW_TOKEN"
        else
            log_debug "signin --raw no token. Checking app integration."
            if op whoami > /dev/null 2>&1; then
                 log_debug "Desktop App integration active after MP entry."
            else
                log_debug "Auth failed."; echo "message-error '1P: Auth failed.'" >> "$QUTE_FIFO"
                [ -f "$TOKEN_CACHE" ] && > "$TOKEN_CACHE"; exit 1
            fi
        fi
    fi
fi
log_debug "OP_SESSION_ARGS is '$OP_SESSION_ARGS'"

log_debug "Searching by URL: $URL_HOSTNAME"
# Robust jq for URL search: collect IDs into array, take first, fallback to empty string
ITEM_ID=$(op item list $OP_SESSION_ARGS --format json | \
          jq --arg url_hostname "$URL_HOSTNAME" -r \
          '([.[] | select(.urls[].href | strings | test("(?i)" + $url_hostname)) | .id] | first) // ""')
log_debug "ITEM_ID after URL search: '$ITEM_ID'"

if [ -z "$ITEM_ID" ]; then
    log_debug "No URL match. Searching by title..."
    echo "message-info '1P: No URL match. Select item...'" >> "$QUTE_FIFO"
    if ! command -v rofi > /dev/null; then echo "message-error '1P: rofi missing.'" >> "$QUTE_FIFO"; exit 1; fi
    
    ROFI_INPUT_DATA=$(op item list $OP_SESSION_ARGS --format json | jq -r 'map(.title) | .[]')
    log_debug "Data for rofi (first 10):"; echo "$ROFI_INPUT_DATA" | head -n 10

    SELECTED_TITLE=$(echo "$ROFI_INPUT_DATA" | \
                     rofi -dmenu -i -p "1Password (select for $URL_HOSTNAME): ")
    log_debug "SELECTED_TITLE from rofi: '$SELECTED_TITLE'"
    
    if [ -n "$SELECTED_TITLE" ]; then
        log_debug "Getting ID for title: '$SELECTED_TITLE'"
        OP_LIST_JSON=$(op item list $OP_SESSION_ARGS --format json)
        
        # Option 1: Case-sensitive exact title match (more precise if titles are exact)
        # ITEM_ID=$(echo "$OP_LIST_JSON" | \
        #           jq --arg title_exact "$SELECTED_TITLE" -r \
        #           '([.[] | select(.title == $title_exact) | .id] | first) // ""')

        # Option 2: Case-insensitive "contains" title match (more flexible)
        ITEM_ID=$(echo "$OP_LIST_JSON" | \
                  jq --arg title_needle "$(echo "$SELECTED_TITLE" | tr '[:upper:]' '[:lower:]')" -r \
                  '([.[] | select(.title | strings | ascii_downcase | contains($title_needle)) | .id] | first) // ""')
        
        log_debug "ITEM_ID after title search ('$SELECTED_TITLE'): '$ITEM_ID'"
    else
        log_debug "Item selection cancelled."; echo "message-info '1P: Selection cancelled.'" >> "$QUTE_FIFO"
    fi
fi

if [ -n "$ITEM_ID" ]; then
    log_debug "Fetching item details for ITEM_ID: '$ITEM_ID'"
    ITEM_JSON=$(op item get $OP_SESSION_ARGS "$ITEM_ID" --format json)

    if [ -z "$ITEM_JSON" ] || ! echo "$ITEM_JSON" | jq -e . > /dev/null 2>&1; then
        log_debug "Failed to retrieve valid JSON for item ID '$ITEM_ID'."
        echo "message-error '1P: Failed to get item $ITEM_ID.'" >> "$QUTE_FIFO"; exit 1;
    fi

    PASSWORD=$(echo "$ITEM_JSON" | jq -r '.fields[]? | select(.purpose=="PASSWORD") | .value // empty')
    ITEM_TITLE=$(echo "$ITEM_JSON" | jq -r '.title // "Item"')
    log_debug "Item: '$ITEM_TITLE', Pass found: $([ -n "$PASSWORD" ] && echo "Yes" || echo "No")"

    if [ -n "$PASSWORD" ]; then
        USERNAME=$(echo "$ITEM_JSON" | jq -r '.fields[]? | select(.purpose=="USERNAME") | .value // empty')
        if [ -z "$USERNAME" ]; then
            USERNAME=$(echo "$ITEM_JSON" | jq -r '.fields[]? | select(.label | strings | test("^(username|email)$"; "i")) | .value // empty')
        fi
        log_debug "Username: '$USERNAME'"

        printjs() { js | sed 's,//.*$,,' | tr '\n' ' '; }
        echo "jseval -q $(printjs)" >> "$QUTE_FIFO"
        echo "message-info '1P: Filled credentials for $ITEM_TITLE.'" >> "$QUTE_FIFO"

        TOTP=$(op item get $OP_SESSION_ARGS "$ITEM_ID" --otp 2>/dev/null)
        if [ -n "$TOTP" ]; then
            log_debug "TOTP found."
            if command -v xclip > /dev/null; then
                echo "$TOTP" | xclip -in -selection clipboard
                echo "message-info '1P: Copied OTP for $ITEM_TITLE to clipboard.'" >> "$QUTE_FIFO"
            else
                log_debug "xclip not found."; echo "message-warn '1P: xclip missing for OTP.'" >> "$QUTE_FIFO"
            fi
        fi
    else
        log_debug "No password field for '$ITEM_TITLE' (ID: $ITEM_ID)."
        echo "message-error '1P: No password found for $ITEM_TITLE.'" >> "$QUTE_FIFO"
    fi
elif [ -n "$SELECTED_TITLE" ]; then
    log_debug "Could not find ID for SELECTED_TITLE: '$SELECTED_TITLE'."
    echo "message-error '1P: Could not find ID for \"$SELECTED_TITLE\".'" >> "$QUTE_FIFO"
elif [ -z "$SELECTED_TITLE" ] && [ -n "$URL_HOSTNAME" ]; then
     log_debug "No entry for URL '$URL_HOSTNAME' and no item selected."
     echo "message-error '1P: No entry for $URL_HOSTNAME, none selected.'" >> "$QUTE_FIFO"
else
    log_debug "General failure: No ITEM_ID and no SELECTED_TITLE."
    echo "message-error '1P: Could not determine item.'" >> "$QUTE_FIFO"
fi

log_debug "Script finished."
