# Path to your oh-my-zsh configuration.
ZSH=~/.oh-my-zsh

# Set name of the theme to load.
# Look in ~/.oh-my-zsh/themes/
# Optionally, if you set this to "random", it'll load a random theme each
# time that oh-my-zsh is loaded.

# if [[ -n $SSH_CONNECTION ]]; then
#   ZSH_THEME="norm"
# else
  ZSH_THEME="duellj"
# fi
# MIX DUELLJ and BUREAU

# Example aliases
# alias zshconfig="mate ~/.zshrc"
# alias ohmyzsh="mate ~/.oh-my-zsh"

# Set this to use case-sensitive completion
# CASE_SENSITIVE="true"

# Uncomment this to disable bi-weekly auto-update checks
# DISABLE_AUTO_UPDATE="true"

# Uncomment to change how often to auto-update? (in days)
# export UPDATE_ZSH_DAYS=13

# Uncomment following line if you want to disable colors in ls
# DISABLE_LS_COLORS="true"

# Uncomment following line if you want to disable autosetting terminal title.
# DISABLE_AUTO_TITLE="true"

# Uncomment following line if you want to disable command autocorrection
# DISABLE_CORRECTION="true"

# Uncomment following line if you want red dots to be displayed while waiting for completion
	COMPLETION_WAITING_DOTS="true"

# Uncomment following line if you want to disable marking untracked files under
# VCS as dirty. This makes repository status check for large repositories much,
# much faster.
# DISABLE_UNTRACKED_FILES_DIRTY="true"

# Uncomment following line if you want to the command execution time stamp shown
# in the history command output.
# The optional three formats: "mm/dd/yyyy"|"dd.mm.yyyy"|"yyyy-mm-dd"
# HIST_STAMPS="mm/dd/yyyy"

# Which plugins would you like to load? (plugins can be found in ~/.oh-my-zsh/plugins/*)
# Custom plugins may be added to ~/.oh-my-zsh/custom/plugins/
# Example format: plugins=(rails git textmate ruby lighthouse)
plugins=(git nvm rvm bower colorize command-not-found comman-aliases docker gem git-flow git-hubflow gitignore )

source $ZSH/oh-my-zsh.sh

# User configuration

# export MANPATH="/usr/local/man:$MANPATH"

# Preferred editor for local and remote sessions
if [[ -n $SSH_CONNECTION ]]; then
  export EDITOR='nano'
else
  export EDITOR='sublime -w'
fi

# Compilation flags
# export ARCHFLAGS="-arch x86_64"

# ssh
# export SSH_KEY_PATH="~/.ssh/dsa_id"

command_not_found_handle(){ echo -e "\x0A\xE2\x96\x88\xE2\x96\x84\xE2\x96\x84\x20\xE2\x96\x88\xE2\x96\x88\xE2\x96\x88\x20\xE2\x96\x88\xE2\x96\x84\xE2\x96\x84\x20\xE2\x96\x88\xE2\x96\x84\xE2\x96\x88\xE2\x96\x84\xE2\x96\x88\x20\xE2\x96\x88\xE2\x96\x84\xE2\x96\x88\x20\xE2\x96\x80\xE2\x96\x88\xE2\x96\x80\x0A\x0A\x28\xE2\x95\xAF\xC2\xB0\xE2\x96\xA1\x20\xC2\xB0\xEF\xBC\x89\xE2\x95\xAF\xEF\xB8\xB5\x20\xE2\x94\xBB\xE2\x94\x81\xE2\x94\xBB\x0A"; }

alias reload='echo "reloading ~/.zshrc...";source ~/.zshrc'
alias relaod='reload'

# Navigation
alias home='cd ~/'
alias root='cd /'
alias jump='pushd ~/bin'
alias cd..='cd ..'

# Files and File System
alias ls='ls --color=auto'
alias ll='ls -l'
alias findSymLinks='find ./ -type l'

function restart() {
	if [ "$@" == "server" ] ; then
		echo "sudo /etc/init.d/nginx restart;"
		sudo /etc/init.d/nginx restart;
	else
		echo "sudo /etc/init.d/$@ restart;"
		sudo /etc/init.d/"$@" restart;
	fi
}
ngensite(){
	sudo ln -s /etc/nginx/sites-available/"$@" /etc/nginx/sites-enabled/"$@"
}
ngdissite(){
	sudo unlink /etc/nginx/sites-enabled/"$@"
}
alias copyhash='git rev-parse HEAD | xclip -selection clip; echo -n "copied to clipboard: "; git rev-parse HEAD;'
alias push='git push origin $(git rev-parse --abbrev-ref HEAD)'
alias pull='git pull'
alias check='git checkout'
alias rebase='git rebase'
alias pull='git pull'
alias sb='git sb'
alias commit='git commit -a'
alias killnginx='sudo /etc/init.d/nginx stop && sudo /etc/init.d/apache2 start && sudo /etc/init.d/dnsmasq restart'
alias killapache='sudo /etc/init.d/apache2 stop && sudo /etc/init.d/nginx start && sudo /etc/init.d/dnsmasq restart'
alias battery='upower -i /org/freedesktop/UPower/devices/battery_BAT0'
installruby()  { \curl -sSL https://get.rvm.io | bash -s stable --ruby; reload; rvm --default use 2.1.2; }
installgems() { gem install sass compass bundler; }
installnodejs()  { sudo apt-get install git curl build-essential libssl-dev; curl https://raw.githubusercontent.com/creationix/nvm/v0.13.0/install.sh | bash; reload; nvm install 0.10; nvm use 0.10 --default; }
installnodemods() { npm install gulp -g; npm install grunt-cli -g; npm install bower -g; npm install yeoman -g; npm install nodemon -g; npm install slush -g; npm install slap -g; }
installsublime() { sudo add-apt-repository ppa:webupd8team/sublime-text-3;	sudo apt-get update; sudo apt-get install sublime-text-installer; }
installlamp() { sudo apt-get install tasksel; sudo tasksel install lamp-server; }
installnginx() { sudo add-apt-repository ppa:nginx/stable; sudo apt-get update; sudo apt-get install nginx; }
installphpfpm() { sudo add-apt-repository ppa:brianmercer/php5; sudo apt-get update; sudo apt-get install nginx php5-fpm; }
installnetflix() { sudo apt-add-repository ppa:ehoover/compholio; sudo apt-get update; sudo apt-get install netflix-desktop; }
installinvoice() { sudo apt-get install -y texlive; npm install -g invoicer; npm install -g clocker; echo "https://github.com/substack/invoicer"; echo "https://github.com/substack/clocker"; echo ""; }
preparesshfs() { CURRENTUSER=$(whoami); sudo apt-get install sshfs; sudo modprobe fuse; sudo adduser $CURRENTUSER fuse; sudo chown root:fuse /dev/fuse; sudo chmod +x /dev/fuse; echo "SSHfs installed."; echo "You will need to logout for these changes to take effect."; }
configzsh() {
	echo "copying custom zsh files..."
	if [ -f ~/bin/oh-my-zsh.sh ]; then
    cp ~/bin/oh-my-zsh.sh ~/.oh-my-zsh/oh-my-zsh.sh
    cp ~/bin/norm.zsh-theme ~/.oh-my-zsh/themes/norm.zsh-theme
    cp ~/bin/duellj.zsh-theme ~/.oh-my-zsh/themes/duellj.zsh-theme
  elif [ -f ~/zsh-scripts/oh-my-zsh.sh ]; then
    cp ~/zsh-scripts/oh-my-zsh.sh ~/.oh-my-zsh/oh-my-zsh.sh
    cp ~/zsh-scripts/norm.zsh-theme ~/.oh-my-zsh/themes/norm.zsh-theme
    cp ~/zsh-scripts/duellj.zsh-theme ~/.oh-my-zsh/themes/duellj.zsh-theme
	fi
	echo "copy complete. Please reload your prompt."
}
ngensite(){
	sudo ln -s /etc/nginx/sites-available/"$@" /etc/nginx/sites-enabled/"$@"
}
ngdissite(){
	sudo unlink /etc/nginx/sites-enabled/"$@"
}
installgoogledrive() {
	sudo add-apt-repository ppa:alessandro-strada/ppa;
	sudo apt-get update;
	sudo apt-get install google-drive-ocamlfuse;
	google-drive-ocamlfuse;
	mkdir ~/Google;
	google-drive-ocamlfuse ~/Google;
}
alias googledrive='google-drive-ocamlfuse ~/Google'
installgo() {
	bash < <(curl -s -S -L https://raw.githubusercontent.com/moovweb/gvm/master/binscripts/gvm-installer);
	reload;
	gvm install go1;
}
installpassenger() {
  sudo apt-key adv --keyserver keyserver.ubuntu.com --recv-keys 561F9B9CAC40B2F7
  sudo apt-get install apt-transport-https ca-certificates
  echo "deb https://oss-binaries.phusionpassenger.com/apt/passenger trusty main" > tmp.passenger.src
  sudo mv tmp.passenger.src /etc/apt/sources.list.d/passenger.list
  rm -rf tmp.passenger.src
  sudo chown root: /etc/apt/sources.list.d/passenger.list
  sudo chmod 600 /etc/apt/sources.list.d/passenger.list
  sudo apt-get update
  sudo apt-get install nginx-extras passenger
  echo "Edit /etc/nginx/nginx.conf and uncomment passenger_root and passenger_ruby, then restart nginx."
}
if [ -f ~/.zsh_ssh ]; then
      source ~/.zsh_ssh
fi

export PATH=$HOME/.exercism:$HOME/Apps:$HOME/bin/scripts:$PATH
if [ -d "$HOME/Apps" ] ; then
  export PATH="$HOME/Apps:$PATH"
fi
if [ -d "$HOME/.gvm/bin" ] ; then
  export PATH="$HOME/.gvm/bin:$PATH"
fi
[[ -s "$HOME/.gvm/scripts/gvm" ]] && source "$HOME/.gvm/scripts/gvm"

createinallfolders() {
  for d in ./*/ ; do
    echo "$d $@"
    touch "$d$@"
  done
}
renameinallfolders() {
  for d in ./*/ ; do
    echo "$d $1 $2"
    mv "$d$1" "$d$2"
  done
}
deleteinallfolders() {
  for d in ./*/ ; do
    echo "$d$@"
    rm -rf "$d$@"
  done
}
alias goga="cd $HOME/git/grow/grow-app"