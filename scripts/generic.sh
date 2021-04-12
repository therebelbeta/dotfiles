alias reload='echo "reloading ~/.zshrc...";source ~/.zshrc'
alias relaod='reload'

alias home='cd ~/'
alias root='cd /'
alias jump='pushd ~/.dotfiles'
alias back='popd'
alias cd..='cd ..'
findandkillonport () { lsof -t -i tcp:"$@" | xargs kill -9 }

alias ls='ls -aG'
alias ll='k -ha'
alias findSymLinks='find ./ -type l'
createinallfolders () { for d in ./*/ ; do echo "$d $@"; touch "$d$@"; done }
renameinallfolders () { for d in ./*/ ; do echo "$d $1 $2"; mv "$d$1" "$d$2"; done }
deleteinallfolders () { for d in ./*/ ; do echo "$d$@"; rm -rf "$d$@"; done }

alias cat="bat"
alias edit='open -a "Visual Studio Code"'
alias pwnyoutube='youtube-dl-interactive'
alias lscpu='sysctl -n hw.ncpu'

alias treed="find . -print | sed -e 's;[^/]*/;|____;g;s;____|; |;g'"
alias editAliases="edit ~/.dotfiles/zshrc.mac"

alias easyfind="spot" # see installspot
alias installeasyfind="installspot"


display () {
  
  case $1 in

  top)
      displayplacer "id:532D45C0-8EEF-D102-A929-01A1BBA8C2D8 res:1920x1200 color_depth:4 scaling:on origin:(0,0) degree:0" "id:47373B16-B557-83BA-929D-7FAD38A6E73F res:1440x2560 hz:60 color_depth:8 scaling:off origin:(-1440,87) degree:90"
  ;;

  bottom)
    displayplacer "id:532D45C0-8EEF-D102-A929-01A1BBA8C2D8 res:1920x1200 color_depth:4 scaling:on origin:(0,0) degree:0" "id:47373B16-B557-83BA-929D-7FAD38A6E73F res:1440x2560 hz:60 color_depth:8 scaling:off origin:(-1440,-1360) degree:90"
  ;;

  movie)
    displayplacer "id:532D45C0-8EEF-D102-A929-01A1BBA8C2D8 res:1920x1200 color_depth:8 scaling:on origin:(0,0) degree:0" "id:47373B16-B557-83BA-929D-7FAD38A6E73F res:2560x1440 hz:60 color_depth:8 scaling:off origin:(189,-1440) degree:0"
  ;;

  synergy)
    displayplacer "id:532D45C0-8EEF-D102-A929-01A1BBA8C2D8 res:1920x1200 color_depth:8 scaling:on origin:(0,0) degree:0" "id:47373B16-B557-83BA-929D-7FAD38A6E73F res:2560x1440 hz:60 color_depth:8 scaling:off origin:(1920,-147) degree:0"
  ;;

  *)
    displayplacer $@
  ;;

  esac
}