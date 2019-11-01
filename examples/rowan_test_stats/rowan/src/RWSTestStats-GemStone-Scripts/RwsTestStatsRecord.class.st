#!/usr/local/bin/smalltalk/gemstone/st_launcher
"
This script provides support for recording and querying test results from Rowan test runs.
	The standard Rowan test script produces a JSON file that matches the structure
	of the RwsTestSuiteSample class.

	Sample expression for removing a bad sample:

		(RwsTestSuiteSample querySuiteSamples: '(each.branch=''issue_527'')') asArray
			do: [:each | RwsTestSuiteSample suiteSamples remove: each ]

	The `--load` option will cause the `testResult.json` file produced by a test
	run to be loaded and persisted in the name GemStone db: 

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

	--updateSHA=<git-commit-SHA>
		Updates the commitSha of the latest test suite sample for the given branch. This option should not
		be used with the `--reset`, `--compare` and `--load` options.

	--query[=summary]
		Perform a query using the --branch and --gsVersion values to narrow the search. If the `summary` 
		argument is specified, a summary of the query results will be written to stderr. Without the `summary` 
		argument, the query result will be written to objOut.
"
Class {
	#name : 'RwsTestStatsRecord',
	#superclass : 'AbstractProgram',
	#instVars : [
		'jsonFile',
		'branch',
		'resetSuiteSamples',
		'gsVersionToCompare',
		'updateSHA',
		'gsVersion',
		'query'
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
RwsTestStatsRecord >> gsVersion [

	gsVersion ifNil: [ ^ '3.5.0' ].
	^ gsVersion
]

{ #category : 'options' }
RwsTestStatsRecord >> gsVersion: aString [

	gsVersion := aString
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
			updateSHA
				ifNotNil: [ 
					self
						error:
							'Not allowed to use the --updateSHA option and --reset option together' ].
			self _testSuiteSampleClass resetSuiteSamples.
			self commit
				ifFalse: [ 
					self stderr nextPutAll: System detailedConflictReportString.
					self error: 'Commit conflict resetting samples' ] ].
	jsonFile
		ifNil: [ 
			updateSHA
				ifNotNil: [ 
					(self _testSuiteSampleClass
						latestQuerySuiteSampleFor: self branch
						andVersion: self gsVersion) commitSha: updateSHA.
					self commit
						ifFalse: [ 
							self stderr nextPutAll: System detailedConflictReportString.
							self error: 'Commit conflict updating suiteSamples' ] ]
				ifNil: [ 
					query
						ifNotNil: [ 
							self performQuery.
							^ self sentinelObject ].
					gsVersionToCompare
						ifNotNil: [ 
							self
								error:
									'The --load option must be specified for the --compare option to have an effect.' ] ] ]
		ifNotNil: [ 
			updateSHA
				ifNotNil: [ 
					self
						error:
							'Not allowed to use the --updateSHA option and --load option together' ].
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

{ #category : 'query' }
RwsTestStatsRecord >> performQuery [
	| queryResult |
	queryResult := branch isNil & gsVersion isNil
		ifTrue: [ 
			"answer the full collection"
			self _testSuiteSampleClass suiteSamples asArray ]
		ifFalse: [ 
			| queryStream hasTerm |
			queryStream := WriteStream on: String new.
			queryStream nextPutAll: '('.
			hasTerm := false.
			branch
				ifNotNil: [ 
					queryStream nextPutAll: '(each.branch = ' , self branch printString , ')'.
					hasTerm := true ].
			gsVersion
				ifNotNil: [ 
					hasTerm
						ifTrue: [ queryStream nextPutAll: ' & ' ].
					queryStream
						nextPutAll: '(each.gsVersion = ' , self gsVersion printString , ')' ].
			queryStream nextPutAll: ')'.
			(self _testSuiteSampleClass querySuiteSamples: queryStream contents) asArray ].
	query = 'summary'
		ifTrue: [ 
			self stderr lf.
			(queryResult sort: [ :a :b | a timeStamp <= b timeStamp ])
				do: [ :each | 
					self stderr
						nextPutAll: each printString;
						lf ]	]
		ifFalse: [ self objOut nextPut: queryResult ]
]

{ #category : 'options' }
RwsTestStatsRecord >> query: aQueryParameter [

	query := aQueryParameter ifNil: [ 'std' ]
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
			#('updateSHA' nil #'required' #updateSHA:).
			#('gsVersion' nil #'required' #gsVersion:).
			#('query' nil #'optional' #query:).
	}
]

{ #category : 'options' }
RwsTestStatsRecord >> updateSHA: aSHA [

	updateSHA := aSHA
]

{ #category : 'usage' }
RwsTestStatsRecord >> usageExamples: scriptName [
	^	scriptName, ' --load=testResults.json
	', scriptName, ' --load=testResults.json --branch=issue_308

	', scriptName, ' --reset
	', scriptName, ' --load=testResults.json  --reset --branch=issue_308

	', scriptName, ' --load=testResults.json --compare=3.5.0
	', scriptName, ' --load=testResults.json --branch=issue_308 --compare=3.5.0

	', scriptName, ' --updateSHA=92de7b5  --branch=issue_308 --gsVersion=3.2.15

	', scriptName, ' --query  --branch=issue_308 --gsVersion=3.2.15
	', scriptName, ' --query=summary  --branch=issue_308 --gsVersion=3.2.15

	', scriptName, ' --query
	', scriptName, ' --query=summary 
'
]

{ #category : 'usage' }
RwsTestStatsRecord >> usageSynopsis: scriptName [
	^	(super usageSynopsis: scriptName), '  --query[=summary ]  [ --branch=<branch-name> ] [ --gsVersion=<gs-version> ]
	', scriptName, ' --updateSHA=<commit-sha>  [ --branch=<branch-name> ] [ --gsVersion=<gs-version> ]
	', scriptName, ' --load=<json-file-path> [ --reset ] [ --branch=<branch-name> ]
	', scriptName, ' --load=<json-file-path> --compare=<gs-version>  [ --reset ] [ --branch=<branch-name> ]
'
]
