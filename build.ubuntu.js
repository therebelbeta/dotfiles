#! /usr/bin/env node

// Copyright (c) 2015 Trent Oswald <trentoswald@therebelrobot.com>

// Permission to use, copy, modify, and/or distribute this software for any
// purpose with or without fee is hereby granted, provided that the above
// copyright notice and this permission notice appear in all copies.

// THE SOFTWARE IS PROVIDED "AS IS" AND THE AUTHOR DISCLAIMS ALL WARRANTIES
// WITH REGARD TO THIS SOFTWARE INCLUDING ALL IMPLIED WARRANTIES OF
// MERCHANTABILITY AND FITNESS. IN NO EVENT SHALL THE AUTHOR BE LIABLE FOR ANY
// SPECIAL, DIRECT, INDIRECT, OR CONSEQUENTIAL DAMAGES OR ANY DAMAGES
// WHATSOEVER RESULTING FROM LOSS OF USE, DATA OR PROFITS, WHETHER IN AN
// ACTION OF CONTRACT, NEGLIGENCE OR OTHER TORTIOUS ACTION, ARISING OUT OF OR
// IN CONNECTION WITH THE USE OR PERFORMANCE OF THIS SOFTWARE.
"use strict"

var debug = require('debug-log2')
var inquirer = require("inquirer")
var colors = require('colors')
var keygen = require('ssh-keygen')
var fs = require('fs')

var spawn = require('child_process').spawn
  // ps    = spawn('ps', ['ax']),
  // grep  = spawn('grep', ['ssh']);
var compName
var homeDir

inquirer.prompt([{
  type: "input",
  name: "comp_name",
  message: "What's would you like to call this system?"
}, {
  type: "input",
  name: "home_dir",
  message: "What's the path to your $HOME folder? (" + __dirname + ")",
  default: function () {
    return __dirname
  }
}], _afterInitialPrompt)

function _afterInitialPrompt(answers) {
  compName = answers.comp_name
  homeDir = answers.home_dir
  console.log('System name:', compName)
  console.log('Home Folder:', homeDir)
  console.log('Setting up SSH key for ' + compName.bold)
  var location = homeDir + '/.ssh/id_rsa'

  keygen({
    location: location,
    comment: compName,
    password: false,
    read: true
  }, _afterKeyGen);
}

function _afterKeyGen(err, out) {
  if (err) return console.log('Something went wrong: ' + err);
  console.log('SSH Keys have been successfully created.');
  console.log('');
  console.log('Please take your public key and add it to your SSH keys on Github:');
  console.log('https://github.com/settings/ssh');
  console.log('This build scripts depends on proper access to Github.');
  console.log('')
  console.log(out.pubKey);
  console.log('')
  inquirer.prompt(
    [{
      type: "input",
      name: "key_added",
      message: "Press enter to continue once your key is added."
    }],
    _afterConfirmPrompt
  )
}

function _afterConfirmPrompt() {
  var curlomzsh = spawn('curl', ['-L', 'http://install.ohmyz.sh'])
  var runomzsh = spawn('sh')
  curlomzsh.stdout.on('data', function _curlMyZSHData(data) {
    runomzsh.stdin.write(data);
  });
  curlomzsh.stderr.on('data', function _curlMyZSHerror(data) {
    console.log('curlomzsh stderr: ' + data);
  });
  curlomzsh.on('close', function _afterCurlMyZSH(code) {
    if (code !== 0) {
      console.log('curlomzsh process exited with code ' + code);
    }
    runomzsh.stdin.end();
  });
  runomzsh.stdout.on('data', function _runOMZSH(data) {
    console.log('' + data);
  });
  runomzsh.stderr.on('data', function _OMZSHerror(data) {
    console.log('runomzsh stderr: ' + data);
  });
  runomzsh.on('close', _afterOhMyZSH);
}

function _afterOhMyZSH(code) {
  var fixPamShell = spawn('sudo', [
    'sed', '-i', 
    '"s/auth       required   pam_shells.so/# auth       required   pam_shells.so/g"',
    '/etc/pam.d/chsh'])
  fixPamShell.stdout.on('data', function _fixPamShell (data) {
    console.log('' + data);
  });
  fixPamShell.stderr.on('data', function _fixPamShellError(data) {
    console.log('fixPamShell stderr: ' + data);
  });
  fixPamShell.on('close', _afterPamShellFix);
}

function _afterPamShellFix(code){
  if (code !== 0) {
    return console.log('fixPamShell process exited with code ' + code);
  }
  var changeShell = spawn('chsh',['-s', '$(which zsh)'])
  changeShell.stdout.on('data', function _changeShell(data) {
    console.log('' + data);
  });
  changeShell.stderr.on('data', function _changeShellError(data) {
    console.log('changeShell stderr: ' + data);
  });
  changeShell.on('close', _afterChangeShell);
}
function _afterChangeShell(code){
  if (code !== 0) {
    return console.log('changeShell process exited with code ' + code);
  }
  var moveOMZSHsh = spawn('mv', ['$HOME/.oh-my-zsh/oh-my-zsh.sh', '$HOME/.oh-my-zsh/oh-my-zsh.sh.original'])
  moveOMZSHsh.stdout.on('data', function _moveOMZSHsh(data) {
    console.log('' + data);
  });
  moveOMZSHsh.stderr.on('data', function _moveOMZSHshError(data) {
    console.log('moveOMZSHsh stderr: ' + data);
  });
  moveOMZSHsh.on('close', _aftermoveOMZSHsh);
}
function _aftermoveOMZSHsh(code){
  if (code !== 0) {
    return console.log('moveOMZSHsh process exited with code ' + code);
  }
  var moveOMZSHtheme = spawn('mv', ['$HOME/.oh-my-zsh/themes/duellj.zsh-theme', '$HOME/.oh-my-zsh/themes/duellj.zsh-theme.original'])
  moveOMZSHtheme.stdout.on('data', function _moveOMZSHtheme(data) {
    console.log('' + data);
  });
  moveOMZSHtheme.stderr.on('data', function _moveOMZSHthemeError(data) {
    console.log('moveOMZSHtheme stderr: ' + data);
  });
  moveOMZSHtheme.on('close', _aftermoveOMZSHtheme);
}
function _aftermoveOMZSHtheme(code){
  if (code !== 0) {
    return console.log('moveOMZSHtheme process exited with code ' + code);
  }
  var linkOMZSHsh = spawn('ln', ['-s','$HOME/.dotfiles/oh-my-zsh.sh','$HOME/.oh-my-zsh/oh-my-zsh.sh'])
  linkOMZSHsh.stdout.on('data', function _linkOMZSHsh(data) {
    console.log('' + data);
  });
  linkOMZSHsh.stderr.on('data', function _linkOMZSHshError(data) {
    console.log('linkOMZSHsh stderr: ' + data);
  });
  linkOMZSHsh.on('close', _afterlinkOMZSHsh);
}
function _afterlinkOMZSHsh(code){
  if (code !== 0) {
    return console.log('linkOMZSHsh process exited with code ' + code);
  }
  var linkOMZSHtheme = spawn('ln', ['-s','$HOME/.dotfiles/duellj.zsh-theme','$HOME/.oh-my-zsh/themes/duellj.zsh-theme'])
  linkOMZSHtheme.stdout.on('data', function _linkOMZSHtheme(data) {
    console.log('' + data);
  });
  linkOMZSHtheme.stderr.on('data', function _linkOMZSHthemeError(data) {
    console.log('linkOMZSHtheme stderr: ' + data);
  });
  linkOMZSHtheme.on('close', _afterlinkOMZSHtheme);
}

function _afterlinkOMZSHtheme(code){
  if (code !== 0) {
    return console.log('linkOMZSHtheme process exited with code ' + code);
  }
  var moveZSHRC = spawn('mv', ['$HOME/.zshrc', '$HOME/.zshrc.oh-my-zsh'])
  moveZSHRC.stdout.on('data', function _moveZSHRC(data) {
    console.log('' + data);
  });
  moveZSHRC.stderr.on('data', function _moveZSHRCError(data) {
    console.log('moveZSHRC stderr: ' + data);
  });
  moveZSHRC.on('close', _aftermoveZSHRC);
}
function _aftermoveZSHRC(code){
  if (code !== 0) {
    return console.log('moveZSHRC process exited with code ' + code);
  }
  var linkZSHRC = spawn('ln', ['-s','$HOME/.dotfiles/zshrc.ubuntu','$HOME/.zshrc'])
  linkZSHRC.stdout.on('data', function _linkZSHRC(data) {
    console.log('' + data);
  });
  linkZSHRC.stderr.on('data', function _linkZSHRCError(data) {
    console.log('linkZSHRC stderr: ' + data);
  });
  linkZSHRC.on('close', _afterlinkZSHRC);
}
function _afterlinkZSHRC(code){
  if (code !== 0) {
    return console.log('linkZSHRC process exited with code ' + code);
  }
  var linkGitconfig = spawn('ln', ['-s','$HOME/.dotfiles/gitconfig','$HOME/.gitconfig'])
  linkGitconfig.stdout.on('data', function _linkGitconfig(data) {
    console.log('' + data);
  });
  linkGitconfig.stderr.on('data', function _linkGitconfigError(data) {
    console.log('linkGitconfig stderr: ' + data);
  });
  linkGitconfig.on('close', _afterlinkGitconfig);
}
function _afterlinkGitconfig(code){
  if (code !== 0) {
    return console.log('linkGitconfig process exited with code ' + code);
  }
  var linkGitignore = spawn('ln', ['-s','$HOME/.dotfiles/gitignore','$HOME/.gitignore'])
  linkGitignore.stdout.on('data', function _linkGitignore(data) {
    console.log('' + data);
  });
  linkGitignore.stderr.on('data', function _linkGitignoreError(data) {
    console.log('linkGitignore stderr: ' + data);
  });
  linkGitignore.on('close', _afterlinkGitignore);
}
function _afterlinkGitignore(code){
  if (code !== 0) {
    return console.log('linkGitignore process exited with code ' + code);
  }
  var linkEditorconfig = spawn('ln', ['-s','$HOME/.dotfiles/editorconfig','$HOME/.editorconfig'])
  linkEditorconfig.stdout.on('data', function _linkEditorconfig(data) {
    console.log('' + data);
  });
  linkEditorconfig.stderr.on('data', function _linkEditorconfigError(data) {
    console.log('linkEditorconfig stderr: ' + data);
  });
  linkEditorconfig.on('close', _afterlinkEditorconfig);
}
function _afterlinkEditorconfig(code){
  if (code !== 0) {
    return console.log('linkEditorconfig process exited with code ' + code);
  }
  var cloneVundle = spawn('git', ['clone', 'https://github.com/gmarik/Vundle.vim.git ~/.vim/bundle/Vundle.vim'])
  cloneVundle.stdout.on('data', function _cloneVundle(data) {
    console.log('' + data);
  });
  cloneVundle.stderr.on('data', function _cloneVundleError(data) {
    console.log('cloneVundle stderr: ' + data);
  });
  cloneVundle.on('close', _aftercloneVundle);
}
function _aftercloneVundle(code){
  if (code !== 0) {
    return console.log('cloneVundle process exited with code ' + code);
  }
  var linkVimrc = spawn('ln', ['-s','$HOME/.dotfiles/.vimrc', '$HOME/.vimrc'])
  linkVimrc.stdout.on('data', function _linkVimrc(data) {
    console.log('' + data);
  });
  linkVimrc.stderr.on('data', function _linkVimrcError(data) {
    console.log('linkVimrc stderr: ' + data);
  });
  linkVimrc.on('close', _afterlinkVimrc);
}
function _afterlinkVimrc(code){
  if (code !== 0) {
    return console.log('linkVimrc process exited with code ' + code);
  }
  var installPIPmodules = spawn('sudo', ['pip', 'install', 'autoenv', 'thefuck'])
  installPIPmodules.stdout.on('data', function _installPIPmodules(data) {
    console.log('' + data);
  });
  installPIPmodules.stderr.on('data', function _installPIPmodulesError(data) {
    console.log('installPIPmodules stderr: ' + data);
  });
  installPIPmodules.on('close', _afterinstallPIPmodules);
}
function _afterinstallPIPmodules(code){
  if (code !== 0) {
    return console.log('installPIPmodules process exited with code ' + code);
  }
  var makeAckWork = spawn('sudo',['dpkg-divert', '--local', '--divert', '/usr/bin/ack', '--rename', '--add', '/usr/bin/ack-grep'])
  makeAckWork.stdout.on('data', function _makeAckWork(data) {
    console.log('' + data);
  });
  makeAckWork.stderr.on('data', function _makeAckWorkError(data) {
    console.log('makeAckWork stderr: ' + data);
  });
  makeAckWork.on('close', _aftermakeAckWork);
}
function _aftermakeAckWork(code){
  if (code !== 0) {
    return console.log('makeAckWork process exited with code ' + code);
  }
  console.log('')
  console.log('')
  console.log('Thank you for installing dotfiles: Ubuntu basic.')
}

