#!/usr/bin/env bash

# Demo sample_script.sh tests

testHello() {
	# execute without error
  bin/hello.st >${stdoutF} 2>${stderrF}
	rtrn=$?
	th_assertTrueWithNoOutput ${rtrn} "${stdoutF}" "${stderrF}"
}

. travis_tests/shunit2-2.1.7/shunit2_test_helpers

. travis_tests/shunit2-2.1.7/shunit2

