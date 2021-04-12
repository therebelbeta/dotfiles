
docker-cleanup() {
  docker rm -v $(docker ps -a -q -f "status=exited")
  docker rmi $(docker images -q -f "dangling=true")
  docker run \
    -v /var/run/docker.sock:/var/run/docker.sock \
    -v /var/lib/docker:/var/lib/docker \
    --rm martin/docker-cleanup-volumes
}

alias d='docker'
alias dc='docker-compose'
alias dm='docker-machine'
alias dcu='docker-cleanup'

alias dockerunset='unset DOCKER_TLS_VERIFY && unset DOCKER_CERT_PATH && unset DOCKER_MACHINE_NAME && unset DOCKER_HOST'
alias freedocker='echo "danglingdocker && cleardanglingdocker"'
alias cleardocker='echo "danglingdocker && cleardanglingdocker"'
alias dockerspace='echo "danglingdocker && cleardanglingdocker"'
alias danglingdocker='docker volume ls --filter dangling=true | wc -l'
alias cleardanglingdocker='docker volume rm $(docker volume ls --filter dangling=true -q)'
sshd () { docker exec -i -t "$@" /bin/sh }