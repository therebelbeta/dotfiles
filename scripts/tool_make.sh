echo "Loading Tool: Make"

alias mt="make test"
alias mc="make clean"
alias md="make dev"
alias mb="make build"
alias ml="make lint"

targets() {
  cat Makefile | awk '/:/ { if ($1 != ".PHONY:") print $1 }'
}
