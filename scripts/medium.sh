
alias l=exa
alias ll='exa -l'


# # git branch (interactive)
# gb () {
#   local branches selection branch
#   branches=$(git branch --sort=-committerdate -vv) &&
#     selection=$(echo "$branches" | fzf --height=20% +m) &&
#     branch=$(echo "$selection" | awk '{print $1}' | sed "s/.* //") &&
#     if [[ -t 1 ]]; then git checkout "$branch"; else echo $branch; fi
# }

# # git commit --fixup (interactive)
# gcf () {
#   local commits selection commit
#   commits=$(git log --pretty=format:'%h [%ad] %s' --date=relative master..HEAD) &&
#     selection=$(echo "$commits" | fzf --height=20% +m) &&
#     commit=$(echo "$selection" | awk '{print $1}') &&
#     if [[ -t 1 ]]; then git commit --fixup "$commit"; else echo $commit; fi
# }

# git new (simplified git start)
gn () {
  git checkout master && git pull --rebase --no-tags && git checkout -b "$1"
}

# # git roost (simplified git sync)
# gr () {
#   local br
#   br="$(git rev-parse --abbrev-ref HEAD)"
#   git checkout master && git pull --rebase --no-tags && git checkout "$br" && git rebase master
# }

alias g='git'
alias ga='git add'
alias gam='git commit --amend -C HEAD'
alias gau='git add --update'
alias gap='git add --patch'
alias gc='git commit'
alias gca='git commit -a'
alias gcA='git commit --amend'
alias gcm='git commit -m'
alias gcam='git commit -am'
alias gco='git checkout'
alias gcp='git cherry-pick'
alias gcr='git rebase -i --autosquash'
alias gcrm='gcr master'
alias gd='git diff'
alias gds='git diff --staged'
alias gl="git log --pretty='format:%C(yellow)%h %C(green)%ad %Creset%s%Cblue  [%an]' --decorate --date=relative"
alias gll='gl --stat'
alias glm='gl master..HEAD'
alias glu='gl @{upstream}..HEAD'
alias gp='git pull --rebase --no-tags'
alias gpr='git pull-request'
alias gs='git status'
alias gsh='git show'
alias gS='git stash'
alias gSp='git stash pop'
alias gSs='git stash show'
alias grc='git add --update && git rebase --continue'
alias gre='git reset'
alias greh='git reset HEAD'
alias gre1='git reset HEAD~'
alias gu='git push'
alias gus='git shove'
alias ship='git shove && git pull-request'


#
# Configures history options
#

# sets the location of the history file
HISTFILE="${ZDOTDIR:-${HOME}}/.zhistory"

# limit of history entries
HISTSIZE=10000
SAVEHIST=10000

# Perform textual history expansion, csh-style, treating the character ‘!’ specially.
setopt BANG_HIST

# Save each command’s beginning timestamp (in seconds since the epoch) and the duration (in seconds) to the history file.
# ‘: <beginning time>:<elapsed seconds>;<command>’.
setopt EXTENDED_HISTORY

# This options works like APPEND_HISTORY except that new history lines are added to the ${HISTFILE} incrementally
# (as soon as they are entered), rather than waiting until the shell exits.
setopt INC_APPEND_HISTORY

# Shares history across all sessions rather than waiting for a new shell invocation to read the history file.
setopt SHARE_HISTORY

# Do not enter command lines into the history list if they are duplicates of the previous event.
setopt HIST_IGNORE_DUPS

# If a new command line being added to the history list duplicates an older one,
# the older command is removed from the list (even if it is not the previous event).
setopt HIST_IGNORE_ALL_DUPS

# Remove command lines from the history list when the first character on the line is a space,
# or when one of the expanded aliases contains a leading space.
setopt HIST_IGNORE_SPACE

# When writing out the history file, older commands that duplicate newer ones are omitted.
setopt HIST_SAVE_NO_DUPS

# Whenever the user enters a line with history expansion, don’t execute the line directly;
# instead, perform history expansion and reload the line into the editing buffer.
setopt HIST_VERIFY

#
# Lists the ten most used commands.
alias history-stat="history 0 | awk '{print \$2}' | sort | uniq -c | sort -n -r | head"

# If a command is issued that can’t be executed as a normal command,
# and the command is the name of a directory, perform the cd command to that directory.
setopt AUTO_CD

# Make cd push the old directory onto the directory stack.
setopt AUTO_PUSHD

# Don’t push multiple copies of the same directory onto the directory stack.
setopt PUSHD_IGNORE_DUPS

# Do not print the directory stack after pushd or popd.
setopt PUSHD_SILENT

# Have pushd with no arguments act like ‘pushd ${HOME}’.
setopt PUSHD_TO_HOME

# Treat the ‘#’, ‘~’ and ‘^’ characters as part of patterns for filename generation, etc.
# (An initial unquoted ‘~’ always produces named directory expansion.)
setopt EXTENDED_GLOB


# This file makes this module compatible with antigen/antibody zsh plugins.

OKTA_MODULE_PATH="$(dirname "${(%):-%x}")"

ok() {
  local LOGIN SESSION_TTL ROLE_TTL PROFILE

  SESSION_TTL="${OKTA_SESSION_TTL:-12h}"
  ROLE_TTL="${OKTA_ROLE_TTL:-1h}"

  if [[ "$1" = '-l' || "$1" == '--login' || "$1" == login ]]; then
    LOGIN=1
    shift
  fi

  if [[ -n "$LOGIN" ]]; then
    if [[ -z "$AWS_PROFILE" && -n "$1" ]]; then
      export AWS_PROFILE="$1"
      shift
    fi

    aws-okta login "$AWS_PROFILE" -t "$SESSION_TTL" -a "$ROLE_TTL" "$@"
  elif [[ -z "$1" ]]; then
    python "${OKTA_MODULE_PATH}/../bin/profiles.py"
  elif [[ -z "$AWS_PROFILE" ]]; then
    echo 'error: $AWS_PROFILE not set; `use` the profile you want' >&2
    echo >&2
    echo 'Available profiles:' >&2
    python "${OKTA_MODULE_PATH}/../bin/profiles.py" >&2
    return 1
  else
    PROFILE="$AWS_PROFILE"

    if [[ $1 == terraform || $1 == tf ]]; then
      [[ $PROFILE == tf-* ]] || PROFILE="tf-${PROFILE}"
    fi
    if [[ $PROFILE == tf-* ]]; then
      SESSION_TTL=1h
    fi

    aws-okta exec "$PROFILE" -t "$SESSION_TTL" -a "$ROLE_TTL" -- "$@"
  fi
}

use() {
  local kubernetes=0

  if [[ "$1" == -k || "$1" == --k8s || "$1" == --kubernetes ]]; then
    kubernetes=1
    shift
  fi

  if [[ -z "$1" ]]; then
    python "${OKTA_MODULE_PATH}/../bin/profiles.py" >&2
    return 1
  fi

  export AWS_PROFILE="$1"

  if [[ $kubernetes -gt 0 ]]; then
    echo -n '☸︎ '
    kubectl config use-context "$AWS_PROFILE"
  fi
}


#
# Create path aliases for the parts of mono, as identified by their PR_PREFIX files.
# This lets you `cd ~mono`, cd `~m2`, cd `~rex`, etc.
# Run `shortcut` to see available shortcuts, and `shortcut <name> <path>` to add your own.
#

typeset -gA SHORTCUT_PATHS

shortcut() {
  local spath

  if [[ "$#" -lt 1 ]]; then
    for name in ${(ok)SHORTCUT_PATHS}; do
      spath="${SHORTCUT_PATHS[$name]}"
      echo "$name: ${spath/#$HOME/~}"
    done
    return
  fi

  local name="$1"

  for loc in "${@:2}"; do
    if [[ -d "$loc" ]]; then
      export "${name}=${loc}"
      hash -d "${name}=${loc}"
      SHORTCUT_PATHS[$name]="$loc"
      break
    fi
  done
}

shortcut src ~/src
shortcut mono "$MONO_HOME"

() {
  local prefix_path component_path component relpath
  for prefix_path in $(mdfind -onlyin "$MONO_HOME" -name PR_PREFIX); do
    component_path="$(dirname "$prefix_path")"
    component="$(cat "$prefix_path")"

    if [[ -f "${component_path}/Gopkg.toml" ]]; then
      relpath="$(python -c 'import os, sys; print(os.path.relpath(*sys.argv[1:]))' "$component_path" "$MONO_HOME")"
      component_path="${MONO_GO_PACKAGE}/${relpath}"
    fi

    # Shorten medium2 and override PR_PREFIXes that aren't valid variable names.
    if [[ "$component" == medium2 ]]; then
      shortcut m2 "$component_path"
    elif [[ $component == deploy-config ]]; then
      shortcut config "$component_path"
    elif [[ $component == generator-m2 ]]; then
      shortcut generator "$component_path"
    else
      component="$(echo $component | tr - _)"
      shortcut "$component" "$component_path"
    fi
  done
}


#
# Manage the terminal title
#

TERM_TITLE_FORMAT='%n@%m: %~'

if [[ "$TERM_PROGRAM" == Apple_Terminal ]]; then
  TERM_TITLE_FORMAT="%n@%m"
fi

case ${TERM} in
  xterm*|*rxvt)
    precmd() {
      print -Pn "\e]0;${TERM_TITLE_FORMAT}\a"

      if [[ "$TERM_PROGRAM" == Apple_Terminal ]]; then
        # macOS Terminal recognizes a separate escape sequence to inform it of the current
        # working directory. This is how the setting to open new tabs in the same directory
        # is implemented by Terminal.
        printf '\e]7;%s\a' "file://${HOST}${PWD// /%20}"
      fi
    }
    precmd  # we execute it once to initialize the window title
    ;;
esac
