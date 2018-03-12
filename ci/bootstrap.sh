#!/bin/bash
set -eEu
set -o pipefail

################################################################################
# Run "ci/bootstrap" to install dependencies for the test harness.
################################################################################

main() {
  install_precommit
  install_gems
  install_puppet_modules
}

trap finish EXIT

finish() {
  declare -ri RC=$?
  if [[ ${RC} -eq 0 ]]; then
    echo "$0 OK" >&2
  else
    echo "[ERROR] $0" >&2
  fi
}

install_precommit() {
  echo '---> pre-commit'
  if ! command -v pre-commit &> /dev/null; then
    # Install for just this user. Does not need root.
    pip install --user -Iv --compile --no-cache-dir pre-commit
  fi

  pre-commit autoupdate
}

install_gems() {
  echo '---> Install ruby gems'
  readonly LOCAL_BIN_PATH="${PWD}/bin"
  bundle install --path=~/.bundle --binstubs="${LOCAL_BIN_PATH}"
  if ! [[ "${PATH}" =~ ${LOCAL_BIN_PATH} ]]; then
    export PATH="${LOCAL_BIN_PATH}:${PATH}"
  fi
}

install_puppet_modules() {
  echo '---> Install dependent puppet modules'
  bundle exec r10k puppetfile install -v
}

check_whitespace() {
  local -i RC=1
  local output
  echo '---> whitespace'

  # This command identifies whitespace errors and leftover conflict markers.
  # It works only on committed files, so we have to warn on dirty git tree.
  output="$(git diff-tree --check "$(git hash-object -t tree /dev/null)" HEAD)"
  readonly output

  if [[ -z "${output}" ]]; then
    RC=0
    echo OK
  else
    err Found whitespace errors. See below.
    echo "${output}" >&2
  fi

  if is_git_dirty; then
    echo 'Git repo has uncommitted changes; recommend to commit and re-run tests.'
    git status
  fi

  return ${RC}
}

is_git_dirty() {
  [[ -n "$(git diff --shortstat)" ]]
}

main
