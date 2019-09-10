#!/usr/local/bin/smalltalk/gemstone/st_launcher
"
Template script for writing ad hoc queries agains the rowan-tests_stats db
"
Class {
	#name : 'WS_',
	#superclass : 'AbstractProgram',
	#instVars : [
	],
	#category : 'st_launcher-Workspaces'
}

{ #category : 'accessing' }
WS_ >> branch [
	| branch |
	branch := 'issue_493'.
	branch := 'issue_308'.
	^branch
]

{ #category : 'accessing' }
WS_ >> className [
	| className |
	className := 'RwRowanIssue493Test'.
	className := 'RwRowanSample4Test'.
	^className
]

{ #category : 'accessing' }
WS_ >> gsVersion [
	| gsVersion |
	gsVersion := '3.5.0'.
	^gsVersion
]

{ #category : 'queries' }
WS_ >> testSuiteCompareSamples_1 [
	| testSuiteSample_1 testSuiteSample_2 |
	testSuiteSample_1 := self _testSuiteSampleClass latestQuerySuiteSampleFor: 'issue_308' andVersion: self gsVersion.
	testSuiteSample_2 := self _testSuiteSampleClass latestQuerySuiteSampleFor: 'issue_493' andVersion: self gsVersion.
	self stderr nextPutAll: 'Comparing issue_308 to issue_493'; lf.
	testSuiteSample_1 compareTo: testSuiteSample_2 on: self stderr
]

{ #category : 'queries' }
WS_ >> testSuiteQuery_1 [

	| query branch gsVersion testSuiteSample className |
	gsVersion := self gsVersion.
	branch := self branch.
	testSuiteSample := self _testSuiteSampleClass latestQuerySuiteSampleFor: branch andVersion: gsVersion.
	className := self className.
	#(passed failures errors) do: [:status |
		self stderr nextPutAll: status; lf.
		query := testSuiteSample queryTestCases: '((each.className = ', className printString, ') & (each.status = x))'.
		query bind: 'x' to: status.
		(query asArray 
			sort: [:a :b | a selector < b selector])
				do: [:each | self stderr tab; nextPutAll: each printString; lf ]]
]

{ #category : 'queries' }
WS_ >> testSuiteQuery_2 [

	| query gsVersion branch testSuiteSample className |
	gsVersion := self gsVersion.
	branch := self branch.
	testSuiteSample := self _testSuiteSampleClass latestQuerySuiteSampleFor: branch andVersion: gsVersion.
	#(passed failures errors) do: [:status |
		self stderr nextPutAll: status; lf.
		query := testSuiteSample queryTestCases: '(each.status = x)'.
		query bind: 'x' to: status.
		(query asArray 
			select: [:sample | (sample selector includesString: '493') or: [sample className includesString: '493' ]])
				do: [:each | self stderr tab; nextPutAll: each printString; lf ]]
]

{ #category : 'queries' }
WS_ >> testSuiteQuery_3 [
	| testSuiteSample_old testSuiteSample_new stream oldSHA newSHA |
	oldSHA := '74a12aa'.
	newSHA := '68f6a46'.
	testSuiteSample_old :=  (RwsTestSuiteSample querySuiteSamples: '((each.gsVersion = ', self gsVersion printString, ') & (each.branch = ', self branch printString, ') & (each.commitSha = ', oldSHA printString, '))') asArray first.
	testSuiteSample_new := (RwsTestSuiteSample querySuiteSamples: '((each.gsVersion = ', self gsVersion printString, ') & (each.branch = ', self branch printString, ') & (each.commitSha = ', newSHA printString, '))') asArray first.
	self stderr nextPutAll: '3.5.0; issue_308 ', oldSHA, ' to ', newSHA ; lf.
	testSuiteSample_new compareTo: testSuiteSample_old on: self stderr
]

{ #category : 'main' }
WS_ >> main [
	^self testSuiteQuery_3
]

{ #category : 'private' }
WS_ >> _testSuiteSampleClass [
	^ self globalNamed: 'RwsTestSuiteSample' 
]


WS_ >> usageExamples: scriptName [

	^	scriptName, '
	', scriptName, ' -D --		# debug errors
'
]


