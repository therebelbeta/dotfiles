if [ -f ~/bin/.zshrc ]; then
      source ~/bin/.zshrc
fi
if [ -f ~/zsh-scripts/.zshrc ]; then
      source ~/zsh-scripts/.zshrc
fi
if [ -f ~/.nvm/nvm.sh ]; then
      nvm use 0.11
fi
if [ -f ~/.rvm/scripts/rvm ]; then
			source /home/therebelrobot/.rvm/scripts/rvm
fi