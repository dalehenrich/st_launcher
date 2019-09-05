#!/usr/local/bin/smalltalk/gemstone/st_launcher
"
This script provides support for recording and querying test results from Rowan test runs.
	The standard Rowan test script produces a JSON file that matches the structure
	of the RwsTestSuiteSample class. The `--load` option will cause the 
	`testResult.json` file produced by a test run to be loaded and persisted in
	the name GemStone db: 

	--load=<json-file-path>
		<json-file-path> is the path to the json file (`testResults.json`) produced by the 
		test script. If the `--compare` option is NOT specified, the object in the json file will be added
		to the suite samples, followed by a commit. If the `--compare` option is specified, the object in 
		the json file will not be added to the suite samples.

	--branch=<branch-name>
		<branch-name> is the name of the branch upon which the test is run. The `restResults.json`
		file does not contain the git branch for the test run. If not specified, `masterV0.1` is used.

	--reset
		When present, the collection of suite samples is emptied. `--reset` may be used with other
		options and it is performed before the other operations are performed. The `--reset` option 
		and `--compare` options should not be used together.

	--compare=<gemstone-version>
		Compare the RwsTestSuiteSample defined in the json file specified by the `--load` option to the 
		last recorded RwsTestSuiteSample sample for the given <gemstone-version> and `--branch`. The
		default branch (masterV0.1) is used if the `--branch` option is not spedified. The `--reset` option
		and `--compare` options should not be used together.
"
Class {
	#name : 'RwsTestStatsRecord',
	#superclass : 'AbstractProgram',
	#instVars : [
		'jsonFile',
		'branch',
		'resetSuiteSamples',
		'gsVersionToCompare'
	],
	#category : 'RWSTestStats-GemStone-Scripts'
}

{ #category : 'private' }
RwsTestStatsRecord >> _suiteSamplesFrom: aFileReference [
	^ (self _testSuiteSampleClass fromJson: aFileReference)
		branch: self branch;
		yourself
]

{ #category : 'private' }
RwsTestStatsRecord >> _testSuiteSampleClass [
	^ self globalNamed: 'RwsTestSuiteSample' 
]

{ #category : 'accessing' }
RwsTestStatsRecord >> branch [

	branch ifNil: [ ^ 'masterV0.1' ].
	^ branch
]

{ #category : 'options' }
RwsTestStatsRecord >> branch: aString [

	branch := aString
]

{ #category : 'options' }
RwsTestStatsRecord >> compare: aGsVersionString [

	gsVersionToCompare := aGsVersionString
]

{ #category : 'accessing' }
RwsTestStatsRecord >> jsonFile [

	jsonFile ifNil: [ self error: 'Required --load option not specified' ].
	^ jsonFile
]

{ #category : 'options' }
RwsTestStatsRecord >> jsonFile: aStringOrFileReference [

	jsonFile := aStringOrFileReference asFileReference
]

{ #category : 'main' }
RwsTestStatsRecord >> main [
	| suiteSample |
	self resetSuiteSamples
		ifTrue: [ 
			gsVersionToCompare
				iNotNil: [ 
					self
						error:
							'Not allowed to use the --compare option and --reset option together' ].
			self _testSuiteSampleClass resetSuiteSamples.
			self commit
				ifFalse: [ 
					self stderr nextPutAll: System detailedConflictReportString.
					self error: 'Commit conflict resetting samples' ] ].
	jsonFile
		ifNil: [ 
			gsVersionToCompare
				ifNotNil: [ 
					self
						error:
							'The --load option must be specified for the --compare option to have an effect.' ] ]
		ifNotNil: [ 
			suiteSample := self _suiteSamplesFrom: self jsonFile.
			gsVersionToCompare
				ifNotNil: [ 
					^ self _testSuiteSampleClass
						compareLatestTestCasesFor: gsVersionToCompare
						branch: self branch
						to: suiteSample
						on: self stderr ]
				ifNil: [ 
					self _testSuiteSampleClass suiteSamples add: suiteSample.
					self commit
						ifFalse: [ 
							self stderr nextPutAll: System detailedConflictReportString.
							self error: 'Commit conflict updating suiteSamples' ] ] ].
	^ true
]

{ #category : 'options' }
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
			#('compare' nil #'required' #compare:).
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

	', scriptName, ' --load=testResults.json --compare=3.5.0
	', scriptName, ' --load=testResults.json --branch=issue_308 --compare=3.5.0
'
]

{ #category : 'usage' }
RwsTestStatsRecord >> usageSynopsis: scriptName [
	^	(super usageSynopsis: scriptName), ' [--reset | --load=<json-file-path> [ --reset | --compare=<gs-version> ] ] \
		[ --branch=<branch-name> ]'
]
