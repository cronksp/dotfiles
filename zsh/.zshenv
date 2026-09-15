# -------------------------------------------------------------------
# ~/.zshenv
# User environment variables
# -------------------------------------------------------------------

# Initialize Rust / Cargo if present
if [ -f "$HOME/.cargo/env" ]; then
    . "$HOME/.cargo/env"
fi
