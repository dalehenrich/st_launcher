#!/usr/bin/env bash

if [ -z ${ST_LAUNCHER_HOME+x} ]; then
	export ST_LAUNCHER_HOME="`pwd`/home"
fi

testHello_explicitmage_1() {
	# execute without error
  result=`bin/hello.st admin_pharo_70 --`
	status=$?
	th_validateHello "testHello_exlicitImage" "$status" "$result"
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

