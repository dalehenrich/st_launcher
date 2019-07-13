#!/usr/bin/env bash

# Demo sample_script.sh tests

testHello() {
	# execute without error
  bin/hello.st
}

. travis_tests/shunit2-2.1.7/shunit2
