Class {
	#name : 'RwsTestSuiteSample',
	#superclass : 'Object',
	#instVars : [
		'suiteName',
		'properties',
		'testCases',
		'resultsSummary',
		'timeStamp',
		'notes',
		'gsVersion'
	],
	#classVars : [
		'suiteSamples'
	],
	#category : 'RWSTestStats-Samples'
}

{ #category : 'instance creation' }
RwsTestSuiteSample class >> fromDictionary: sampleDict [

	| newSuiteSample |
	newSuiteSample := self new.
	sampleDict keysAndValuesDo: [:key :value |
		newSuiteSample perform: (key, ':') with: value ].
	^ newSuiteSample
]

{ #category : 'instance creation' }
RwsTestSuiteSample class >> fromJson: filePath [
	| fileRef sampleDict |
	fileRef := filePath asFileReference.
	fileRef
		readStreamDo: [ :fileStream | 
			| bufferedStream |
			bufferedStream := ZnBufferedReadStream on: fileStream.
			bufferedStream sizeBuffer: fileRef size.
			sampleDict := STON fromStream: bufferedStream ].
	^ self fromDictionary: sampleDict
]

{ #category : 'accessing' }
RwsTestSuiteSample class >> resetSuiteSamples [
	suiteSamples := nil
]

{ #category : 'accessing' }
RwsTestSuiteSample class >> suiteSamples [
	"
		RwsTestSuiteSample suiteSamples add: 
			(RwsTestSuiteSample fromJson: '/home/dhenrich/rogue/_homes/rogue/_home/server/stones/test_rowan_dev_350/testResults.json')
	"

	^ suiteSamples ifNil: [ suiteSamples := RcLowMaintenanceIdentityBag new ]
]

{ #category : 'accessing' }
RwsTestSuiteSample >> gsVersion [
	^ gsVersion
]

{ #category : 'accessing' }
RwsTestSuiteSample >> gsVersion: aString [
	gsVersion := aString
]

{ #category : 'accessing' }
RwsTestSuiteSample >> notes [
	^ notes
]

{ #category : 'accessing' }
RwsTestSuiteSample >> notes: aString [
	notes := aString
]

{ #category : 'accessing' }
RwsTestSuiteSample >> properties [
	^ properties
]

{ #category : 'accessing' }
RwsTestSuiteSample >> properties: aDictionary [
	properties := aDictionary
]

{ #category : 'accessing' }
RwsTestSuiteSample >> resultsSummary [
	^ resultsSummary
]

{ #category : 'accessing' }
RwsTestSuiteSample >> resultsSummary: aDictionary [
	resultsSummary := aDictionary
]

{ #category : 'accessing' }
RwsTestSuiteSample >> suiteName [
	^ suiteName
]

{ #category : 'accessing' }
RwsTestSuiteSample >> suiteName: aString [
	suiteName := aString
]

{ #category : 'accessing' }
RwsTestSuiteSample >> testCases [
	^ testCases ifNil: [ testCases := RcLowMaintenanceIdentityBag new ]
]

{ #category : 'accessing' }
RwsTestSuiteSample >> testCases: anArrayOfTestCaseSampleDictionaries [
	anArrayOfTestCaseSampleDictionaries
		do: [ :sampleDict | 
			| testCaseSample |
			testCaseSample := RwsTestCaseSample fromDictionary: sampleDict.
			testCaseSample suite: self.
			self testCases add: testCaseSample ]
]

{ #category : 'accessing' }
RwsTestSuiteSample >> timeStamp [
	^ timeStamp
]

{ #category : 'accessing' }
RwsTestSuiteSample >> timeStamp: aDateAndTimeOrString [
	timeStamp := aDateAndTimeOrString isString
		ifTrue: [ DateAndTime fromString: aDateAndTimeOrString ]
		ifFalse: [ aDateAndTimeOrString ]
]
