#!/usr/local/bin/smalltalk/gemstone/st_launcher
"
This script provides support for recording and querying test results from Rowan test runs.
	The standard Rowan test script produces a JSON file that matches the structure
	of the RwsTestSuiteSample class. The `--load` option will cause the 
	`testResult.json` file produced by a test run to be loaded and persisted in
	the name GemStone db: 

		--load=<json-file-path>
"
Class {
	#name : 'RwsTestStatsRecord',
	#superclass : 'AbstractProgram',
	#instVars : [
		'jsonFile'
	],
	#category : 'RWSTestStats-GemStone-Scripts'
}

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

		RwsTestSuiteSample suiteSamples add: 
			(RwsTestSuiteSample fromJson: self jsonFile)
]

{ #category : 'options' }
RwsTestStatsRecord >> scriptMethodOptions [
	^ super scriptMethodOptions, 
	{
			#('load' nil #'required' #jsonFile:).
	}
]
{ #category : 'usage' }
RwsTestStatsRecord >> usageExamples: scriptName [
	^	scriptName, ' --load=testResults.json
'
]
{ #category : 'usage' }
RwsTestStatsRecord >> usageSynopsis: scriptName [
	^	(super usageSynopsis: scriptName), ' --load=<json-file-path>'
]
