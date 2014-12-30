if [ -f $HOME/.dotfiles/zshrc ]; then
  source $HOME/.dotfiles/zshrc
fi
if [ -f $HOME/.nvm/nvm.sh ]; then
  source $HOME/.nvm/nvm.sh
  nvm use 0.10
fi
if [ -f $HOME/.rvm/scripts/rvm ]; then
  source $HOME/.rvm/scripts/rvm
fi

