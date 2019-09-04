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
		'gsVersion',
		'branch',
		'commitSha'
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

{ #category : 'instance creation' }
RwsTestSuiteSample class >> new [

	^ self basicNew initialize
]

{ #category : 'queries' }
RwsTestSuiteSample class >> querySuiteSamples: queryString [
	"
		RwsTestSuiteSample suiteSamples 
			querySuiteSamples: 'each.branch == ''masterV0.1''' ) size
	"

	^ GsQuery fromString: queryString on: self suiteSamples
]

{ #category : 'accessing' }
RwsTestSuiteSample class >> resetSuiteSamples [
	"
		RwsTestSuiteSample resetSuiteSamples
	"
	suiteSamples := nil
]

{ #category : 'accessing' }
RwsTestSuiteSample class >> suiteSamples [
	"
		RwsTestSuiteSample suiteSamples add: 
			(RwsTestSuiteSample fromJson: '/home/dhenrich/rogue/_homes/rogue/_home/server/stones/test_rowan_dev_350/testResults.json')
	"

	^ suiteSamples
		ifNil: [ 
			suiteSamples := RcLowMaintenanceIdentityBag new.
			self suiteSamplesIndexSpec createIndexesOn: suiteSamples.
			suiteSamples ]
]

{ #category : 'indexing' }
RwsTestSuiteSample class >> suiteSamplesIndexSpec [
	| indexOptions |
	indexOptions := GsIndexOptions default + GsIndexOptions reducedConflict.
	^ GsIndexSpec new
		stringOptimizedIndex: 'each.suiteName' options: indexOptions;
		stringOptimizedIndex: 'each.gsVersion' options: indexOptions;
		stringOptimizedIndex: 'each.branch' options: indexOptions;
		stringOptimizedIndex: 'each.commitSha' options: indexOptions;
		equalityIndex: 'each.timeStamp'
			lastElementClass: DateAndTime
			options: indexOptions yourself
]

{ #category : 'accessing' }
RwsTestSuiteSample >> branch [
	^ branch
]

{ #category : 'accessing' }
RwsTestSuiteSample >> branch: aString [
	branch := aString
]

{ #category : 'accessing' }
RwsTestSuiteSample >> commitSha [
	^ commitSha
]

{ #category : 'accessing' }
RwsTestSuiteSample >> commitSha: aString [
	commitSha := aString
]

{ #category : 'accessing' }
RwsTestSuiteSample >> gsVersion [
	^ gsVersion
]

{ #category : 'accessing' }
RwsTestSuiteSample >> gsVersion: aString [
	gsVersion := aString
]

{ #category : 'initialization' }
RwsTestSuiteSample >> initialize [
	branch := commitSha := ''
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

{ #category : 'queries' }
RwsTestSuiteSample >> queryTestCases: queryString [
	"
		status: #passed, #failure, #error

		((RwsTestSuiteSample suiteSamples detect: [:each | true ]) 
			queryTestCases: 'each.status == #passed' ) size

		((RwsTestSuiteSample suiteSamples detect: [:each | true ]) 
			queryTestCases: 'each.className = ''RwProjectTonelReaderWriterTest''' ) size

		((RwsTestSuiteSample suiteSamples detect: [:each | true ]) 
			queryTestCases: '(each.className = ''RwProjectTonelReaderWriterTest'') & (each.status ~~ #passed)' ) size

	"

	^ GsQuery fromString: queryString on: self testCases
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
	^ testCases
		ifNil: [ 
			testCases := RcLowMaintenanceIdentityBag new.
			self testCaseSampleIndexSpec createIndexesOn: testCases.
			testCases ]
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

{ #category : 'indexing' }
RwsTestSuiteSample >> testCaseSampleIndexSpec [
	| indexOptions |
	indexOptions := GsIndexOptions default + GsIndexOptions reducedConflict.
	^ GsIndexSpec new
		stringOptimizedIndex: 'each.className' options: indexOptions;
		symbolOptimizedIndex: 'each.selector' options: indexOptions;
		symbolOptimizedIndex: 'each.status' options: indexOptions;
		yourself
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
