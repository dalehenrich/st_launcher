#!/usr/local/bin/smalltalk/gemstone/st_launcher
"
Display pie chart based on objects read off of objIn
"
Class {
	#name : 'StL_Pie',
	#superclass : 'AbstractMain',
	#instVars : [
		'sampleObjects'
	],
	#category : 'st_launcher-Scripts'
}

{ #category : 'script execution' }
StL_Pie >> main [

	sampleObjects := OrderedCollection new.

	"read objects from stdin"
	self stdin peek. "it seems that at least in GemStone 3.5.0, stdin needs to be primed"
	[ 
		self objIn consumeWhitespace.
		self objIn atEnd ]
		whileFalse: [
			| obj |
			obj := self objIn next.
			sampleObjects add: obj ].
	self makePie.
	^ true
]

{ #category : 'script execution' }
StL_Pie >> makePie [

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
StL_Pie >> usage: scriptName shortDescription: ignored description: description [
	| dashes |
	dashes := '----------------------------------------------------
'.
  self stdout nextPutAll: dashes,
		(self manPageClass
          fromString:
'NAME
	', scriptName, ' - ', description, '.

SYNOPSIS
  ', scriptName, ' [ [ imageName ] [-H] [-D] [-V] [st vm args] -- ]  <script options>
----------
  ', scriptName, ' [ -h | --help ] [ --info ] 

DESCRIPTION
	This script reads StL_ObjOut_Sample instances from stdin and creates a pie
	chart using Roassal.

EXAMPLES
	', scriptName, ' -h
	', scriptName, ' --help
	', scriptName, ' --info

	', scriptName, '
	', scriptName, ' < object.ston
') printString, dashes
]
