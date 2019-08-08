#!/usr/bin/env bash

if [ -z ${ST_LAUNCHER_HOME+x} ]; then
	export ST_LAUNCHER_HOME="`pwd`/home"
fi

testClean_launcher_home() {
	# needed to clean env vars out of structure properties so testInfoOption_pharo passes
	result=`bin/cleanlauncher_home.st gemstone --`
	assertEquals "testClean_launcher_home" \
		"true" "$result"
}

testTopaz_empty_args() {
	result=`bin/test_args.tpz gemstone -- -lq --`
	assertEquals "testTopaz_empty_args" \
		"EMPTY ARGS" "$result"
}

testTopaz_lone_arg1() {
	result=`bin/test_args.tpz gemstone -- -lq -- LONE`
	assertEquals "testTopaz lone_arg1" \
		"lonearg:LONE" "$result"
}

testTopaz_lone_arg2() {
	result=`bin/test_args.tpz gemstone -- -lq -- L-ONE`
	assertEquals "testTopaz lone_arg2" \
		"lonearg:L-ONE" "$result"
}

testTopaz_option() {
	result=`bin/test_args.tpz gemstone -- -lq -- -l`
	assertEquals "testTopaz option" \
		"option:-l" "$result"
}

testTopaz_option_arg1() {
	result=`bin/test_args.tpz gemstone -- -lq -- -l hello`
	status=$?
	assertEquals "testTopaz option_arg1" \
		"option:-l:arg:hello" "$result"
	assertEquals "testTopaz option_arg1_status" \
		'0' $status
}

testTopaz_option_arg2() {
	result=`bin/test_args.tpz gemstone -- -lq -- -l he-llo`
	assertEquals "testTopaz option_arg2" \
		"option:-l:arg:he-llo" "$result"
}

testTopaz_error() {
	file=`mktemp`
	bin/test_args.tpz gemstone -- -lq -- -e > $file  << EOF
exit
EOF
	status=$?
	assertEquals "testTopaz error_status" \
		'1' $status
}

testHello_explicitmage_pharo() {
  result=`bin/hello.st pharo --`
	status=$?
	th_validateHello "testHello_exlicitImage_pharo" "$status" "$result"
}

testHello_explicitmage_gs() {
  result=`bin/hello.st gemstone --`
	status=$?
	th_validateHello "testHello_exlicitImage_gs" "$status" "$result"
}

testHello_defaultImage() {
  result=`bin/hello.st`
	status=$?
	th_validateHello "testHello_defaultImage" "$status" "$result"
}

testhelpOption_gs() {
  result=`bin/hello.st gemstone -- -h`
	status=$?
	th_validateInfoOption "testhelpOption_gs" "$status" "$result" "NAME"
}

testhelpOption_pharo() {
  result=`bin/hello.st pharo -- -h`
	status=$?
	th_validateInfoOption "testhelpOption_pharo" "$status" "$result" "NAME"
}

testhelpOption_defaultImage() {
  result=`bin/hello.st -h`
	status=$?
	th_validateInfoOption "testhelpOption_defaultImage" "$status" "$result" "NAME"
}

testHelpOption_gs() {
  result=`bin/hello.st gemstone -- --help`
	status=$?
	th_validateInfoOption "testHelpOption_gs" "$status" "$result" "NAME"
}

testHelpOption_pharo() {
  result=`bin/hello.st pharo -- --help`
	status=$?
	th_validateInfoOption "testHelpOption_pharo" "$status" "$result" "NAME"
}

testHelpOption_defaultImage() {
  result=`bin/hello.st --help`
	status=$?
	th_validateInfoOption "testHelpOption_defaultImage" "$status" "$result" "NAME"
}

testInfoOption_gs() {
  result=`bin/hello.st gemstone -- --imageProperties`
	status=$?
	th_validateInfoOption "testInfoOption_gs" "$status" "$result" "StLauncherGemStoneSoloImageProperties {"
}

testInfoOption_pharo() {
  result=`bin/hello.st pharo -- --imageProperties`
	status=$?
	th_validateInfoOption "testInfoOption_pharo" "$status" "$result" "StLauncherPharoImageProperties {"
}

testInfoOption_defaultImage() {
  result=`bin/hello.st --imageProperties`
	status=$?
	th_validateInfoOption "testInfoOption_defaultImage" "$status" "$result" "StLauncherGemStoneSoloImageProperties {"
}

testHello_invalidImageName() {
  result=`bin/hello.st foobar --`
	status=$?
	assertEquals "testHello_invalidImageName: invalid image name error" \
		'1' "$status"
}

testHello_invalidOption() {
  result=`bin/hello.st -x`
	status=$?
# see https://github.com/dalehenrich/st_launcher/issues/4
#	assertEquals "testHello_invalidOption: invalid option error" \
#	'1' "$status"
	assertEquals "testHello_invalidOption: invalid option error" \
	'0' "$status"
}

testHello_invalidOption_gs() {
  result=`bin/hello.st gemstone -- -x`
	status=$?
# see https://github.com/dalehenrich/st_launcher/issues/4
#	assertEquals "testHello_invalidOption: invalid option error" \
#	'1' "$status"
	assertEquals "testHello_invalidOption_gs: invalid option error" \
	'0' "$status"
}

testHello_invalidOption_pharo() {
  result=`bin/hello.st pharo -- -x`
	status=$?
#	see https://github.com/pharo-project/pharo/issues/4174
#	assertEquals "testHello_invalidOption_pharo: invalid option error" \
#	'1' "$status"
	assertEquals "testHello_invalidOption_pharo: invalid option error" \
	'0' "$status"
}

testEvalCmdLine_pharo() {
	th_testEvalCmdLine "pharo"
}

testEvalCmdLine_gemstone() {
	th_testEvalCmdLine "gemstone"
}

testPieStdInOut_pharo() {
	th_testPieStdInOut "pharo"
}

testPieFileInOut_gemstone() {
	th_testPieFileInOut "gemstone"
}

testPieFileInOut_pharo() {
	th_testPieFileInOut "pharo"
}

testSimpleArrayInOut_pharo() {
	th_testSimpleArrayInOut "pharo"
}

th_testSimpleArrayInOut() {
	imageName="$1"
	result=`bin/objInOut.st $imageName -- - < travis_tests/simpleArray.ston`
	status=$?
	th_validateSimpleArray "testSimpleArrayInOut: <${imageName}>" "$status" "$result"
}

th_validateSimpleArray() {
	testName="$1"
	status="$2"
	result="$3"
	assertEquals "$testName: exit status" \
		'0' "$status"
	assertEquals "$testName: wrong output" \
		'[
	8
]' \
		"$result"
}

th_validateInfoOption() {
	testName="$1"
	status="$2"
	result=`echo ${3%%$'\n'*}`
	expected="$4"
	assertEquals "$testName: exit status" \
		'0' "$status"
	assertEquals "$testName: wrong output" "$expected" "$result"
}

th_testEvalCmdLine() {
	imageName="$1"
	expected="7"
	result=`bin/eval.st $imageName -- "3+4"`
	status=$?
	th_validatePie "testEval: <${imageName}>" "$status" "$expected" "$result"
}

th_testPieFileInOut() {
	imageName="$1"
	expected=`cat travis_tests/pie.ston`
	result=`bin/objInOut.st $imageName -- --file=travis_tests/pie.ston`
	status=$?
	th_validatePie "testPieFileInOut: <${imageName}>" "$status" "$expected" "$result"
}

th_testPieStdInOut() {
	imageName="$1"
	expected=`cat travis_tests/pie.ston`
	result=`bin/objInOut.st $imageName -- - < travis_tests/pie.ston`
	status=$?
	th_validatePie "testPieStdInOut: <${imageName}>" "$status" "$expected" "$result"
}

th_validatePie() {
	testName="$1"
	status="$2"
	expected="$3"
	result="$4"
	assertEquals "$testName: exit status" \
		'0' "$status"
	assertEquals "$testName: wrong output" \
		"$expected" "$result"
}

th_validateHello() {
	testName="$1"
	status="$2"
	result="$3"
	assertEquals "$testName: exit status" \
		'0' "$status"
	assertEquals "$testName: wrong output" \
		"'hello world'" "$result"
}

oneTimeSetUp() {
	outputDir="${SHUNIT_TMPDIR}/output"
  mkdir "${outputDir}"
  stdoutF="${outputDir}/stdout"
  stderrF="${outputDir}/stderr"
}

. travis_tests/shunit2-2.1.7/shunit2_test_helpers
. travis_tests/shunit2-2.1.7/shunit2

