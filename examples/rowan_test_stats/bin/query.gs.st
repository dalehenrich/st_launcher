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

{ #category : 'main' }
WS_ >> main [
	| query branch gsVersion testSuiteSample className |

	branch := 'issue_308'.
	gsVersion := '3.5.0'.
	testSuiteSample := self _testSuiteSampleClass latestQuerySuiteSampleFor: branch andVersion: gsVersion.
	className := 'RwRowanSample4Test'.
	query := testSuiteSample queryTestCases: '((each.className = ', className printString, ') & (each.status = x))'.
	query bind: 'x' to: #passed.
	(query asArray 
		sort: [:a :b | a selector < b selector])
			do: [:each | self stderr nextPutAll: each printString; lf ]
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

