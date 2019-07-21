#!/usr/bin/env bash

if [ -z ${ST_LAUNCHER_HOME+x} ]; then
	export ST_LAUNCHER_HOME="`pwd`/home"
fi

testTopaz_empty_args() {
	result=`bin/test_args.tpz admin_gs_350 -- -lq --`
	assertEquals "testTopaz_empty_args" \
		"EMPTY ARGS" "$result"
}

testTopaz_lone_arg1() {
	result=`bin/test_args.tpz admin_gs_350 -- -lq -- LONE`
	assertEquals "testTopaz lone_arg1" \
		"lonearg:LONE" "$result"
}

testTopaz_lone_arg2() {
	result=`bin/test_args.tpz admin_gs_350 -- -lq -- L-ONE`
	assertEquals "testTopaz lone_arg2" \
		"lonearg:L-ONE" "$result"
}

testTopaz_option() {
	result=`bin/test_args.tpz admin_gs_350 -- -lq -- -l`
	assertEquals "testTopaz option" \
		"option:-l" "$result"
}

testTopaz_option_arg1() {
	result=`bin/test_args.tpz admin_gs_350 -- -lq -- -l hello`
	status=$?
	assertEquals "testTopaz option_arg1" \
		"option:-l:arg:hello" "$result"
	assertEquals "testTopaz option_arg1_status" \
		'0' $status
}

testTopaz_option_arg2() {
	result=`bin/test_args.tpz admin_gs_350 -- -lq -- -l he-llo`
	assertEquals "testTopaz option_arg2" \
		"option:-l:arg:he-llo" "$result"
}

testTopaz_error() {
	file=`mktemp`
	bin/test_args.tpz admin_gs_350 -- -lq -- -e > $file  << EOF
exit
EOF
	status=$?
	assertEquals "testTopaz error_status" \
		'1' $status
}

testHello_explicitmage_pharo_1() {
	# execute without error
  result=`bin/hello.st admin_pharo_70 --`
	status=$?
	th_validateHello "testHello_exlicitImage_pharo_1" "$status" "$result"
}

testHello_explicitmage_pharo_2() {
	# execute without error
  result=`bin/hello.st admin_pharo_70`
	status=$?
	th_validateHello "testHello_exlicitImage_pharo_2" "$status" "$result"
}

testHello_explicitmage() {
	# execute without error
  result=`bin/hello.st admin_gs_350 --`
	status=$?
	th_validateHello "testHello_exlicitImage" "$status" "$result"
}

testHello_defaultImage() {
	# execute without error
  result=`bin/hello.st`
	status=$?
	th_validateHello "testHello_defaultImage" "$status" "$result"
}

testHello_invalidImageName() {
# execute without error
  result=`bin/hello.st foobar --`
	status=$?
	assertEquals "testHello_invalidImageName: invalid image name error" \
		'1' "$status"
}

testHello_invalidOption() {
	# execute without error
  result=`bin/hello.st -x`
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

