#!/bin/sh
# Claude Code statusline. Reads a session JSON object on stdin and prints:
#   line 1:  owner/repo  branch [ worktree] Model ctx N%
#   line 2: 5h <bar> N% <reset-in> [✓ |  100% in <eta>] 7d N% <reset-in> [✓ |  100% in <eta>]
#
# Glyphs are Nerd Font (UDEV Gothic NF):
#    nf-fa-github     repo prefix
#    nf-fa-clock_o    reset-countdown prefix
#    nf-fa-bolt       projected-saturation prefix
#
# JSON schema reference:
#   https://code.claude.com/docs/en/statusline
# Fields used:
#   .model.display_name
#   .context_window.used_percentage        — % of model's context window used
#   .rate_limits.five_hour.used_percentage — 5h rolling rate-limit window (Pro/Max only)
#   .rate_limits.five_hour.resets_at       — unix epoch when window resets
#   .rate_limits.seven_day.{used_percentage,resets_at}
#   .workspace.repo.{owner,name}

input=$(cat)

# Real ESC char. printf "%s" with literal "\033" would emit the backslash sequence
# verbatim, so we materialize the byte once and interpolate it via variables.
esc=$(printf '\033')
reset="${esc}[0m"

# Nerd Font glyphs. Prefer Plane 15 (supplementary PUA, Material Design Icons
# block) because on macOS, parts of the BMP PUA — notably the Font Awesome range
# U+F000–U+F0FF — get claimed by ".Geeza Pro PUA" (an Arabic system font), and
# CoreText prefers that over UDEV Gothic NF, so FA glyphs render as Arabic
# contextual forms. Plane 15 has no such conflict.
# Exception: the Powerline range (U+E0A0) is not claimed by any system font,
# so it resolves to UDEV Gothic NF cleanly — and we use it here to match the
# branch glyph Starship uses by default.
# printf hex escapes also dodge tool round-trip issues with PUA literals.
icon_repo=$(printf '\xf3\xb0\x8a\xa4')     # nf-md-github          (U+F02A4)
icon_branch=$(printf '\xee\x82\xa0')       # nf-pl-branch          (U+E0A0)
icon_worktree=$(printf '\xf3\xb0\x99\x85') # nf-md-file_tree    (U+F0645)
icon_clock=$(printf '\xf3\xb0\x85\x90')    # nf-md-clock_outline   (U+F0150)
icon_bolt=$(printf '\xf3\xb1\x90\x8b')     # nf-md-lightning_bolt  (U+F140B)

# 0-49% green / 50-79% yellow / 80%+ red.
color_for_pct() {
  if [ "$1" -ge 80 ]; then
    printf '%s' "${esc}[31m"
  elif [ "$1" -ge 50 ]; then
    printf '%s' "${esc}[33m"
  else
    printf '%s' "${esc}[32m"
  fi
}

# Humanize a duration in seconds. <1 day → "Xh Ym" (or "Ym" if <1h); >=1 day → "Xd Yh".
fmt_remaining() {
  diff=$1
  if [ "$diff" -le 0 ]; then
    printf '0m'
    return
  fi
  if [ "$diff" -lt 86400 ]; then
    h=$((diff / 3600))
    m=$(((diff % 3600) / 60))
    if [ "$h" -gt 0 ]; then
      printf '%dh%dm' "$h" "$m"
    else
      printf '%dm' "$m"
    fi
  else
    d=$((diff / 86400))
    h=$(((diff % 86400) / 3600))
    printf '%dd%dh' "$d" "$h"
  fi
}

# Linear burn-rate projection: will this rate-limit window hit 100% before it resets?
#
# Assumption: the window started at (resets_at - window_secs) and consumption has been
# uniform since then. We don't know the actual start (the rolling window may have
# begun mid-session), so this is a rough average — accuracy improves later in the
# window when more time has elapsed.
#
# Math:
#   elapsed       = now - (resets_at - window_secs)
#   rate (%/s)    = pct / elapsed
#   secs_to_100   = (100 - pct) / rate
#   if secs_to_100 >= time-until-reset → window resets first → "safe"
#   otherwise → predicted to hit 100% in secs_to_100 seconds → "hit:<secs>"
#
# Shell can only do integer math, so we shell out to awk for the float division.
#
# Outputs:
#   ""              not enough data (elapsed <= 0, or pct <= 0 so rate is undefined)
#   "safe"          projected to stay under 100% until the window resets
#   "hit:<secs>"    projected to hit 100% in <secs> seconds from now
predict_burn() {
  awk -v pct="$1" -v rs="$2" -v ws="$3" -v now="$4" '
    BEGIN {
      start = rs - ws
      elapsed = now - start
      if (elapsed <= 0 || pct <= 0) { print ""; exit }
      rate = pct / elapsed
      remaining_secs = rs - now
      secs_to_100 = (100 - pct) / rate
      if (secs_to_100 >= remaining_secs) {
        print "safe"
      } else {
        printf "hit:%d\n", secs_to_100
      }
    }
  '
}

now=$(date +%s)

model=$(echo "$input" | jq -r '.model.display_name // ""')
# Strip trailing parenthetical qualifier, e.g. "Opus 4.7 (1M context)" → "Opus 4.7"
model=${model% (*}
used=$(echo "$input" | jq -r '.context_window.used_percentage // empty')

# Context window % is shown as a small inline number (no bar) on line 1.
# The bar is reserved for the 5h rate limit on line 2 — that's the more actionable
# constraint, since context can be reset with /compact but rate limits can't.
ctx_info=""
if [ -n "$used" ]; then
  pct=$(printf '%.0f' "$used")
  cc=$(color_for_pct "$pct")
  ctx_info=" ctx ${cc}${pct}%${reset}"
fi

# rate_limits.* is only present for Claude.ai Pro/Max subscribers, and only after
# the first API response in the session. Each window may be independently absent.
five_pct=$(echo "$input" | jq -r '.rate_limits.five_hour.used_percentage // empty')
five_resets=$(echo "$input" | jq -r '.rate_limits.five_hour.resets_at // empty')
seven_pct=$(echo "$input" | jq -r '.rate_limits.seven_day.used_percentage // empty')
seven_resets=$(echo "$input" | jq -r '.rate_limits.seven_day.resets_at // empty')

# 5-hour rate limit segment (with progress bar).
five_info=""
if [ -n "$five_pct" ]; then
  pct5=$(printf '%.0f' "$five_pct")
  # Build a 10-char bar: <filled>█ + <empty>░.
  bar_width=10
  filled=$((pct5 * bar_width / 100))
  empty=$((bar_width - filled))
  bar=""
  i=0
  while [ $i -lt $filled ]; do
    bar="${bar}█"
    i=$((i + 1))
  done
  i=0
  while [ $i -lt $empty ]; do
    bar="${bar}░"
    i=$((i + 1))
  done
  c5=$(color_for_pct "$pct5")
  remaining5=""
  burn5=""
  if [ -n "$five_resets" ]; then
    remaining5=" ${icon_clock} $(fmt_remaining $((five_resets - now)))"
    # 18000 = 5h in seconds
    p=$(predict_burn "$five_pct" "$five_resets" 18000 "$now")
    case "$p" in
    safe) burn5=" ${esc}[32m✓${reset}" ;;
    # ${p#hit:} strips the "hit:" prefix, leaving just the seconds count
    hit:*) burn5=" ${esc}[31m${icon_bolt} 100% in $(fmt_remaining "${p#hit:}")${reset}" ;;
    esac
  fi
  five_info=" 5h ${c5}${bar}${reset} ${pct5}%${remaining5}${burn5}"
fi

# 7-day rate limit segment (no bar — slow-moving, less useful to visualize).
seven_info=""
if [ -n "$seven_pct" ]; then
  pct7=$(printf '%.0f' "$seven_pct")
  c7=$(color_for_pct "$pct7")
  remaining7=""
  burn7=""
  if [ -n "$seven_resets" ]; then
    remaining7=" ${icon_clock} $(fmt_remaining $((seven_resets - now)))"
    # 604800 = 7d in seconds
    p=$(predict_burn "$seven_pct" "$seven_resets" 604800 "$now")
    case "$p" in
    safe) burn7=" ${esc}[32m✓${reset}" ;;
    hit:*) burn7=" ${esc}[31m${icon_bolt} 100% in $(fmt_remaining "${p#hit:}")${reset}" ;;
    esac
  fi
  seven_info=" 7d ${c7}${pct7}%${reset}${remaining7}${burn7}"
fi

repo=$(echo "$input" | jq -r '.workspace.repo | if . then .owner + "/" + .name else empty end')
cwd=$(echo "$input" | jq -r '.workspace.current_dir // .cwd // empty')
branch=""
worktree=""
if [ -n "$cwd" ]; then
  branch=$(git -C "$cwd" branch --show-current 2>/dev/null)
  # Detect a linked git worktree. In the main working tree, --git-dir and
  # --git-common-dir resolve to the same path; in a linked worktree, --git-dir
  # points at .git/worktrees/<name> while --git-common-dir points at the shared
  # .git, so the two diverge. When they do, label it with the worktree's
  # top-level directory name.
  git_dir=$(git -C "$cwd" rev-parse --git-dir 2>/dev/null)
  common_dir=$(git -C "$cwd" rev-parse --git-common-dir 2>/dev/null)
  if [ -n "$git_dir" ] && [ "$git_dir" != "$common_dir" ]; then
    toplevel=$(git -C "$cwd" rev-parse --show-toplevel 2>/dev/null)
    [ -n "$toplevel" ] && worktree=$(basename "$toplevel")
  fi
fi

repo_info=""
prefix=""
[ -n "$repo" ] && prefix="${icon_repo} $repo"
[ -n "$branch" ] && prefix="${prefix:+$prefix }${icon_branch} $branch"
[ -n "$worktree" ] && prefix="${prefix:+$prefix }${esc}[36m${icon_worktree} ${worktree}${reset}"
[ -n "$prefix" ] && repo_info="${prefix} "

# Line 1: repo + model + ctx
printf "%s${esc}[33m%s${reset}%s" "$repo_info" "$model" "$ctx_info"

# Line 2: rate limit windows. Each segment is built with a leading space separator
# so they concatenate cleanly; we strip the leading separator before printing.
usage_line="${five_info}${seven_info}"
if [ -n "$usage_line" ]; then
  usage_line=${usage_line# }
  printf "\n%s" "$usage_line"
fi
