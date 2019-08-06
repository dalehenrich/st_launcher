#!/usr/local/bin/smalltalk/gemstone/st_launcher
"
Display a Roassal pie chart based on StL_ObjOut_Sample instances read from objIn.

	Since GemStone does not have a GUI, this script currently should be run against 
	a pharo image.

	The collection of object used to create the pie chart are read from `objIn` using
	STON format.

	`objIn` is a STONReader stream on `stdin`.

	-
		Read objects from objIn

	With no arguments an empty pie chart is displayed.
"
Class {
	#name : 'StL_Pie',
	#superclass : 'AbstractProgram',
	#instVars : [
		'sampleObjects'
	],
	#category : 'st_launcher-Scripts'
}

{ #category : 'main' }
StL_Pie >> main [

	sampleObjects := OrderedCollection new.

	"read objects from objIin"
	[ self objIn atEnd ]
		whileFalse: [
			| obj |
			obj := self objIn next.
			sampleObjects add: obj ].
	self makePie.
	^ true
]

{ #category : 'pie' }
StL_Pie >> makePie [
	"create the pie chart"

	| builder |
	builder := (self globalNamed: 'RTPieBuilder') new.
	builder interaction popup.
	builder objects: self sampleObjects.
	builder slice: #value.
	builder normalizer distinctColor.
	builder labeled.
	^ builder
]

{ #category : 'accessing' }
StL_Pie >> sampleObjects [

	^ sampleObjects ifNil: [ sampleObjects := {} ]
]

{ #category : 'accessing' }
StL_Pie >> sampleObjects: aCollection [

	sampleObjects := aCollection
]

{ #category : 'options' }
StL_Pie >> scriptMethodOptions [
	^ {
			#('help' $h  #none).
			#('info' nil #none).
	}
]

{ #category : 'usage' }
StL_Pie >> usageExamples: scriptName [

	^	scriptName, ' pharo --
	', scriptName, ' pharo -- - < object.ston
'
]

{ #category : 'usage' }
StL_Pie >> usageStandardExamples: scriptName [

	^ scriptName, ' pharo -- -h
	', scriptName, ' pharo -- --help
	', scriptName, ' pharo -- --info

	', scriptName, ' pharo -- --info

	'
]
