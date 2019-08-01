#!/usr/bin/env bash

if [ -z ${ST_LAUNCHER_HOME+x} ]; then
	export ST_LAUNCHER_HOME="`pwd`/home"
fi

testHello_explicitmage_pharo_1() {
	# execute without error
  result=`bin/hello.st pharo --`
	status=$?
	th_validateHello "testHello_exlicitImage" "$status" "$result"
}

testHello_invalidOption_pharo() {
	# execute without error
  result=`bin/hello.st pharo -- -x`
	status=$?
	assertEquals "testHello_invalidOption: invalid option error" \
	'1' "$status"
}

th_validateHello() {
	testName="$1"
	status="$2"
	result="$3"
	assertEquals "$testName: exit status" \
		'0' "$status"
	assertEquals "$testName: wrong output" \
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

