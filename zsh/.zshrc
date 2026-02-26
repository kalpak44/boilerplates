# ============================================================
# Custom CLI helpers
# Location: ~/.zshrc  (consider moving into ~/.zsh/functions/)
#
# Conventions:
# - Every function has a short header:
#     # @desc: one-line description
#     # @usage: how to call it
#     # @example: concrete example(s)
# - Prefer return codes:
#     0 success, 1+ error
# ============================================================

# Print a formatted error message to stderr
_err() { print -u2 -- "❌ $*"; }

# Print a formatted info message
_info() { print -- "✅ $*"; }

# Check if a command exists
_has() { command -v "$1" >/dev/null 2>&1; }

# List your custom functions with their @desc lines
# Usage: zhelp
zhelp() {
  local file="${ZDOTDIR:-$HOME}/.zshrc"
  echo "Custom helpers in: $file"
  echo "----------------------------------------"
  # naive parser: finds lines like "fname() {" and the next "# @desc:"
  awk '
    /^[a-zA-Z0-9._-]+\(\)[[:space:]]*\{/ { fn=$0; sub(/\(\).*/, "", fn); desc=""; next }
    /^[[:space:]]*#[[:space:]]*@desc:/ { desc=$0; sub(/.*@desc:[[:space:]]*/, "", desc); if (fn!="") print fn " - " desc }
  ' "$file" 2>/dev/null | sort
}
