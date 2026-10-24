#!/bin/bash
# Claude Code status line: dir | git branch | model | effort | context tokens | rate limits
input=$(cat)

# ANSI colors
R=$'\e[0m'; DIM=$'\e[2m'; CYAN=$'\e[36m'; MAG=$'\e[35m'; YEL=$'\e[33m'; GRN=$'\e[32m'; RED=$'\e[31m'; BLU=$'\e[34m'

color_pct() {  # colorize a percentage: green <50, yellow <80, red >=80
  local p=${1%.*}; p=${p:-0}
  if   [ "$p" -ge 80 ]; then printf '%s' "$RED"
  elif [ "$p" -ge 50 ]; then printf '%s' "$YEL"
  else                        printf '%s' "$GRN"; fi
}
fmt_k() {  # 123456 -> 123k
  local n=${1:-0}
  if   [ "$n" -ge 1000000 ]; then printf '%dm' $((n / 1000000))
  elif [ "$n" -ge 1000 ];    then printf '%dk' $((n / 1000))
  else                            printf '%d' "$n"; fi
}

IFS=$'\t' read -r DIR MODEL EFFORT USED SIZE PCT FIVE FIVE_RESET SEVEN SEVEN_RESET <<< "$(echo "$input" | jq -r '
  [ .workspace.current_dir,
    .model.display_name,
    (.effort.level // "-"),
    (.context_window.total_input_tokens // 0),
    (.context_window.context_window_size // 0),
    (.context_window.used_percentage // 0 | floor),
    (.rate_limits.five_hour.used_percentage // "-" | if type=="number" then floor else . end),
    (.rate_limits.five_hour.resets_at // "-"),
    (.rate_limits.seven_day.used_percentage // "-" | if type=="number" then floor else . end),
    (.rate_limits.seven_day.resets_at // "-")
  ] | map(tostring) | @tsv')"

# Directory, with ~ for home
DISP_DIR=${DIR/#$HOME/\~}

# Git branch (only if inside a repo)
BRANCH=""
if git -C "$DIR" rev-parse --is-inside-work-tree >/dev/null 2>&1; then
  BRANCH=$(git -C "$DIR" symbolic-ref --short HEAD 2>/dev/null || git -C "$DIR" rev-parse --short HEAD 2>/dev/null)
  DIRTY=""
  [ -n "$(git -C "$DIR" status --porcelain 2>/dev/null | head -1)" ] && DIRTY="*"
fi

reset_in() {  # epoch -> "2h" remaining
  local t=$1 now d h
  [ "$t" = "-" ] && return
  now=$(date +%s); d=$((t - now)); [ "$d" -lt 0 ] && d=0
  h=$((d / 3600))
  if [ "$h" -ge 24 ]; then printf '%dd%dh' $((h / 24)) $((h % 24)); else printf '%dh' "$h"; fi
}

out="${CYAN}${DISP_DIR}${R}"
[ -n "$BRANCH" ] && out+=" ${DIM}on${R} ${MAG}${BRANCH}${DIRTY}${R}"
out+=" ${DIM}|${R} ${BLU}${MODEL}${R}"
[ "$EFFORT" != "-" ] && out+=" ${DIM}(${EFFORT})${R}"
out+=" ${DIM}|${R} ctx $(color_pct "$PCT")${PCT}%${R} ${DIM}$(fmt_k "$USED")/$(fmt_k "$SIZE")${R}"
if [ "$FIVE" != "-" ] || [ "$SEVEN" != "-" ]; then
  out+=" ${DIM}|${R}"
  [ "$FIVE"  != "-" ] && out+=" 5h $(color_pct "$FIVE")${FIVE}%${R}${DIM}($(reset_in "$FIVE_RESET"))${R}"
  [ "$SEVEN" != "-" ] && out+=" 7d $(color_pct "$SEVEN")${SEVEN}%${R}${DIM}($(reset_in "$SEVEN_RESET"))${R}"
fi
printf '%s\n' "$out"
