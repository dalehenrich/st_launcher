#!/usr/local/bin/smalltalk/gemstone/st_launcher
"
Simple cross platform script to demonstrate use of objIn and objOut
"
Class {
	#name : 'StL_ObjOut',
	#superclass : 'AbstractMain',
	#instVars : [
		'resultObject'
	],
	#category : 'st_launcher-Scripts'
}

{ #category : 'script execution' }
StL_ObjOut >> main [

	(args includes: '-') 
		ifTrue: [ 
			"read objects from stdin"
			self stdin peek. "it seems that at least in GemStone 3.5.0, stdin needs to be primed"
			[ self objIn atEnd ]
				whileFalse: [
					| obj |
					obj := self objIn next.
					self objOut nextPut: obj ].
			^ self sentinelObject ].
	^ self resultObject
]

{ #category : 'accessing' }
StL_ObjOut >> resultObject [

	^ resultObject ifNil: [ { 7 } ]
]

{ #category : 'options' }
StL_ObjOut >> scriptMethodOptions [
	^ {
			#('help' $h  #none).
			#('info' nil #none).
			#('sample' nil #sample).
	}
]

{ #category : 'script execution' }
StL_ObjOut >> sample [

	^ resultObject := StL_ObjOut_Sample new name: 'Blueberries'; count: 10; yourself
]

{ #category : 'usage' }
StL_ObjOut >> usage: scriptName shortDescription: ignored description: description [
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
  ', scriptName, ' [ -h | --help ] [ --info ] [ - ] [ --sample ]

DESCRIPTION
	This script writes objects to stdout.

	If `-` is specified, objects will be read from stdin and written to stdout without
	further processing.

	By default, the Array `{ 7 }` will be written to stdout.

EXAMPLES
	', scriptName, ' -h
	', scriptName, ' --help
	', scriptName, ' --info

	', scriptName, '
	', scriptName, ' > object.ston
	', scriptName, ' - < object.ston
') printString, dashes
]
