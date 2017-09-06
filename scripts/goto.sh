
goto() {
  if hash shopt 2>/dev/null; then
    shopt -s cdspell
  fi

  case $1 in

    */*)
      nav $1
    ;;

    dotfiles)
      cd $DOTFILES_LOCATION
    ;;

    *)
      nav $USER_DEFAULT/$1
    ;;

  esac

  if hash shopt 2>/dev/null; then
    shopt -s cdspell
  fi
}

nav() {
  cd $HOME/git/$1 &> /dev/null ||
  clone $1 2> /dev/null ||
  echo "repo @ $1 does not exist"
}

_goto()
{
  cur=${COMP_WORDS[COMP_CWORD]}
  if [[ "$cur" =~ ^([^/]+)/(.+)$ ]]; then
    use=`tree -f -L 1 $HOME/git/$USER_DEFAULT/ | grep ${BASH_REMATCH[2]} | tr / '\t' | awk '{print $(NF-1),$NF}' | tr ' ' /`
  else
    use=`ls $GIT_LOCATION/$USER_DEFAULT/ | grep $cur`
  fi
  COMPREPLY=(`compgen -W "$use" -- $cur`)
}

if hash complete 2>/dev/null; then
  complete -o default -o nospace -F _goto goto
fi

_zsh_goto()
{
  compadd $(find $GIT_LOCATION -maxdepth 2 -mindepth 2 | sed "s|$GIT_LOCATION/||")
}

if type compdef &> /dev/null ; then
  compdef _zsh_goto goto
fi
