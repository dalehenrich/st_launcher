#!/usr/local/bin/smalltalk/gemstone/st_launcher
"
This script provides support for recording and querying test results from Rowan test runs.
	The standard Rowan test script produces a JSON file that matches the structure
	of the RwsTestSuiteSample class. The `--load` option will cause the 
	`testResult.json` file produced by a test run to be loaded and persisted in
	the name GemStone db: 

	--load=<json-file-path>
		<json-file-path> is the path to the json file (`testResults.json`) produced by the 
		test script. A commit is performed after the load.

	--branch=<branch-name>
		<branch-name> is the name of the branch upon which the test is run. The `restResults.json`
		file does not contain the git branch for the test run. If not specified, `masterV0.1` is used.

	--reset
		When present, the collection of suite samples is emptied. `--reset` may be used with other
		options and it is performed before the other operations are performed.
"
Class {
	#name : 'RwsTestStatsRecord',
	#superclass : 'AbstractProgram',
	#instVars : [
		'jsonFile',
		'branch',
		'resetSuiteSamples'
	],
	#category : 'RWSTestStats-GemStone-Scripts'
}

{ #category : 'private' }
RwsTestStatsRecord >> _testSuiteSampleClass [
	^ self globalNamed: 'RwsTestSuiteSample' 
]

{ #category : 'accessing' }
RwsTestStatsRecord >> branch [

	branch ifNil: [ ^ 'masterV0.1' ].
	^ branch
]

{ #category : 'accessing' }
RwsTestStatsRecord >> branch: aString [

	branch := aString
]

{ #category : 'accessing' }
RwsTestStatsRecord >> jsonFile [

	jsonFile ifNil: [ self error: 'Required --load option not specified' ].
	^ jsonFile
]

{ #category : 'accessing' }
RwsTestStatsRecord >> jsonFile: aStringOrFileReference [

	jsonFile := aStringOrFileReference asFileReference
]

{ #category : 'main' }
RwsTestStatsRecord >> main [
	| suiteSample |
	self resetSuiteSamples
		ifTrue: [ 
			self _testSuiteSampleClass resetSuiteSamples.
			self commit
				ifFalse: [ 
					self stderr nextPutAll: System detailedConflictReportString.
					self error: 'Commit conflict resetting samples' ] ].
	jsonFile
		ifNotNil: [ 
			suiteSample := self _testSuiteSampleClass fromJson: self jsonFile.
			suiteSample branch: self branch.
			self _testSuiteSampleClass suiteSamples add: suiteSample.
			self commit
				ifFalse: [ 
					self stderr nextPutAll: System detailedConflictReportString.
					self error: 'Commit conflict updating suiteSamples' ] ].
	^ true
]

{ #category : 'actions' }
RwsTestStatsRecord >> resetSamples [
	resetSuiteSamples := true
]

{ #category : 'accessing' }
RwsTestStatsRecord >> resetSuiteSamples [
	^ resetSuiteSamples ifNil: [ false ]
]

{ #category : 'options' }
RwsTestStatsRecord >> scriptMethodOptions [
	^ super scriptMethodOptions, 
	{
			#('load' nil #'required' #jsonFile:).
			#('branch' nil #'required' #branch:).
			#('reset' nil #'none' #resetSamples).
	}
]

{ #category : 'usage' }
RwsTestStatsRecord >> usageExamples: scriptName [
	^	scriptName, ' --load=testResults.json
	', scriptName, ' --load=testResults.json --branch=issue_308

	', scriptName, ' --reset
	', scriptName, ' --load=testResults.json  --reset --branch=issue_308
'
]

{ #category : 'usage' }
RwsTestStatsRecord >> usageSynopsis: scriptName [
	^	(super usageSynopsis: scriptName), ' [--reset | --load=<json-file-path> [ --reset ] ] [ --branch=<branch-name> ]'
]
