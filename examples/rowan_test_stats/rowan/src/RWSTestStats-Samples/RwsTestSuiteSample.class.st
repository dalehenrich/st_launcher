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

{ #category : 'comparison' }
RwsTestSuiteSample class >> compareLatestTestCasesFor: aGsVersion branch: aBranch to: testSuiteSample on: aWriteStream [
	| latestTestSuiteSample |
	latestTestSuiteSample := self
		latestQuerySuiteSampleFor: aBranch
		andVersion: aGsVersion.
	^ latestTestSuiteSample compareTo: testSuiteSample on: aWriteStream
]

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

{ #category : 'queries' }
RwsTestSuiteSample class >> latestQuerySuiteSampleFor: branch andVersion: gsVersion [
	"return the latest suite sample for the given <branch> and <gsVersion>. Return nil if no sample satisfies the query"

	| query stream |
	query := RwsTestSuiteSample querySuiteSamples: 'each.timeStamp < x'.
	query
		bind: 'x'
		to:
			DateAndTime now
				+
					(Duration
						days: 1
						hours: 0
						minutes: 0
						seconds: 0).
	stream := query reversedReadStream.
	[ stream atEnd ]
		whileFalse: [ 
			| sample |
			sample := stream next.
			(sample branch = branch and: [ sample gsVersion = gsVersion ])
				ifTrue: [ ^ sample ] ].
	^ nil
]

{ #category : 'instance creation' }
RwsTestSuiteSample class >> new [

	^ self basicNew initialize
]

{ #category : 'queries' }
RwsTestSuiteSample class >> querySuiteSamples: queryString [
	"
		RwsTestSuiteSample suiteSamples.

		(RwsTestSuiteSample querySuiteSamples: '(each.branch = ''issue_308'') & (each.gsVersion = ''3.5.0'')') asArray.
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

{ #category : 'comparison' }
RwsTestSuiteSample >> _testCaseSampleMaps [
	| pass fail error |
	pass := Dictionary new.
	fail := Dictionary new.
	error := Dictionary new.
	(self queryTestCases: 'each.status == #passed')
		do: [ :testCaseSample | 
			(pass at: testCaseSample className ifAbsentPut: [ IcuSortedCollection new ])
				add: testCaseSample selector ].
	(self queryTestCases: 'each.status == #failure')
		do: [ :testCaseSample | 
			(fail at: testCaseSample className ifAbsentPut: [ IcuSortedCollection new ])
				add: testCaseSample selector ].
	(self queryTestCases: 'each.status == #error')
		do: [ :testCaseSample | 
			(error at: testCaseSample className ifAbsentPut: [ IcuSortedCollection new ])
				add: testCaseSample selector ].
	^ { pass . fail . error}
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

{ #category : 'comparison' }
RwsTestSuiteSample >> compareSelectorsIn: myDict for: theClassName against: theirDict label: label on: aWriteStream [
	| mySortedSelectors theirSortedSelectors mySelectorIndex theirSelectorIndex mySelectorsSize theirSelectorsSize  |
	mySortedSelectors := myDict at: theClassName.
	theirSortedSelectors := theirDict at: theClassName.
	mySortedSelectors asArray = theirSortedSelectors asArray
		ifTrue: [ 
			"no diffs"
			^ true ].
	mySelectorIndex := 1.
	theirSelectorIndex := 1.
	mySelectorsSize := mySortedSelectors size.
	theirSelectorsSize := theirSortedSelectors size.
	[ 
	mySelectorIndex <= mySelectorsSize
		and: [ theirSelectorIndex <= theirSelectorsSize ] ]
		whileTrue: [ 
			| mySelector theirSelector |
			mySelector := mySortedSelectors atOrNil: mySelectorIndex.
			theirSelector := theirSortedSelectors atOrNil: theirSelectorIndex.
			mySelector = theirSelector
				ifTrue: [ 
					"selector present in both lists ... go on to next selector"
					mySelectorIndex := mySelectorIndex + 1.
					theirSelectorIndex := theirSelectorIndex + 1 ]
				ifFalse: [ 
					mySelector < theirSelector
						ifTrue: [ 
							aWriteStream
								nextPutAll: '+ ' , theClassName , '>>' , mySelector;
								lf.
							mySelectorIndex := mySelectorIndex + 1 ]
						ifFalse: [ 
							aWriteStream
								nextPutAll: '- ' , theClassName , '>>' , theirSelector;
								lf.
							theirSelectorIndex := theirSelectorIndex + 1 ] ] ].
	^ false
]

{ #category : 'comparison' }
RwsTestSuiteSample >> compareTo: testSuiteSample on: aWriteStream [
	"answer the differences for passed, errors, and failures between the receiver and <testSuiteSample>"

	| mySampleMaps theirSampleMaps labels noDiffs |
	mySampleMaps := self _testCaseSampleMaps.
	theirSampleMaps := testSuiteSample _testCaseSampleMaps.
	labels := {'Passed'.
	'failed'.
	'errored'}.
	noDiffs := true.
	1 to: 3 do: [ :index | 
		| label myDict theirDict myKeys theirKeys myKey theirKey myKeyIndex theirKeyIndex myKeysSize theirKeysSize |
		label := labels at: index.
		myDict := mySampleMaps at: index.
		theirDict := theirSampleMaps at: index.
		myKeys := myDict keys asArray sort.
		theirKeys := theirDict keys asArray sort.
		myKeyIndex := 1.
		theirKeyIndex := 1.
		myKeysSize := myKeys size.
		theirKeysSize := theirKeys size.
		[ myKeyIndex <= myKeysSize and: [ theirKeyIndex <= theirKeysSize ] ]
			whileTrue: [ 
				myKey := myKeys atOrNil: myKeyIndex.
				theirKey := theirKeys atOrNil: theirKeyIndex.
				aWriteStream
					tab;
					nextPutAll:
							'MY ' , label asUppercase , ' ' , myKeyIndex printString , '('
									, myKeysSize printString , ')';
					lf.
				aWriteStream
					tab;
					nextPutAll:
							'THEIRS ' , label asUppercase , ' ' , theirKeyIndex printString , '('
									, theirKeysSize printString , ')';
					lf.
				myKey = theirKey
					ifTrue: [ 
						(self
							compareSelectorsIn: myDict
							for: myKey
							against: theirDict
							label: label
							on: aWriteStream)
							ifFalse: [ noDiffs := false ].
						myKeyIndex := myKeyIndex + 1.
						theirKeyIndex := theirKeyIndex + 1 ]
					ifFalse: [ 
						noDiffs := false.
						myKey < theirKey
							ifTrue: [ 
								aWriteStream
									nextPutAll: 'No ' , label , ' >> entries for ' , myKey printString;
									lf.
								myKeyIndex := myKeyIndex + 1 ]
							ifFalse: [ 
								aWriteStream
									nextPutAll: 'No ' , label , ' >> entries for ' , theirKey printString;
									lf.
								theirKeyIndex := theirKeyIndex + 1 ] ] ] ].
	^ noDiffs
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
