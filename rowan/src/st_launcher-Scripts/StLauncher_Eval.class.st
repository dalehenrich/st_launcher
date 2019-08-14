#!/usr/local/bin/smalltalk/gemstone/st_launcher
"
Evaluate smalltalk expression from command line or file.
	The object read from `objIn` or a file is the receiver. The receiver is nil
	by default.

	If you put the expression on the command line, then you should wrap the 
	expression with single and double quotes (see the examples from --help).

	'""3 + 4""'

	The outer single quotes preserves the double quotes which are used by the 
	st_launcher argument parser to preserve the expression as a single argument.

	Literal strings are also a problem since the $' character is treated
	specially by bash itself. It's best to use the `--st` option to read the 
	smalltalk expression from a file and avoid bash interference.

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
			[ ^ objectReader next ] ensure: [ objectReader close ] ].
	^ nil
]

{ #category : 'main' }
StLauncher_Eval >> main [
	"script evaluation is platform specific, so this functionality is implemented
		in AbstractProgram, so that conditional platform code can be run by the
		script"

	^self evaluate: self stExpression inContext: self contextObject
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

{ #category : 'options' }
StLauncher_Eval >> scriptMethodOptions [
	^ super scriptMethodOptions, 
	{
			#('st' nil #required #scriptFile:).
			#('file' nil #required #objectFile:).
	}
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
StLauncher_Eval >> usageExamples: scriptName [

	^	scriptName, ' ''"self"''
	', scriptName, ' pharo -- - ''"self"'' < array.ston
	', scriptName, ' pharo -- - ''"self at: 1"'' < array.ston
	', scriptName, ' --file=array.ston ''"(self at: 1) - 1"''

	', scriptName, ' --file=array.ston ''"self foo"''
	', scriptName, ' -D --  --file=array.ston ''"self foo"''

	', scriptName, ' --st=workspace.st
	', scriptName, ' pharo -- - --st=selfat.st < array.ston
	', scriptName, ' --st=selfat.st --file=array.ston
'
]

{ #category : 'usage' }
StLauncher_Eval >> usageSynopsis: scriptName [

	^	(super usageSynopsis: scriptName), ' [ - | --file=<file-path> ] \
		[ --st=<st-file-path> | ''"<st-expression>"'' ]'
]
