echo "Loading Installers"

installruby () { curl -sSL https://get.rvm.io | bash -s stable --ruby; reload; rvm --default use 2.1.2; }
installgems () { gem install sass compass bundler; }
installgo () { bash < <(curl -s -S -L https://raw.githubusercontent.com/moovweb/gvm/master/binscripts/gvm-installer);reload;gvm install go1; }
alias installspot="curl -L https://raw.github.com/rauchg/spot/master/spot.sh -o ~/bin/spot && chmod +x ~/bin/spot"
setupglobalrepl () { npm i -g local-repl; ln -s $HOME/.dotfiles/.replrc.js $HOME/.replrc.js }
setuprepl () { ln -s $HOME/.replrc.js $( pwd )/.replrc.js; echo .replrc.js >> .gitignore }
installpokemonterminal () { sudo pip3 install git+https://github.com/LazoCoder/Pokemon-Terminal.git }
