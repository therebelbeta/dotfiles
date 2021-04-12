echo "Loading Tool: Circle"

setup-circle () {
  org=$(basename $(dirname $(pwd)))
  repo=$(basename $(pwd))

  base_url="https://circleci.com/api/v1.1/project/github/${org}/${repo}"

  usage() {
  	echo "circle cmd must be run from git directory"
  	exit 1
  }

  if [[ ! -d .git ]];
  then
  	usage
  fi

  api() {
    curl "$base_url/$2?circle-token=$CIRCLE_TOKEN" \
      -X $1 \
      -H "Content-Type: application/json" \
      -H "Accept: application/json" \
      -d "$3"
    echo
  }

  echo enabling project
  api POST "follow"

  echo enabling notifications
  # api PUT "settings" '{"slack_webhook_url": "https://hooks.slack.com/services/aaa/bbb/ccc"}'

  echo adding npm auth
  # api POST "envvar" '{"name":"NPM_AUTH","value":""}'
  echo npm auth not yet set up

  echo adding gh login
  api POST "envvar" "{\"name\":\"GH_LOGIN\",\"value\":\"$WORK_GITHUB_TOKEN\"}"
  echo gh login not yet set up

  echo adding docker
  api POST "envvar" "{\"name\":\"DOCKER_EMAIL\",\"value\":\"$WORK_DOCKER_EMAIL\"}"
  api POST "envvar" "{\"name\":\"DOCKER_USER\",\"value\":\"$WORK_DOCKER_USER\"}"
  api POST "envvar" "{\"name\":\"DOCKER_PASS\",\"value\":\"$WORK_DOCKER_PASSWORD\"}"

  echo adding now deployment variables
  api POST "envvar" "{\"name\":\"NOW_TOKEN\",\"value\":\"$WORK_NOW_TOKEN\"}"
  api POST "envvar" "{\"name\":\"NOW_TEAM\",\"value\":\"$WORK_NOW_TEAM\"}"

  echo adding github checkout key
  api POST "checkout-key" '{"type":"github-user-key"}'

  echo finished setting up circle for "${org}/${repo}"
}
