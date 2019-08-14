#!/usr/local/bin/smalltalk/gemstone/st_launcher
"
Display a Roassal pie chart based on StL_ObjOut_Sample instances read from
	objIn.

	Since GemStone does not have a GUI, this script currently should be run
	against a pharo image.

	The collection of objects used to create the pie chart are read from `objIn`
	using STON format.

	See the #makePie: method for details of pie creation.

	`objIn` is a STONReader stream on `stdin`.

	With no arguments an empty pie chart is displayed. 

	NOTE: this program reads from stdin and will block on the absence of input. 

	--label=[ on | off ]
		Indicate whether or not the pie chart should be labeled. By default 
		labeling is `on`. The label is the printString of the sample object.

	--selector=<slice-selector>
		The message to be sent to the incoming objects to obtain the value to be
		used for calculated the size of the slice of the pie. The default is
		`count`.

	--style=[ simple | emphasis ]
		Define the style of pie chart to be display. `simple` (default) or
		`emphasis`.

"
Class {
	#name : 'StL_Pie',
	#superclass : 'AbstractProgram',
	#instVars : [
		'labeled',
		'sampleObjects',
		'sliceSelector',
		'style'
	],
	#category : 'st_launcher-Scripts'
}

{ #category : 'accessing' }
StL_Pie >> labeled: aString [

	labeled := aString = 'on'
]

{ #category : 'accessing' }
StL_Pie >> labeled [

	^ labeled ifNil: [ true ]
]

{ #category : 'main' }
StL_Pie >> main [

	sampleObjects := OrderedCollection new.

	"read objects from objIin"
	[ self objIn atEnd ]
		whileFalse: [
			| obj |
			obj := self objIn next.
			obj isArray
				ifTrue: [ sampleObjects addAll: obj ]
				ifFalse: [ sampleObjects add: obj ] ].
	(self makePie: self style) open.
	^ true
]

{ #category : 'pie' }
StL_Pie >> makePie: aStyle [
	"create the pie chart, using the specified style"

	| builder samples |
	samples := self sampleObjects.
	builder := (self globalNamed: 'RTPieBuilder') new.
	builder interaction popup.
	builder objects: samples.
	builder slice: self sliceSelector.
	builder normalizer distinctColor.
	self labeled
		ifTrue: [ builder labeled ].
	aStyle = 'emphasis'
		ifTrue: [ builder emphasize: (samples at: 1) by: 20 ] .
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
	^ super scriptMethodOptions, 
	{
			#('selector' nil #required #sliceSelector: ).
			#('label' nil #required #labeled: ).
			#('style' nil #required #style: ).
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

{ #category : 'accessing' }
StL_Pie >> style [

	^ style ifNil: [ style := 'simple' ]
]

{ #category : 'accessing' }
StL_Pie >> style: aString [

	style := aString
]

{ #category : 'usage' }
StL_Pie >> usageExamples: scriptName [

	^	scriptName, ' pharo-ui --
	', scriptName, ' pharo-ui -- < object.ston

	', scriptName, ' pharo-ui -- --label=off < object.ston
	', scriptName, ' pharo-ui -- --label=on < object.ston

	', scriptName, ' pharo-ui -D -- < object.ston
	', scriptName, ' pharo-ui -- --selector=value < object.ston
	', scriptName, ' pharo-ui -- --style=emphasis < object.ston
'
]

{ #category : 'usage' }
StL_Pie >> usageStandardExamples: scriptName [

	^ scriptName, ' pharo -- -h
	', scriptName, ' pharo -- --help

	', scriptName, ' pharo -- --imageProperties

	'
]

{ #category : 'usage' }
StL_Pie >> usageSynopsis: scriptName [

	^	(super usageSynopsis: scriptName), ' [ --selector=<slice-selector> ] \
			[ --label=[ on | off ] ] [ --style=[ simple | emphasis ] ]'
]
