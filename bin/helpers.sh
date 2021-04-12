#!/bin/bash
#
# Helper functions used by the other scripts.
#


# Some colors to make the output more readable.
GREEN="\033[0;32m"
RED="\033[0;31m"
ORANGE="\033[0;33m"
BLUE="\033[0;34m"
NO_COLOUR="\033[0m"

# Take value from env or use file in home directory.
: ${GITHUB_AUTH_FILE:="$HOME/.github-auth"}

# Helper function that logs the script result and exists with a status code.
function die() {
  if [ $1 == 0 ]; then
    success "SUCCESS!! back in branch $(git_current_branch)."
    exit 0
  else
    error "FAILURE!? ended off in branch $(git_current_branch)."
  fi
}

function bell() {
  tput bel
}

# Logs an error message to stderr and exits with a status code of 1
# Args:
#  message
function error() {
  log "${RED}ERROR: $*${NO_COLOUR}"
  bell
  exit 1
}

# Logs a success message to stderr in green.
# Args:
#  message
function success() {
  log "${GREEN}$*${NO_COLOUR}"
}

# Logs a warning message to stderr in orange.
# Args:
#  message
function warning() {
  log "${ORANGE}$*${NO_COLOUR}"
}

# Logs an info message to stderr in blue.
# Args:
#  message
function info() {
  log "${BLUE}$*${NO_COLOUR}"
}

# Logs an info message to stderr in default color.
# Args:
#  message
function log() {
  echo -e "$*" >&2
}

# Kills the script if a field is blank.
# Args:
#   value to check
#   message
function die_if_blank() {
  if [ -z "$1" ]; then
    error "Exiting due to empty field.  $2"
  fi
}

# Echos out the branch for the current git repository.
function git_current_branch() {
  echo "$(git branch | awk '/\*/ { print $2; }')"
}

# Returns the location of the github authfile.
function get_github_authfile() {
  echo "$GITHUB_AUTH_FILE"
}

# Writes an error if there's no auth information
function ensure_github_auth() {
  if [ -z "$(get_github_credentials)" ]; then
    error "$ERROR_PREFIX Cannot find GitHub credentials"
  fi
}

function ensure_success() {
  if [[ "$1" != '0' ]]; then
    error $2
  fi
}

# Returns the repo path.
function get_repo_path() {
  local repo_path="$(git config remote.origin.url)"
  if [[ $repo_path == http* ]]; then
    # For http URLs.
    repo_path=${repo_path#*\.com\/}
    repo_path=${repo_path%\.git}
  else
    # For ssh URLs.
    repo_path=${repo_path#*:}
    repo_path=${repo_path%\.git}
  fi
  echo $repo_path
}

# Returns the github credentials from osxkeychain.
function get_github_credentials() {
  if [[ -n "${GITHUB_USERNAME:-}" && -n "${GITHUB_PASSWORD:-}" ]]; then
    echo "password=${GITHUB_PASSWORD}"
    echo "username=${GITHUB_USERNAME}"
  else
    printf "protocol=https\nhost=github.com\n" | git credential-osxkeychain get
  fi
}

# Returns the github user name from osxkeychain.
function get_github_username() {
  get_github_credentials | sed -n 's/^username=\(.*\)/\1/p'
}

# Returns the auth token stored in osxkeychain.
function get_github_access_token() {
  get_github_credentials | sed -n 's/^password=\(.*\)/\1/p'
}

function bazel_wrapper() {
  # This requires a medium_bin target in mono//BUILD
  BIN_NAME="${1}"; shift

  if [[ -z "${MONO_HOME}" ]]; then
    export MONO_HOME="$(realpath $(dirname ${0})/../..)"
  fi

  EXE_PATH="${MONO_HOME}/bazel-bin/${BIN_NAME}"
  BZL_S3_PATH="${BZL_S3_PATH:-s3://medium-home/bob/${BIN_NAME}}"
  SHA512SUM="gsha512sum"
  if ! which ${SHA512SUM} > /dev/null 2>&1; then
    SHA512SUM="sha512sum"
  fi

  if [[ -n "${BZL_S3_DOWNLOAD}" ]]; then
    EXE_PATH="${MONO_HOME}/out/${BIN_NAME}"
    source "${MONO_HOME}/script/env.d/30_aws.sh"
    aws_auth
    mkdir -p "$(dirname ${EXE_PATH})"
    if [[ -f "${EXE_PATH}" ]]; then
      sha512=$($SHA512SUM "${EXE_PATH}" | awk '{print $1}')
      latestsha512=$(aws s3 cp "${BZL_S3_PATH}.sha512" -)
      if [[ "${sha512}" != "${latestsha512}" ]]; then
        aws s3 cp "${BZL_S3_PATH}" "${EXE_PATH}"
        chmod +x "${EXE_PATH}"
      fi
    else
      aws s3 cp "${BZL_S3_PATH}" "${EXE_PATH}"
      chmod +x "${EXE_PATH}"
    fi
    exec ${EXE_PATH} $*
  fi

  # We track the bazel version because when it changes, we need to clean and
  # rebuild.
  BZL_VERSION="$(bazel version | awk '/label/ { print $3 }')"
  BZL_VERSION_FILE="${MONO_HOME}/.bazel-version"
  if [[ -f "${BZL_VERSION_FILE}" ]] ; then
    BZL_VERSION_CACHED="$(cat "${BZL_VERSION_FILE}")"
  else
    BZL_VERSION_CACHED=""
  fi

  if [[ -f "${BZL_VERSION_FILE}" ]] ; then
    if [[ "x${BZL_VERSION}" != "x${BZL_VERSION_CACHED}" ]] ; then
      # This will force a rebuild
      rm ${BZL_VERSION_FILE}
    fi
  fi

  pushd "${MONO_HOME}" > /dev/null
  if [[ ! -f "${BZL_VERSION_FILE}" ]] ; then
    bazel clean --expunge
    echo "${BZL_VERSION}" > "${BZL_VERSION_FILE}"
  fi

  if [[ -n "${FORCE_BUILD}" ]]; then
    rm -rf "${EXE_PATH}"
  fi
  if ! bazel build "//:${BIN_NAME}-bin" --check_up_to_date > /dev/null 2>&1; then
    bazel build "//:${BIN_NAME}-bin"
    if [[ -n "${BZL_S3_UPLOAD}" ]]; then
      source "${MONO_HOME}/script/env.d/30_aws.sh"
      aws_auth
      ${SHA512SUM} "${EXE_PATH}" | awk '{print $1}' | aws s3 cp - "${BZL_S3_PATH}.sha512"
      aws s3 cp "${EXE_PATH}" "${BZL_S3_PATH}"
    fi
  fi
  popd > /dev/null
  exec ${EXE_PATH} $@
}

# wrapper for get_default_branch to avoid GitHub API calls
function main_branch() {
    case "$(get_repo_path)" in
        # TODO(everyone): Add converted repos here
        *Medium/picchu | *Medium/hangtag)
            printf "main"
            ;;
        *)
            printf "%s" "$(get_remote_default_branch)"
            ;;
    esac
}

# returns the branch configured as default from GitHub
function get_remote_default_branch() {
  GITHUB_URL="https://api.github.com"

  # Read the repo URL from git and extract the base path.
  repo_path=$(get_repo_path)

  # Read in the auth token.
  token=$(get_github_access_token)

  # get default branch
  branch="$(curl -s -H "Authorization: token ${token}" "${GITHUB_URL}/repos/${repo_path}" | jq -r .default_branch)"
  printf "%s" "$branch"
}
