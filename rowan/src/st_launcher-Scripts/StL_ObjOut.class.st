#!/usr/local/bin/smalltalk/gemstone/st_launcher
"
Simple cross platform script to demonstrate use of objIn and objOut
"
Class {
	#name : 'StL_ObjOut',
	#superclass : 'AbstractMain',
	#instVars : [
		'resultObject',
		'objectFile'
	],
	#category : 'st_launcher-Scripts'
}

{ #category : 'script execution' }
StL_ObjOut >> main [

	| objectReader |
	objectReader := (self args includes: '-') 
		ifTrue: [ 
			"read objects from stdin"
			"self stdin peek." "it seems that at least in GemStone 3.5.0, stdin needs to be primed"
			 self objIn ]
		ifFalse: [ STONReader on:  (ZnBufferedReadStream on: self objectFile readStream) ].
	objectReader
		ifNotNil: [
			[ 
				objectReader consumeWhitespace.
				objectReader atEnd ]
				whileFalse: [
					| obj |
					obj := objectReader next.
					self objOut nextPut: obj ].
			objectReader close.
			^ self sentinelObject ].
	^ self resultObject
]

{ #category : 'accessing' }
StL_ObjOut >> objectFile [

	^ objectFile
]

{ #category : 'accessing' }
StL_ObjOut >> objectFile: aFilePath [

	objectFile := aFilePath asFileReference
]

{ #category : 'accessing' }
StL_ObjOut >> resultObject [

	^ resultObject ifNil: [ { 7 } ]
]

{ #category : 'script execution' }
StL_ObjOut >> sample [

	^ resultObject := StLObjOutSample new name: 'Blueberries'; count: 10; yourself
]

{ #category : 'options' }
StL_ObjOut >> scriptMethodOptions [
	^ {
			#('help' $h  #none).
			#('info' nil #none).
			#('sample' nil #none #sample).
			#('file' nil #required #objectFile:).
	}
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
  ', scriptName, ' [ -h | --help ] [ --info ] [ - ] [ --sample ] [ --file=<filepath> ]

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

	', scriptName, ' --file=object.ston

	', scriptName, ' > object.ston
	', scriptName, ' - < object.ston
') printString, dashes
]
