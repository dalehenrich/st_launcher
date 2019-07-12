#!/usr/bin/env bash

# Demo sample_script.sh tests

testSampleScriptParameters() {
  # Load sample_script.sh for testing
  . sample_script.sh

  echo "Executing 3 Asserts..."

  assertTrue 'Check default DEMO_PATH' "[ '${DEMO_PATH}' == '/bin/bash' ]"
  assertTrue 'Check valid DEMO_INT values' "[ $DEMO_INT -ge 0 -a $DEMO_INT -le 2 ]"
  assertTrue 'Check that DEMO_ARRAY is not empty' "[ ${#DEMO_ARRAY[@]} -ne 0 ]"
}

. travis_tests/shunit2-2.1.7/shunit2
