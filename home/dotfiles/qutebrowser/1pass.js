#!/usr/bin/env bash

set +e # Keep this, as rofi can be cancelled

# JS field injection code
javascript_escape() {
    # print the first argument in an escaped way, such that it can safely
    # be used within javascripts double quotes
    # shellcheck disable=SC2001
    sed "s,[\\\\'\"\/],\\\\&,g" <<< "$1"
}

js() {
cat <<EOF
    function isVisible(elem) {
        if (!elem) return false; // Prevent errors if elem is null
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
            var input = inputs[j];
            if (input.type == "password") {
                return true;
            }
        }
        return false;
    };
    function loadData2Form (form) {
        if (!form) return;
        var inputs = form.getElementsByTagName("input");
        var username_filled = false;
        for (var j = 0; j < inputs.length; j++) {
            var input = inputs[j];
            // Try to fill username only once, in the first suitable field
            if (!username_filled && isVisible(input) && (input.type == "text" || input.type == "email" || input.type == "tel" || input.type == "url" || input.type == "number")) {
                input.focus();
                input.value = "$(javascript_escape "${USERNAME}")";
                input.dispatchEvent(new Event('change', { bubbles: true }));
                input.blur();
                username_filled = true; // Mark as filled
            }
            if (input.type == "password" && isVisible(input)) {
                input.focus();
                input.value = "$(javascript_escape "${PASSWORD}")";
                input.dispatchEvent(new Event('change', { bubbles: true }));
                input.blur();
            }
        }
    };
    var forms = document.getElementsByTagName("form");
    if("$(javascript_escape "${QUTE_URL}")" == window.location.href) {
        var form_to_fill = null;
        // Prioritize forms with password fields
        for (var i = 0; i < forms.length; i++) {
            if (hasPasswordField(forms[i])) {
                form_to_fill = forms[i];
                break;
            }
        }
        // If no form with password field, take the first form (if any)
        if (!form_to_fill && forms.length > 0) {
            form_to_fill = forms[0];
        }

        if (form_to_fill) {
            loadData2Form(form_to_fill);
        } else if (document.body) { // Fallback for pages without forms but with input fields
            var inputs = document.getElementsByTagName("input");
            var username_filled = false;
            for (var j = 0; j < inputs.length; j++) {
                var input = inputs[j];
                if (!username_filled && isVisible(input) && (input.type == "text" || input.type == "email")) {
                     input.focus();
                     input.value = "$(javascript_escape "${USERNAME}")";
                     input.dispatchEvent(new Event('change', { bubbles: true }));
                     input.blur();
                     username_filled = true;
                }
                if (input.type == "password" && isVisible(input)) {
                     input.focus();
                     input.value = "$(javascript_escape "${PASSWORD}")";
                     input.dispatchEvent(new Event('change', { bubbles: true }));
                     input.blur();
                }
            }
        }
    } else {
        alert("Secrets will not be inserted.\\nUrl of this page (" + window.location.href + ") and the one where the user script was started (" + "$(javascript_escape "${QUTE_URL}")" + ") differ.");
    }
EOF
}

# --- Debug Log Setup ---
DEBUG_LOG_FILE="/tmp/qute_1p_debug.log"
echo "--- New 1Password Script Run $(date) ---" > "$DEBUG_LOG_FILE"
exec > >(tee -a "$DEBUG_LOG_FILE") 2>&1 # Redirect stdout/stderr to log file and terminal

log_debug() {
    echo "DEBUG: $1" # Will go to the log file via exec
}

if [ -z "$QUTE_FIFO" ]; then echo "Error: QUTE_FIFO not set." >&2; exit 1; fi
if [ -z "$QUTE_URL" ]; then echo "message-error 'QUTE_URL not set.'" >> "$QUTE_FIFO"; exit 1; fi

URL_HOSTNAME=$(echo "$QUTE_URL" | awk -F/ '{print $3}' | sed 's/^www\.//g')
TOKEN_TMPDIR="${TMPDIR:-/tmp}"
TOKEN_CACHE="$TOKEN_TMPDIR/1password-session.token"

log_debug "QUTE_URL is '$QUTE_URL'"
log_debug "URL_HOSTNAME is '$URL_HOSTNAME'"
echo "message-info '1Password: Looking for credentials for $URL_HOSTNAME...'" >> "$QUTE_FIFO"

# --- Authentication Logic ---
OP_SESSION_ARGS=""

if op whoami > /dev/null 2>&1; then
    log_debug "Using existing session (Desktop App integration)."
    echo "message-info '1Password: Using existing session (Desktop App integration).'" >> "$QUTE_FIFO"
else
    log_debug "Desktop App integration not active or app locked. Trying cached token..."
    echo "message-info '1Password: Desktop App integration not available/locked. Trying cached token...'" >> "$QUTE_FIFO"
    if [ -f "$TOKEN_CACHE" ]; then
        CACHED_TOKEN=$(cat "$TOKEN_CACHE")
        if op whoami --session="$CACHED_TOKEN" > /dev/null 2>&1; then
            log_debug "Using cached session token."
            echo "message-info '1Password: Using cached session token.'" >> "$QUTE_FIFO"
            OP_SESSION_ARGS="--session=$CACHED_TOKEN"
        else
            log_debug "Cached token invalid/expired."
            echo "message-info '1Password: Cached token invalid.'" >> "$QUTE_FIFO"
            > "$TOKEN_CACHE" 
        fi
    fi

    if [ -z "$OP_SESSION_ARGS" ]; then
        log_debug "No active session. Prompting for master password..."
        echo "message-info '1Password: No active session. Prompting for master password...'" >> "$QUTE_FIFO"
        if ! command -v rofi > /dev/null; then
            echo "message-error '1Password: rofi is not installed.'" >> "$QUTE_FIFO"; exit 1;
        fi
        
        MASTER_PASSWORD=$(rofi -dmenu -password -p "1Password Master Password: " -mesg "Enter master password for 1Password")
        if [ -z "$MASTER_PASSWORD" ]; then
            log_debug "Master password entry cancelled."
            echo "message-error '1Password: Master password entry cancelled.'" >> "$QUTE_FIFO"; exit 1;
        fi
        
        log_debug "Attempting op signin --raw"
        # Add your 1Password account shorthand if you have multiple accounts
        NEW_TOKEN=$(echo "$MASTER_PASSWORD" | op signin --raw 2>/dev/null) 

        if [ -n "$NEW_TOKEN" ]; then
            log_debug "op signin --raw successful. New token obtained."
            install -m 600 /dev/null "$TOKEN_CACHE"
            echo "$NEW_TOKEN" > "$TOKEN_CACHE"
            OP_SESSION_ARGS="--session=$NEW_TOKEN"
            echo "message-info '1Password: Successfully authenticated via master password and cached token.'" >> "$QUTE_FIFO"
        else
            log_debug "op signin --raw did not return a token. Checking if app integration became active."
            if op whoami > /dev/null 2>&1; then
                 log_debug "Desktop App integration became active after password entry. Using it."
                 echo "message-info '1Password: Desktop App integration became active after password entry.'" >> "$QUTE_FIFO"
            else
                log_debug "Authentication failed. Invalid master password OR Desktop App Integration ON and app still locked."
                echo "message-error '1Password: Authentication failed. Invalid master password OR Desktop App Integration is ON (preventing --raw token) and app is still locked.'" >> "$QUTE_FIFO"
                [ -f "$TOKEN_CACHE" ] && > "$TOKEN_CACHE"
                exit 1
            fi
        fi
    fi
fi
log_debug "OP_SESSION_ARGS is '$OP_SESSION_ARGS'"
# --- End Authentication Logic ---

log_debug "Searching for item by URL: $URL_HOSTNAME"
ITEM_ID=$(op item list $OP_SESSION_ARGS --format json | \
          jq --arg url_hostname "$URL_HOSTNAME" -r \
          '(.[] | select(.urls[].href | strings | test("(?i)" + $url_hostname))) | .id | first')
log_debug "ITEM_ID after URL search: '$ITEM_ID'"

if [ -z "$ITEM_ID" ]; then
    log_debug "No exact URL match. Searching by title..."
    echo "message-info '1Password: No exact URL match for $URL_HOSTNAME. Searching by title...'" >> "$QUTE_FIFO"
    if ! command -v rofi > /dev/null; then echo "message-error '1Password: rofi not installed.'" >> "$QUTE_FIFO"; exit 1; fi
    
    ROFI_INPUT_CMD="op item list $OP_SESSION_ARGS --format json | jq -r 'map(.title) | .[]'"
    log_debug "Rofi input command: $ROFI_INPUT_CMD"
    ROFI_INPUT_DATA=$(eval "$ROFI_INPUT_CMD")
    log_debug "Data piped to rofi (first 10 lines):"
    echo "$ROFI_INPUT_DATA" | head -n 10 # Log only first few lines to keep log manageable

    SELECTED_TITLE=$(echo "$ROFI_INPUT_DATA" | \
                     rofi -dmenu -i -p "1Password (select item for $URL_HOSTNAME): ")
    log_debug "SELECTED_TITLE from rofi: '$SELECTED_TITLE'"
    
    if [ -n "$SELECTED_TITLE" ]; then
        log_debug "Attempting to get ID for title: '$SELECTED_TITLE'"
        # Use case-insensitive title matching and test() for robustness
        # Also ensure we are looking for string equality after lowercasing
        OP_LIST_JSON_FOR_ID_BY_TITLE=$(op item list $OP_SESSION_ARGS --format json)
        # For detailed debugging of this specific jq query, uncomment the next two lines
        # log_debug "Full op item list JSON for title search:"
        # echo "$OP_LIST_JSON_FOR_ID_BY_TITLE" # This can be very large

        ITEM_ID=$(echo "$OP_LIST_JSON_FOR_ID_BY_TITLE" | \
                  jq --argneedle "$(echo "$SELECTED_TITLE" | tr '[:upper:]' '[:lower:]')" -r \
                  '(.[] | select(.title | ascii_downcase | contains($needle))) | .id | first ')
        
        # If the above `contains` is too broad (e.g. "Google" matches "Google Mail"), use exact match after lowercasing:
        # ITEM_ID=$(echo "$OP_LIST_JSON_FOR_ID_BY_TITLE" | \
        #           jq --arg selected_title_lower "$(echo "$SELECTED_TITLE" | tr '[:upper:]' '[:lower:]')" -r \
        #           '(.[] | select(.title | ascii_downcase == $selected_title_lower)) | .id')

        log_debug "ITEM_ID after title search ('$SELECTED_TITLE'): '$ITEM_ID'"
    else
        log_debug "Item selection cancelled via rofi."
        echo "message-info '1Password: Item selection cancelled.'" >> "$QUTE_FIFO"
    fi
fi

if [ -n "$ITEM_ID" ]; then
    log_debug "Fetching item details for ITEM_ID: '$ITEM_ID'"
    ITEM_JSON=$(op item get $OP_SESSION_ARGS "$ITEM_ID" --format json)
    # For detailed debugging, uncomment:
    # log_debug "ITEM_JSON:"
    # echo "$ITEM_JSON"

    if [ -z "$ITEM_JSON" ] || [ "$(echo "$ITEM_JSON" | jq -e . 2>/dev/null)" != "true" ]; then # check if empty or not valid json
        log_debug "Failed to retrieve valid JSON for item ID '$ITEM_ID'. ITEM_JSON was: $ITEM_JSON"
        echo "message-error '1Password: Failed to retrieve item details for ID $ITEM_ID.'" >> "$QUTE_FIFO"; exit 1;
    fi

    PASSWORD=$(echo "$ITEM_JSON" | jq -r '.fields[]? | select(.purpose=="PASSWORD") | .value // empty')
    ITEM_TITLE=$(echo "$ITEM_JSON" | jq -r '.title // "Item"') # Use title from the fetched item
    log_debug "Item Title from fetched JSON: '$ITEM_TITLE', Password found: $([ -n "$PASSWORD" ] && echo "Yes" || echo "No")"


    if [ -n "$PASSWORD" ]; then
        USERNAME=$(echo "$ITEM_JSON" | jq -r '.fields[]? | select(.purpose=="USERNAME") | .value // empty')
        if [ -z "$USERNAME" ]; then
            USERNAME=$(echo "$ITEM_JSON" | jq -r '.fields[]? | select(.label=="username" or .label=="Username" or .label=="email" or .label=="Email") | .value ')
        fi
        log_debug "Username: '$USERNAME'"

        printjs() { js | sed 's,//.*$,,' | tr '\n' ' '; }
        echo "jseval -q $(printjs)" >> "$QUTE_FIFO"
        echo "message-info '1Password: Filled credentials for $ITEM_TITLE.'" >> "$QUTE_FIFO"

        TOTP=$(op item get $OP_SESSION_ARGS "$ITEM_ID" --otp 2>/dev/null)
        if [ -n "$TOTP" ]; then
            log_debug "TOTP found: '$TOTP'"
            if command -v xclip > /dev/null; then
                echo "$TOTP" | xclip -in -selection clipboard
                echo "message-info '1Password: Copied OTP for $ITEM_TITLE to clipboard.'" >> "$QUTE_FIFO"
            else
                log_debug "xclip not found. Cannot copy OTP."
                echo "message-warn '1Password: xclip not found. Cannot copy OTP.'" >> "$QUTE_FIFO"
            fi
        else
            log_debug "No TOTP found for item '$ITEM_TITLE'."
        fi
    else
        log_debug "No password field found for item '$ITEM_TITLE' (ID: $ITEM_ID)."
        echo "message-error '1Password: No password field found for $ITEM_TITLE.'" >> "$QUTE_FIFO"
    fi
elif [ -n "$SELECTED_TITLE" ]; then # This means ITEM_ID was empty after title search
    log_debug "Could not find ID for SELECTED_TITLE: '$SELECTED_TITLE'."
    echo "message-error '1Password: Could not find ID for \"$SELECTED_TITLE\".'" >> "$QUTE_FIFO"
elif [ -z "$SELECTED_TITLE" ] && [ -n "$URL_HOSTNAME" ]; then # URL search failed, and rofi selection was skipped/cancelled
     log_debug "No entry found for URL '$URL_HOSTNAME' and no item selected via rofi."
     echo "message-error '1Password: No entry found for $URL_HOSTNAME and no item selected.'" >> "$QUTE_FIFO"
else
    log_debug "General failure: No ITEM_ID and no SELECTED_TITLE. This case should ideally not be reached if URL_HOSTNAME was set."
    echo "message-error '1Password: Could not determine an item to retrieve.'" >> "$QUTE_FIFO"

fi

log_debug "Script finished."
