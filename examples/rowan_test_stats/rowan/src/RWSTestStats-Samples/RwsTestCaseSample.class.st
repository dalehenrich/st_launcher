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
	sampleDict keysAndValuesDo: [:key :value |
		newTestCaseSample perform: (key, ':') with: value ].
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

{ #category : 'printing' }
RwsTestCaseSample >> printOn: aStream [ 
	aStream
		nextPutAll: self class name;
		nextPut: $(;
		nextPutAll: self className, ' debug: ', self selector printString;
		nextPut: $)
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
