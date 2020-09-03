
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
alias gpom="git pull origin master"
alias gpum="git pull upstream master"
alias gcd='cd "`git rev-parse --show-toplevel`"'
alias gdmb='git delete-merged-branches'
alias gpr='git pull --rebase'
alias gprm='git pull --rebase origin master'
alias glm='git fetch; git checkout master; git pull origin master'
alias gprune='git branch --merged | grep -v "\*" | grep -v master | xargs -n 1 git branch -d'

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
    git pull origin master
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

compare() {
  local branch_name="$(                                        \
       git symbolic-ref --quiet --short HEAD 2> /dev/null      \
    || git rev-parse --short HEAD 2> /dev/null                 \
    || echo '(unknown)'                                        \
  )";
  echo $branch_name
  open "https://github.com/Medium/mono/compare/master...therebelrobot/$branch_name"

}