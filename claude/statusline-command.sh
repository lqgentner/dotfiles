#!/bin/bash
# Claude Code status line - Catppuccin Mocha theme
# Line: ✽ <model> │ 󰉋 <dir> │  <branch>[!] │  <context%> · <tokens> tokens

input=$(cat)

# ---- Catppuccin Mocha palette (RGB) ----
white='255;255;255'
sapphire='116;199;236'
lavender='180;190;254'
mauve='203;166;247'
blue='137;180;250'
green='166;227;161'
yellow='249;226;175'
peach='250;179;135'
red='243;139;168'
overlay0='108;112;134'
overlay1='127;132;156'
subtext0='166;173;200'

fg() { printf '\033[38;2;%sm' "$1"; }
dim=$'\033[2m'
reset=$'\033[0m'

sep=" ${dim}$(fg "$overlay0")│${reset} "

# ---- Parse fields from stdin JSON ----
model=$(echo "$input" | jq -r '.model.display_name // "Claude"')
cwd=$(echo "$input" | jq -r '.workspace.current_dir // .cwd')
dirname=$(basename "$cwd")

# ---- Git branch + dirty state (skip optional locks) ----
git_seg=""
if git -C "$cwd" --no-optional-locks rev-parse --is-inside-work-tree >/dev/null 2>&1; then
  branch=$(git -C "$cwd" --no-optional-locks rev-parse --abbrev-ref HEAD 2>/dev/null)
  if [ -n "$branch" ]; then
    if [ -n "$(git -C "$cwd" --no-optional-locks status --porcelain 2>/dev/null)" ]; then
      dirty_mark=" !"
    else
      dirty_mark=""
    fi
    git_seg="$(fg "$lavender") ${branch}${dirty_mark}${reset}"
  fi
fi

# ---- Context window usage ----
ctx_seg=""
used_pct=$(echo "$input" | jq -r '.context_window.used_percentage // empty')
total_tokens=$(echo "$input" | jq -r '.context_window.total_input_tokens // empty')

if [ -n "$used_pct" ] && [ -n "$total_tokens" ]; then
  pct_fmt=$(awk -v n="$used_pct" 'BEGIN{printf "%.1f", n}')
  tok_fmt=$(awk -v n="$total_tokens" 'BEGIN{
    if (n >= 1000) printf "%.1fk", n/1000;
    else printf "%d", n;
  }')

  ctx_color=$(awk -v n="$used_pct" -v g="$green" -v y="$yellow" -v p="$peach" -v r="$red" 'BEGIN{
    if (n < 50) print g;
    else if (n < 80) print y;
    else if (n <= 100) print p;
    else print r;
  }')

  ctx_seg="$(fg "$ctx_color") ${pct_fmt}%${reset} ${dim}$(fg "$subtext0")· ${tok_fmt} tokens${reset}"
fi

# ---- Assemble ----
line="$(fg "$white")✽ ${model}${reset}"
line="${line}${sep}$(fg "$sapphire")󰉋 ${dirname}${reset}"
[ -n "$git_seg" ] && line="${line}${sep}${git_seg}"
[ -n "$ctx_seg" ] && line="${line}${sep}${ctx_seg}"

printf '%s' "$line"
