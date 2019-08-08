#!/usr/local/bin/smalltalk/gemstone/st_launcher
"
Evaluate smalltalk expression from command line or file.
	The object read from `objIn` or a file is `self`. `self` is nil by default. 

	Write result of evaluating expression to `objOut`.

	-
		Read objects from objIn

	--file=<file-path>
		Read objects in STON format from the given file

	--st=<st-file-path>
		Read smalltalk expression from file	
"
Class {
	#name : 'StLauncher_Eval',
	#superclass : 'AbstractProgram',
	#instVars : [
		'scriptFile',
		'objectFile'
	],
	#category : 'st_launcher-Scripts'
}

{ #category : 'main' }
StLauncher_Eval >> contextObject [
	"read context from objIn or objectFile, return nil if no objects are found (empty file, closed stdin)"

	| objectReader |
	objectReader := (self args includes: '-') 
		ifTrue: [ 
			"read objects from stdin"
			 self objIn ]
		ifFalse: [
			self objectFile 
				ifNil: [ ^ nil ]
				ifNotNil: [ STONReader on:  (ZnBufferedReadStream on: objectFile readStream) ] ].
	objectReader consumeWhitespace.
	objectReader atEnd 
		ifFalse: [ 
			objectReader close.
			^ objectReader next ].
	^ nil
]

{ #category : 'main' }
StLauncher_Eval >> main [

	^self evaluate: self stExpression inContext: self contextObject
]

{ #category : 'options' }
StLauncher_Eval >> scriptMethodOptions [
	^ super scriptMethodOptions, 
	{
			#('script' nil #required #scriptFile:).
			#('file' nil #required #objectFile:).
	}
]

{ #category : 'accessing' }
StLauncher_Eval >> objectFile [

	^ objectFile
]

{ #category : 'accessing' }
StLauncher_Eval >> objectFile: aFilePath [

	objectFile := aFilePath asFileReference
]

{ #category : 'accessing' }
StLauncher_Eval >> scriptFile [

	^ scriptFile
]

{ #category : 'accessing' }
StLauncher_Eval >> scriptFile: aFilePath [

	scriptFile := aFilePath asFileReference
]
{ #category : 'usage' }
StLauncher_Eval >> usageExamples: scriptName [

	^	scriptName, ' "self"
	', scriptName, ' pharo -- - "self at: 1" < array.ston
	', scriptName, ' "self at: 1" --file=array.ston

	', scriptName, ' -D -- "self foo" --file=array.ston

	', scriptName, ' --st=workspace.st
	', scriptName, ' pharo -- - --st=selfat.st < array.ston
	', scriptName, ' --st=selfat.st --file=array.ston
'
]

{ #category : 'main' }
StLauncher_Eval >> stExpression [
	"read smalltalk express from command line or scriptFile"

	self scriptFile
		ifNotNil: [:fileRef |
			fileRef readStreamDo: [:fileStream | 
				^ fileStream contents ] ]
		ifNil: [
			self args do:[:arg |
				arg = '-' ifFalse: [ ^ arg ] ] ].
	self error: 'No smalltalk expression defined on command line'
]

{ #category : 'usage' }
StLauncher_Eval >> usageSynopsis: scriptName [

	^	(super usageSynopsis: scriptName), ' [ - | --file=<file-path> ] \
		[ --st=<st-file-path> | "<st-expression" ]'
]
