# vim:ft=zsh ts=2 sw=2 sts=2
#
# Based on agnoster's Theme - https://gist.github.com/3712874
# A Powerline-inspired theme for ZSH
#
# # README
#
# In order for this theme to render correctly, you will need a
# [Powerline-patched font](https://gist.github.com/1595572).
#
# In addition, I recommend the
# [Tomorrow Night Eighties theme](https://github.com/chriskempson/tomorrow-theme/tree/master/iTerm2)

## ** Zheeeng's patch: **
## ** change "print -n" to "echo -n" **
## ** show time on prompt right hind **
RPROMPT='[%D{%L:%M:%S %p}]'

### Segment drawing
# A few utility functions to make it easy and re-usable to draw segmented prompts

CURRENT_BG='NONE'
PRIMARY_FG=black

# ** Zheeeng's patch: **
# ** - Add TICK symbol **
# ** - Add HEART symbol **
# ** - Remove PLUSMINUS symbol **
# Characters
SEGMENT_SEPARATOR="\ue0b0"
BRANCH="\ue0a0"
DETACHED="\u27a6"
TICK="\u2714"
CROSS="\u2718"
LIGHTNING="\u26a1"
GEAR="\u2699"
HEART="\u2764"

# Begin a segment
# Takes two arguments, background and foreground. Both can be omitted,
# Rendering default background/foreground.
prompt_segment() {
  local bg fg
  [[ -n $1 ]] && bg="%K{$1}" || bg="%k"
  [[ -n $2 ]] && fg="%F{$2}" || fg="%f"
  if [[ $CURRENT_BG != 'NONE' && $1 != $CURRENT_BG ]]; then
    echo -n "%{$bg%F{$CURRENT_BG}%}$SEGMENT_SEPARATOR%{$fg%}"
  else
    echo -n "%{$bg%}%{$fg%}"
  fi
  CURRENT_BG=$1
  [[ -n $3 ]] && echo -n $3
}

# End the prompt, closing any open segments
prompt_end() {
  if [[ -n $CURRENT_BG ]]; then
    echo -n "%{%k%F{$CURRENT_BG}%}$SEGMENT_SEPARATOR"
  else
    echo -n "%{%k%}"
  fi
  echo -n "%{%f%}"
  CURRENT_BG=''
}

### Prompt components
# Each component will draw itself, and hide itself if no information needs to be shown

# ** Zheeeng's patch: **
# ** - Display $user and $hostname seperately **
# ** - New fg & bg color for $user and $hostname **
# Context: user@hostname (who am I and where am I)
prompt_context() {
  local user=`whoami`

  if [[ "$user" != "$DEFAULT_USER" || -n "$SSH_CONNECTION" ]]; then
    prompt_segment red black " %(!.%{%F{yellow}%}.)$user "
    prompt_segment white black " %m "
  fi
}

# Git: branch/detached head, dirty status
prompt_git() {
  local color ref

  is_dirty() {
    test -n "$(git status --porcelain --ignore-submodules)"
  }
  # ** Zheeeng's patch: **
  # ** - Display Git files index status **
  # ** Takes one argument, background color **
  display_index_status() {
    local bg_color added unadded total

    bg_color=$1
    added=$(git status --porcelain --ignore-submodules | grep '^[MADRCU].\ ' | wc -l | tr -d ' ')
    unadded=$(git status --porcelain --ignore-submodules | grep '^.[MADRCU]\ \|^??\ ' | wc -l | tr -d ' ')
    total=$[$added + $unadded]

    if [[ $added -eq 0 ]]; then
      prompt_segment $bg_color cyan "u:$unadded t:$total "
    elif [[ $unadded -eq 0 ]]; then
      prompt_segment $bg_color black "t:$total "
      prompt_segment $bg_color red "$HEART "
    else
      prompt_segment $bg_color blue "a:$added u:$unadded "
    fi
  }

  # ** Zheeeng's modify: **
  # ** - Revamap **
  ref="$vcs_info_msg_0_"
  if [[ -n "$ref" ]]; then
    if [[ "${ref/.../}" == "$ref" ]]; then
      display_ref=" $BRANCH $ref "
    else
      display_ref=" $DETACHED ${ref/.../} "
    fi
    if is_dirty; then
      color=yellow
      prompt_segment $color $PRIMARY_FG "$display_ref"
      display_index_status $color
    else
      color=green
      prompt_segment $color $PRIMARY_FG "$display_ref"
    fi
  fi

  # ** Zheeeng's patch: **
  # ** - count HEAD ahead and behind **
  remote=$(git rev-parse --abbrev-ref @{upstream} 2>/dev/null)
  if [[ -n "$remote" ]] ; then
    ahead=$(git rev-list @{upstream}..HEAD 2>/dev/null | wc -l | tr -d ' ')
    behind=$(git rev-list HEAD..@{upstream} 2>/dev/null | wc -l | tr -d ' ')

    if [[ "$ahead" -gt 0 ]] ; then
      display_ahead="(${ahead}.. "
    else
      display_ahead=""
    fi
    prompt_segment $color blue "${display_ahead}"

    if [[ "$behind" -gt 0 ]] ; then
      display_behind=" ..${ahead}) "
    else
      display_behind=" "
    fi
    prompt_segment cyan magenta "${display_behind}"
    prompt_segment cyan $PRIMARY_FG "$remote $BRANCH "
  fi
}

# Dir: current working directory
prompt_dir() {
  prompt_segment blue $PRIMARY_FG ' %~ '
}

# ** Zheeeng's patch: **
# ** - was previous command success? **
# ** - change yellow lighting to blue lighting**
# ** - frontground color is determined by previous command executed status **
# Status:
# - was there an error
# - am I root
# - are there background jobs?
prompt_status() {
  local symbols
  symbols=()
  status_fg=()
  [[ $RETVAL -ne 0 ]] && { symbols+="%{%F{red}%}$CROSS" && status_fg="black"; } || { symbols+="%{%F{green}%}$TICK" && status_fg="yellow"; }
  [[ $UID -eq 0 ]] && symbols+="%{%F{blue}%}$LIGHTNING"
  [[ $(jobs -l | wc -l) -gt 0 ]] && symbols+="%{%F{cyan}%}$GEAR"

  [[ -n "$symbols" ]] && prompt_segment $status_fg default " $symbols "
}

# ** Zheeeng's patch: **
# ** - Insert a line **
prompt_next_line() {
  echo ''
  CURRENT_BG='NONE'
}

# ** Zheeeng's patch: **
# ** - Rearrange the prompt components **
## Main prompt
prompt_agnoster_main() {
  RETVAL=$?
  CURRENT_BG='NONE'
  prompt_context
  prompt_dir
  prompt_git
  prompt_end
  prompt_next_line
  prompt_status
  prompt_end
}

prompt_agnoster_precmd() {
  vcs_info
  PROMPT='%{%f%b%k%}$(prompt_agnoster_main) '
}

prompt_agnoster_setup() {
  autoload -Uz add-zsh-hook
  autoload -Uz vcs_info

  prompt_opts=(cr subst percent)

  add-zsh-hook precmd prompt_agnoster_precmd

  zstyle ':vcs_info:*' enable git
  zstyle ':vcs_info:*' check-for-changes false
  zstyle ':vcs_info:git*' formats '%b'
  zstyle ':vcs_info:git*' actionformats '%b (%a)'
}

prompt_agnoster_setup "$@"
