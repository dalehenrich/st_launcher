#!/usr/bin/env bash

if [ -z ${ST_LAUNCHER_HOME+x} ]; then
	export ST_LAUNCHER_HOME="`pwd`/home"
fi

testHello() {
	# execute without error
  result=`bin/hello.st`
	status=$?
	assertEquals "testHello: exit status" \
		'0' "$status"
	assertEquals "testHello: wrong output" \
		'hello world' "$result"
}

oneTimeSetUp() {
	outputDir="${SHUNIT_TMPDIR}/output"
  mkdir "${outputDir}"
  stdoutF="${outputDir}/stdout"
  stderrF="${outputDir}/stderr"
}

. travis_tests/shunit2-2.1.7/shunit2_test_helpers
. travis_tests/shunit2-2.1.7/shunit2

