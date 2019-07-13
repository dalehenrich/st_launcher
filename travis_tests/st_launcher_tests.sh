#!/usr/bin/env bash

# Demo sample_script.sh tests

set -x

. travis_tests/shunit2-2.1.7/shunit2_test_helpers

if [ -z ${ST_LAUNCHER_HOME+x} ]; then
	export ST_LAUNCHER_HOME="`pwd`/home"
fi

testHello() {
	# execute without error
  bin/hello.st admin_gs_350 -V -- >${stdoutF} 2>${stderrF}
	rtrn=$?
	th_assertTrueWithNoOutput ${rtrn} "${stdoutF}" "${stderrF}"
}

oneTimeSetUp() {
	outputDir="${SHUNIT_TMPDIR}/output"
  mkdir "${outputDir}"
  stdoutF="${outputDir}/stdout"
  stderrF="${outputDir}/stderr"
}

. travis_tests/shunit2-2.1.7/shunit2

