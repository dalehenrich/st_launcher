#!/usr/local/bin/smalltalk/gemstone/st_launcher
"
Display a Roassal pie chart based on StL_ObjOut_Sample instances read from objIn.

	Since GemStone does not have a GUI, this script currently should be run against 
	a pharo image.

	The collection of object used to create the pie chart are read from `objIn` using
	STON format.

	See the #makePie method for details of pie creation. 

	`objIn` is a STONReader stream on `stdin`.

	-
		Read objects from objIn

	--selector=<slice-selector>
		The message to be sent to the incoming objects to obtain the value to be
		used for calculated the size of the slice of the pie. The default is `count`.

	With no arguments an empty pie chart is displayed.
"
Class {
	#name : 'StL_Pie',
	#superclass : 'AbstractProgram',
	#instVars : [
		'sampleObjects',
		'sliceSelector'
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
	self makePie open.
	^ true
]

{ #category : 'pie' }
StL_Pie >> makePie [
	"create the pie chart"

	| builder |
	builder := (self globalNamed: 'RTPieBuilder') new.
	builder interaction popup.
	builder objects: self sampleObjects.
	builder slice: self sliceSelector.
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
			#('selector' nil #required #sliceSelector: ).
	}
]

{ #category : 'accessing' }
StL_Pie >> sliceSelector [

	^ sliceSelector ifNil: [ sliceSelector := #count ]
]

{ #category : 'accessing' }
StL_Pie >> sliceSelector: aStringOrSymbol [

	sliceSelector := aStringOrSymbol asSymbol
]

{ #category : 'usage' }
StL_Pie >> usageExamples: scriptName [

	^	scriptName, ' pharo --
	', scriptName, ' pharo -- - < object.ston
	', scriptName, ' pharo -D -- - < object.ston
	', scriptName, ' pharo -- - --selector=value < object.ston
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

{ #category : 'usage' }
StL_Pie >> usageSynopsis: scriptName [

	^	scriptName, ' [ -h | --help ] [ --info ] [ --selector=<slice-selector> ]
'
]
