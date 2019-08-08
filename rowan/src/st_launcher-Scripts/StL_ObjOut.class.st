#!/usr/local/bin/smalltalk/gemstone/st_launcher
"
Simple cross platform script to demonstrate use of `objIn` and `objOut`.

	Objects are read from `objIn` and written to`objOut`  using STON format.
	`objIn` is a STONReader stream on `stdin`. `objOut` is a STONWriter 
	stream on `stdout`.

	-
		Read objects from objIn

	--file=<file-path>
		Read objects in STON format from the given file

	-- sample
		Use an instance of StLObjOutSample as the read object

	With no options the Array`{ 7 }` is used as the read object.
"
Class {
	#name : 'StL_ObjOut',
	#superclass : 'AbstractProgram',
	#instVars : [
		'resultObject',
		'objectFile'
	],
	#category : 'st_launcher-Scripts'
}

{ #category : 'main' }
StL_ObjOut >> main [

	| objectReader |
	objectReader := (self args includes: '-') 
		ifTrue: [ 
			"read objects from stdin"
			 self objIn ]
		ifFalse: [
			self objectFile ifNotNil: [ STONReader on:  (ZnBufferedReadStream on: objectFile readStream) ] ].
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

{ #category : 'accessing' }
StL_ObjOut >> sample [

	^ resultObject := StLObjOutSample new name: 'Blueberries'; count: 10; yourself
]

{ #category : 'options' }
StL_ObjOut >> scriptMethodOptions [
	^ super scriptMethodOptions, 
	{
			#('sample' nil #none #sample).
			#('file' nil #required #objectFile:).
	}
]

{ #category : 'usage' }
StL_ObjOut >> usageExamples: scriptName [

	^	scriptName, '
	', scriptName, '  > object.ston
	', scriptName, ' - < object.ston
	', scriptName, ' --file=object.ston
	', scriptName, ' --sample

	', scriptName, ' -D --

	', scriptName, ' pharo --
	', scriptName, ' pharo -- > object.ston
	', scriptName, ' pharo -- - < object.ston
	', scriptName, ' pharo -- --file=object.ston
	', scriptName, ' pharo -- --sample
'
]

{ #category : 'usage' }
StL_ObjOut >> usageSynopsis: scriptName [

	^	(super usageSynopsis: scriptName), ' [ - | --file=<file-path> | --sample ]'
]
