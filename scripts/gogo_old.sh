
gogo_old() {
  if hash shopt 2>/dev/null; then
    shopt -s cdspell
  fi

  case $1 in

    */*)
      gonav $1
    ;;

    dotfiles)
      cd $DOTFILES_LOCATION
    ;;

    *)
      gonav $USER_DEFAULT/$1
    ;;

  esac

  if hash shopt 2>/dev/null; then
    shopt -s cdspell
  fi
}

gonav() {
  cd $GO_LOCATION/$1 &> /dev/null ||
  goclone $1 2> /dev/null ||
  echo "repo @ $1 does not exist"
}

_gogo()
{
  cur=${COMP_WORDS[COMP_CWORD]}
  if [[ "$cur" =~ ^([^/]+)/(.+)$ ]]; then
    use=`tree -f -L 1 $HOME/go/src/github.com/$USER_DEFAULT/ | grep ${BASH_REMATCH[2]} | tr / '\t' | awk '{print $(NF-1),$NF}' | tr ' ' /`
  else
    use=`ls $GO_LOCATION/$USER_DEFAULT/ | grep $cur`
  fi
  COMPREPLY=(`compgen -W "$use" -- $cur`)
}

if hash complete 2>/dev/null; then
  complete -o default -o nospace -F _gogo gogo
fi

_zsh_gogo()
{
  compadd $(find $GO_LOCATION -maxdepth 2 -mindepth 2 | sed "s|$GO_LOCATION/||")
}

if type compdef &> /dev/null ; then
  compdef _zsh_gogo gogo
fi
