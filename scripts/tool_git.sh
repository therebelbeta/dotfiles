echo "Loading Tool: Git"

export MAIN_BRANCH='main'
export GIT_LOCATION=$HOME/git

alias gd="git diff"
alias gc="git clone"
alias ga="git add"
alias gbd="git branch -D"
alias gs="git status"
alias gst="git status"
alias gss="git status -s"
alias gca="git commit -a -m"
alias gpt="git push --tags"
alias gp="git push"
alias grh="git reset --hard"
alias gcob="git checkout -b"
alias gm="git merge"
alias gco="git checkout"
alias gba="git branch -a"
alias gcp="git cherry-pick"
alias gl="git log --pretty='format:%Cgreen%h%Creset %an - %s' --graph"
alias docs="rm -fr /tmp/docs && cp -fr docs /tmp/docs && git checkout gh-pages && cp -fr /tmp/docs/* ."
alias gpom="git pull origin main"
alias gpum="git pull upstream main"
alias gcd='cd "`git rev-parse --show-toplevel`"'
alias gdmb='git delete-merged-branches'
alias gpr='git pull --rebase'
alias gprm='git pull --rebase origin main'
alias glm='git fetch; git checkout main; git pull origin main'
alias gprune='git branch --merged | grep -v "\*" | grep -v main | xargs -n 1 git branch -d'

gcopr(){
  git fetch origin pull/$1/head:pr-$1
  git checkout pr-$1
}

gho() {
  repo=$(git remote -v)
  re="github.com/([^/]+/[^[:space:]]+)(.git)"
  if [[ $repo =~ $re ]]; then open "https://${BASH_REMATCH[1]}"; fi
}

clone() {
  for repo in $@; do
    if [[ "$repo" == */* ]]; then
      local dir=$GIT_LOCATION/$repo
      git clone ssh://git@github.com/$repo.git $dir
      cd $dir
    else
      local dir=$GOTO_DEFAULT/$USER_DEFAULT/$repo
      git clone ssh://git@github.com/$USER_DEFAULT/$repo.git $dir
      cd $dir
    fi
  done
}

goclone() {
  for repo in $@; do
    if [[ "$repo" == */* ]]; then
      local dir=$GO_LOCATION/$repo
      git clone ssh://git@github.com/$repo.git $dir
      cd $dir
    else
      local dir=$GOTO_DEFAULT/$USER_DEFAULT/$repo
      git clone ssh://git@github.com/$USER_DEFAULT/$repo.git $dir
      cd $dir
    fi
  done
}

update() {
  for repo in $@; do
    if [[ "$repo" == */* ]]; then
      cd $GIT_LOCATION/$repo
    else
      cd $GIT_LOCATION/$USER_DEFAULT/$repo
    fi
    nav $canonical
    git pull origin main
    if test "$canonical" = "therebelrobot/dotfiles"; then
      echo "... sourcing"
      source ~/.profile
    fi
  done
}

gbn() {
  local branch_name="$(                                        \
       git symbolic-ref --quiet --short HEAD 2> /dev/null      \
    || git rev-parse --short HEAD 2> /dev/null                 \
    || echo '(unknown)'                                        \
  )";
  echo $branch_name
}

alias githash='git rev-parse HEAD | clipcopy; echo -n "copied to clipboard: "; git rev-parse HEAD;'
alias ,,='githash'
alias push='git push origin $(git rev-parse --abbrev-ref HEAD)'
alias pull='git pull origin $(git rev-parse --abbrev-ref HEAD)'
alias check='git checkout'
alias cherry='git cherry-pick'
alias new='git checkout -b'
alias rebase='git rebase'
alias sb='git sb'
alias commit='git commit -a'
alias tag='git tag -a'
alias clean="git gc --prune=now && git remote prune origin"
alias diff="git difftool"
alias merge="git mergetool"
untrack () { git update-index --assume-unchanged "$@" }
alias listuntracked="git ls-files -v | grep --colour=none ^h | cut -c 3-"
track () { git update-index --no-assume-unchanged "$@" }
git-switch () {
  git config credential.helper ""
  git config --global credential.helper ""
  git config --global user.name "$@"
  git config --global user.email "github@$@.com"
  git config --global github.user "$@"
  git config --global credential.username "$@"
  git config user.name "$@"
  git config user.email "github@$@.com"
  git config github.user "$@"
  git config credential.username "$@"
}
git-setupfor () {
  git remote remove origin
  git remote add origin git@$@-github:
}
git-upstream () {
  git branch --set-upstream-to=origin/$@ $@
}