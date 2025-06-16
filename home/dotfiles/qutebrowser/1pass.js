#!/usr/bin/env bash

set +e # Keep this, as rofi can be cancelled

# JS field injection code
javascript_escape() {
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
    };
    var forms = document.getElementsByTagName("form");
    if("$(javascript_escape "${QUTE_URL}")" == window.location.href) {
        var form_to_fill = null;
        for (var i = 0; i < forms.length; i++) {
            if (hasPasswordField(forms[i])) {
                form_to_fill = forms[i];
                break;
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

if [ -z "$QUTE_FIFO" ]; then echo "Error: QUTE_FIFO not set." >&2; exit 1; fi
if [ -z "$QUTE_URL" ]; then echo "message-error 'QUTE_URL not set.'" >> "$QUTE_FIFO"; exit 1; fi

URL_HOSTNAME=$(echo "$QUTE_URL" | awk -F/ '{print $3}' | sed 's/^www\.//g')
TOKEN_TMPDIR="${TMPDIR:-/tmp}"
TOKEN_CACHE="$TOKEN_TMPDIR/1password-session.token"

echo "message-info '1Password: Looking for credentials for $URL_HOSTNAME...'" >> "$QUTE_FIFO"

# --- Authentication Logic ---
OP_SESSION_ARGS="" # Will be empty or "--session <token>"

# 1. Try to use Desktop App Integration (no explicit token needed for op commands)
#    `op whoami` is a lightweight command to check if a session is active.
if op whoami > /dev/null 2>&1; then
    echo "message-info '1Password: Using existing session (likely via Desktop App integration).'" >> "$QUTE_FIFO"
    # OP_SESSION_ARGS remains empty; op commands will use the integrated session.
else
    # 2. Desktop App integration not active/available, or app is locked. Try cached token.
    echo "message-info '1Password: Desktop App integration not available or app locked. Trying cached token...'" >> "$QUTE_FIFO"
    if [ -f "$TOKEN_CACHE" ]; then
        CACHED_TOKEN=$(cat "$TOKEN_CACHE")
        if op whoami --session="$CACHED_TOKEN" > /dev/null 2>&1; then
            echo "message-info '1Password: Using cached session token.'" >> "$QUTE_FIFO"
            OP_SESSION_ARGS="--session=$CACHED_TOKEN"
        else
            echo "message-info '1Password: Cached token invalid.'" >> "$QUTE_FIFO"
            # Invalidate bad cached token by removing it or clearing it
            > "$TOKEN_CACHE" 
        fi
    fi

    # 3. If still no active session (App integration failed AND cached token failed/absent),
    #    prompt for master password.
    if [ -z "$OP_SESSION_ARGS" ]; then # Only prompt if we don't have a session method yet
        echo "message-info '1Password: No active session. Prompting for master password...'" >> "$QUTE_FIFO"
        if ! command -v rofi > /dev/null; then
            echo "message-error '1Password: rofi is not installed.'" >> "$QUTE_FIFO"; exit 1;
        fi
        
        MASTER_PASSWORD=$(rofi -dmenu -password -p "1Password Master Password: " -mesg "Enter master password for 1Password")
        if [ -z "$MASTER_PASSWORD" ]; then
            echo "message-error '1Password: Master password entry cancelled.'" >> "$QUTE_FIFO"; exit 1;
        fi
        
        # Attempt to sign in and get a raw token.
        # This will ONLY work if app integration is OFF.
        # If app integration is ON, --raw might still return empty even with correct password.
        # Add your 1Password account shorthand if you have multiple accounts, e.g., op signin myaccount --raw
        NEW_TOKEN=$(echo "$MASTER_PASSWORD" | op signin --raw 2>/dev/null) 

        if [ -n "$NEW_TOKEN" ]; then
            install -m 600 /dev/null "$TOKEN_CACHE"
            echo "$NEW_TOKEN" > "$TOKEN_CACHE"
            OP_SESSION_ARGS="--session=$NEW_TOKEN"
            echo "message-info '1Password: Successfully authenticated via master password and cached token.'" >> "$QUTE_FIFO"
        else
            # If NEW_TOKEN is empty after password entry, it's either:
            # - Wrong master password.
            # - OR Desktop App Integration is ON (and `op signin --raw` doesn't output).
            # Let's re-check if `op whoami` works *now* (maybe password unlocked the app).
            if op whoami > /dev/null 2>&1; then
                 echo "message-info '1Password: Desktop App integration became active after password entry. Using it.'" >> "$QUTE_FIFO"
                 # OP_SESSION_ARGS remains empty
            else
                echo "message-error '1Password: Authentication failed. Invalid master password OR Desktop App Integration is ON (preventing --raw token) and app is still locked.'" >> "$QUTE_FIFO"
                # It's safest to clear the cache if auth failed this hard
                [ -f "$TOKEN_CACHE" ] && > "$TOKEN_CACHE"
                exit 1
            fi
        fi
    fi
fi
# --- End Authentication Logic ---

# Now, use $OP_SESSION_ARGS for all op commands
# e.g., op item list $OP_SESSION_ARGS ...

ITEM_ID=$(op item list $OP_SESSION_ARGS --format json | \
          jq --arg url_hostname "$URL_HOSTNAME" -r \
          '(.[] | select(.urls[].href | strings | test("(?i)" + $url_hostname))) | .id | first // empty')

if [ -z "$ITEM_ID" ]; then
    echo "message-info '1Password: No exact URL match for $URL_HOSTNAME. Searching by title...'" >> "$QUTE_FIFO"
    if ! command -v rofi > /dev/null; then echo "message-error '1Password: rofi not installed.'" >> "$QUTE_FIFO"; exit 1; fi
    SELECTED_TITLE=$(op item list $OP_SESSION_ARGS --format json | \
                     jq -r 'map(.title) | .[]' | \
                     rofi -dmenu -i -p "1Password (select item for $URL_HOSTNAME): ")
    
    if [ -n "$SELECTED_TITLE" ]; then
        ITEM_ID=$(op item list $OP_SESSION_ARGS --format json | \
                  jq --arg title "$SELECTED_TITLE" -r \
                  '(.[] | select(.title == $title)) | .id | first // empty')
    else
        echo "message-info '1Password: Item selection cancelled.'" >> "$QUTE_FIFO"
    fi
fi

if [ -n "$ITEM_ID" ]; then
    ITEM_JSON=$(op item get $OP_SESSION_ARGS "$ITEM_ID" --format json)
    if [ -z "$ITEM_JSON" ]; then
        echo "message-error '1Password: Failed to retrieve item $ITEM_ID.'" >> "$QUTE_FIFO"; exit 1;
    fi

    PASSWORD=$(echo "$ITEM_JSON" | jq -r '.fields[]? | select(.purpose=="PASSWORD") | .value // empty')
    ITEM_TITLE=$(echo "$ITEM_JSON" | jq -r '.title // "Item"')

    if [ -n "$PASSWORD" ]; then
        USERNAME=$(echo "$ITEM_JSON" | jq -r '.fields[]? | select(.purpose=="USERNAME") | .value // empty')
        if [ -z "$USERNAME" ]; then
            USERNAME=$(echo "$ITEM_JSON" | jq -r '.fields[]? | select(.label=="username" or .label=="Username" or .label=="email" or .label=="Email") | .value // empty')
        fi

        printjs() { js | sed 's,//.*$,,' | tr '\n' ' '; }
        echo "jseval -q $(printjs)" >> "$QUTE_FIFO"
        echo "message-info '1Password: Filled credentials for $ITEM_TITLE.'" >> "$QUTE_FIFO"

        TOTP=$(op item get $OP_SESSION_ARGS "$ITEM_ID" --otp 2>/dev/null)
        if [ -n "$TOTP" ]; then
            if command -v xclip > /dev/null; then
                echo "$TOTP" | xclip -in -selection clipboard
                echo "message-info '1Password: Copied OTP for $ITEM_TITLE to clipboard.'" >> "$QUTE_FIFO"
            else
                echo "message-warn '1Password: xclip not found. Cannot copy OTP.'" >> "$QUTE_FIFO"
            fi
        fi
    else
        echo "message-error '1Password: No password field found for $ITEM_TITLE.'" >> "$QUTE_FIFO"
    fi
elif [ -n "$SELECTED_TITLE" ]; then
    echo "message-error '1Password: Could not find ID for \"$SELECTED_TITLE\".'" >> "$QUTE_FIFO"
elif [ -z "$SELECTED_TITLE" ] && [ -n "$URL_HOSTNAME" ]; then
     echo "message-error '1Password: No entry found for $URL_HOSTNAME and no item selected.'" >> "$QUTE_FIFO"
fi

