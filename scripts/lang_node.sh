export NVM_DIR="$HOME/.nvm"

export PATH="$PATH:$(yarn global bin)"

[ -s "$NVM_DIR/nvm.sh" ] && . "$NVM_DIR/nvm.sh" # This loads nvm
[ -s "$NVM_DIR/bash_completion" ] && . "$NVM_DIR/bash_completion"  # This loads nvm bash_completion

alias module-init='npx tosin init'

alias noderequire='local-repl'

# uninstall by removing these lines or running `tabtab uninstall serverless`
[[ -f $HOME/.nvm/versions/node/v8.4.0/lib/node_modules/serverless/node_modules/tabtab/.completions/serverless.zsh ]] && . $HOME/.nvm/versions/node/v8.4.0/lib/node_modules/serverless/node_modules/tabtab/.completions/serverless.zsh
# tabtab source for sls package
# uninstall by removing these lines or running `tabtab uninstall sls`
[[ -f $HOME/.nvm/versions/node/v8.4.0/lib/node_modules/serverless/node_modules/tabtab/.completions/sls.zsh ]] && . $HOME/.nvm/versions/node/v8.4.0/lib/node_modules/serverless/node_modules/tabtab/.completions/sls.zsh
# tabtab source for slss package