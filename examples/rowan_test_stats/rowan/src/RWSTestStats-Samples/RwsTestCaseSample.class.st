Class {
	#name : 'RwsTestCaseSample',
	#superclass : 'Object',
	#instVars : [
		'suite',
		'className',
		'selector',
		'status'
	],
	#category : 'RWSTestStats-Samples'
}

{ #category : 'instance creation' }
RwsTestCaseSample class >> fromDictionary: sampleDict [
	| newTestCaseSample |
	newTestCaseSample := self new.
	sampleDict
		keysAndValuesDo: [ :key :value | newTestCaseSample perform: (key , ':') asSymbol with: value ].
	^ newTestCaseSample
]

{ #category : 'instance creation' }
RwsTestCaseSample class >> new [

	^ self basicNew initialize
]

{ #category : 'accessing' }
RwsTestCaseSample >> className [
	^ className
]

{ #category : 'accessing' }
RwsTestCaseSample >> className: aString [
	className := aString
]

{ #category : 'initialization' }
RwsTestCaseSample >> initialize [
]

{ #category : 'enumerating' }
RwsTestCaseSample >> passed: passedBlock failed: failedBlock errored: erroredBlock [
	self status == #'passed'
		ifTrue: [ ^ passedBlock cull: self ].
	self status == #'errors'
		ifTrue: [ ^ erroredBlock cull: self ].
	self status == #'failures'
		ifTrue: [ ^ failedBlock cull: self ]
]

{ #category : 'printing' }
RwsTestCaseSample >> printOn: aStream [ 
	aStream nextPutAll: self className, ' debug: ', self selector printString
]

{ #category : 'accessing' }
RwsTestCaseSample >> selector [
	^ selector
]

{ #category : 'accessing' }
RwsTestCaseSample >> selector: aString [
	selector := aString asSymbol
]

{ #category : 'accessing' }
RwsTestCaseSample >> status [
	^ status
]

{ #category : 'accessing' }
RwsTestCaseSample >> status: aString [
	status := aString asSymbol
]

{ #category : 'accessing' }
RwsTestCaseSample >> suite [
	^ suite
]

{ #category : 'accessing' }
RwsTestCaseSample >> suite: aRwsTestCaseSample [
	suite := aRwsTestCaseSample
]

{ #category : 'accessing' }
RwsTestCaseSample >> testSummaryOn: strm [
	| res |
	strm
		nextPutAll:
				suite name , ' for GemStone ' , (System gemVersionAt: #'gsVersion') printString;
		lf.

	strm
		nextPutAll: res printString;
		lf.
	strm
		nextPutAll: '  errors';
		lf.
	(res errors collect: [ :each | each printString ]) asArray sort
		do: [ :each | 
			strm
				tab;
				nextPutAll: each;
				lf ].
	res failures size > 0
		ifTrue: [ 
			strm
				nextPutAll: '  failures';
				lf.
			(res failures collect: [ :each | each printString ]) asArray sort
				do: [ :each | 
					strm
						tab;
						nextPutAll: each;
						lf ] ]
]
