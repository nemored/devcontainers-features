#!/bin/bash
set -e

source dev-container-features-test-lib

check "orchard is installed" command -v orchard
check "orchard reports version" bash -c "orchard --version"

reportResults
