#!/bin/bash
set -eEu
set -o pipefail

################################################################################
# Run `ci/test' to run the test harness.
################################################################################

# Ensure dependencies are up-to-date.
. ci/bootstrap.sh

# Run various checks unrelated to Puppet.
echo '---> pre-commit'
# http://pre-commit.com/#pre-commit-run
readonly DEFAULT_PRECOMMIT_OPTS="--all-files --verbose"
# Allow user to override our defaults by setting an env var.
readonly PRECOMMIT_OPTS="${PRECOMMIT_OPTS:-$DEFAULT_PRECOMMIT_OPTS}"
if ! command -v pre-commit &> /dev/null; then
  ci/bootstrap -v "${VERBOSITY}"
fi
# shellcheck disable=SC2086
pre-commit run ${PRECOMMIT_OPTS}

# Check for whitespace errors.
check_whitespace

# Syntax check Hiera config files.
rake syntax:hiera

# Syntax check Puppet manifests.
rake syntax:manifests

# Syntax check Puppet templates.
rake syntax:templates

# In-module hiera data depends on having a correct metadata.json file.
# It is strongly recommended to use metadata-json-lint to
# automatically check metadata.json file before running rspec.
echo '---> metadata_lint'
rake metadata_lint

# Check ruby code, including rspec, for style.
echo '---> rubocop'
rake rubocop

# Run spec tests.
echo '---> spec'
rake spec
