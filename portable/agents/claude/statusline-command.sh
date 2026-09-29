#!/bin/bash
# Claude Code statusLine.
# Segments: model · effort | dir | git branch + dirty counts | subagents | session
# Palette follows the Powerlevel10k "lean" colors from ~/.p10k.zsh.

C_RESET=$'\033[0m'
C_DIM=$'\033[38;5;244m'
C_MODEL=$'\033[38;5;39m'
C_EFFORT=$'\033[38;5;170m'
C_DIR=$'\033[1;38;5;31m'
C_CLEAN=$'\033[38;5;76m'
C_DIRTY=$'\033[38;5;178m'
C_ADD=$'\033[38;5;76m'
C_DEL=$'\033[38;5;167m'
C_AGENT=$'\033[38;5;214m'
C_FAST=$'\033[1;38;5;220m'
C_RATE=$'\033[38;5;244m'
C_RATE_WARN=$'\033[38;5;178m'
C_RATE_CRIT=$'\033[38;5;167m'

input=$(cat)

IFS=$'\037' read -r model effort fast dir session transcript five_hour seven_day < <(
  printf '%s' "$input" | jq -r '[
    (.model.display_name // "?"),
    (.effort.level // ""),
    (if .fast_mode then "fast" else "" end),
    (.workspace.current_dir // .cwd // "."),
    (.session_id // ""),
    (.transcript_path // ""),
    (.rate_limits.five_hour.used_percentage // ""),
    (.rate_limits.seven_day.used_percentage // "")
  ] | join("\u001f")'
)

# --- model + effort ---
seg_model="${C_MODEL}${model}${C_RESET}"
[ -n "$effort" ] && seg_model+=" ${C_EFFORT}${effort}${C_RESET}"
[ -n "$fast" ] && seg_model+=" ${C_FAST}⚡${fast}${C_RESET}"

# --- directory ---
TILDE="~"
seg_dir="${C_DIR}${dir/#$HOME/$TILDE}${C_RESET}"

# --- git ---
seg_git=""
if git --no-optional-locks -C "$dir" rev-parse --is-inside-work-tree >/dev/null 2>&1; then
  branch=$(git --no-optional-locks -C "$dir" symbolic-ref --quiet --short HEAD 2>/dev/null) \
    || branch=$(git --no-optional-locks -C "$dir" rev-parse --short HEAD 2>/dev/null)
  porcelain=$(git --no-optional-locks -C "$dir" status --porcelain 2>/dev/null)
  changed=$(printf '%s' "$porcelain" | grep -c '^[^?]')
  untracked=$(printf '%s' "$porcelain" | grep -c '^??')

  if [ "$changed" -gt 0 ] || [ "$untracked" -gt 0 ]; then
    seg_git="${C_DIRTY}${branch}${C_RESET}"
    [ "$changed" -gt 0 ] && seg_git+=" ${C_DIRTY}*${changed}${C_RESET}"
    [ "$untracked" -gt 0 ] && seg_git+=" ${C_DIM}?${untracked}${C_RESET}"
    stat=$(git --no-optional-locks -C "$dir" diff --shortstat HEAD 2>/dev/null)
    ins=$(printf '%s' "$stat" | sed -n 's/.*[^0-9]\([0-9]\{1,\}\) insertion.*/\1/p')
    del=$(printf '%s' "$stat" | sed -n 's/.*[^0-9]\([0-9]\{1,\}\) deletion.*/\1/p')
    [ -n "$ins" ] && seg_git+=" ${C_ADD}+${ins}${C_RESET}"
    [ -n "$del" ] && seg_git+="${C_DEL}-${del}${C_RESET}"
  else
    seg_git="${C_CLEAN}${branch}${C_RESET}"
  fi
fi

# --- running subagents ---
# Each agent is shown as type(model·effort). Model and effort come from the
# agent's own log (what it actually ran on). Before its first reply, fall back
# to its definition in ~/.claude/agents and mark the values with "?".
short_model() {
  case "$1" in
    *opus*) echo opus ;; *sonnet*) echo sonnet ;; *haiku*) echo haiku ;;
    *fable*) echo fable ;; "" ) echo "" ;; *) echo "${1#claude-}" ;;
  esac
}
short_effort() {
  case "$1" in medium) echo med ;; *) echo "$1" ;; esac
}
agent_label() {
  local id="$1" dir="$2" type model effort mark="" line def
  type=$(jq -r '.name // .agentType // "agent"' "$dir/agent-$id.meta.json" 2>/dev/null)
  [ -z "$type" ] && type="agent"
  line=$(tail -c 300000 "$dir/agent-$id.jsonl" 2>/dev/null | grep '"type":"assistant"' | tail -1)
  if [ -n "$line" ]; then
    IFS=$'\037' read -r model effort < <(printf '%s' "$line" \
      | jq -r '[(.message.model // ""), (.effort // .message.effort // .effortLevel // "")] | join("\u001f")' 2>/dev/null)
  fi
  if [ -z "$model" ]; then
    def="$HOME/.claude/agents/$type.md"
    if [ -f "$def" ]; then
      model=$(sed -n 's/^model:[[:space:]]*//p' "$def" | head -1)
      effort=$(sed -n 's/^effort:[[:space:]]*//p' "$def" | head -1)
    fi
    [ -z "$model" ] && model="inherit"
    mark="?"
  fi
  model=$(short_model "$model"); effort=$(short_effort "$effort")
  local inner="$model"
  [ -n "$effort" ] && inner+="·$effort"
  printf '%s' "${C_AGENT}${type}${C_DIM}(${inner}${mark})${C_RESET}"
}

# Background agents get their tool_result at launch, so "tool_use without
# tool_result" can't detect them. Instead: agents launched, minus agents that
# have since produced a completed task-notification.
seg_agents=""
if [ -n "$transcript" ] && [ -f "$transcript" ]; then
  buf=$(tail -c 4000000 "$transcript" 2>/dev/null)
  launched=$(printf '%s' "$buf" | grep -o 'agentId: [A-Za-z0-9_-]\{1,\} (internal ID' | sed 's/agentId: //; s/ (internal ID//' | sort -u)
  if [ -n "$launched" ]; then
    done_ids=$(printf '%s' "$buf" | grep -E '<status>(completed|failed|killed|stopped|cancelled)</status>' \
      | grep -o '<task-id>[^<]\{1,\}</task-id>' | sed 's/<[^>]*>//g' | sort -u)
    running_ids=$(comm -23 <(printf '%s\n' "$launched") <(printf '%s\n' "$done_ids") | grep .)
    running=$(printf '%s' "$running_ids" | grep -c .)
    if [ "$running" -gt 0 ]; then
      seg_agents="${C_AGENT}@${running}${C_RESET}"
      sub_dir="${transcript%.jsonl}/subagents"
      for id in $running_ids; do
        seg_agents+=" $(agent_label "$id" "$sub_dir")"
      done
    fi
  fi
fi

# --- save latest usage so agents can read it (~/.claude/usage-latest.json) ---
if [ -n "$five_hour$seven_day" ]; then
  usage_tmp=$(mktemp "$HOME/.claude/.usage.XXXXXX" 2>/dev/null) && {
    printf '%s' "$input" | jq -c --arg at "$(date -u +%Y-%m-%dT%H:%M:%SZ)" \
      '{updated_at: $at, session_id, rate_limits}' > "$usage_tmp" 2>/dev/null \
      && mv "$usage_tmp" "$HOME/.claude/usage-latest.json" || rm -f "$usage_tmp"
  }
fi

# --- rate limits (5h session, 7d weekly) ---
rate_color() {
  pct="$1"
  int_pct=${pct%.*}
  if [ "$int_pct" -ge 90 ] 2>/dev/null; then
    printf '%s' "$C_RATE_CRIT"
  elif [ "$int_pct" -ge 70 ] 2>/dev/null; then
    printf '%s' "$C_RATE_WARN"
  else
    printf '%s' "$C_RATE"
  fi
}
seg_rate=""
if [ -n "$five_hour" ]; then
  five_r=$(printf '%.0f' "$five_hour")
  seg_rate+="$(rate_color "$five_r")5h:${five_r}%${C_RESET}"
fi
if [ -n "$seven_day" ]; then
  seven_r=$(printf '%.0f' "$seven_day")
  [ -n "$seg_rate" ] && seg_rate+=" "
  seg_rate+="$(rate_color "$seven_r")7d:${seven_r}%${C_RESET}"
fi

# --- session ---
seg_session="${C_DIM}${session:0:8}${C_RESET}"

sep="${C_DIM} | ${C_RESET}"
out="$seg_model$sep$seg_dir"
[ -n "$seg_git" ] && out+="$sep$seg_git"
[ -n "$seg_agents" ] && out+="$sep$seg_agents"
[ -n "$seg_rate" ] && out+="$sep$seg_rate"
out+="$sep$seg_session"
printf '%s' "$out"
