#!/usr/local/bin/smalltalk/gemstone/st_launcher
"
Example script that signals an error
"
Class {
	#name : 'StLauncher_Error',
	#superclass : 'AbstractProgram',
	#instVars : [
		'skip'
	],
	#category : 'st_launcher-Scripts'
}

{ #category : 'script execution' }
StLauncher_Error >> main [

	self skip
		ifTrue: [ self stderr nextPutAll: 'Skipping error'; lf ]
		ifFalse: [ Error signal: 'You wanted an error?' ].
]

{ #category : 'script options' }
StLauncher_Error >> scriptMethodOptions [
	^ {
			#('help' $h  #none).
			#('info' nil #none).
			#('skip' nil #none #skipError).
	}
]

{ #category : 'accessing' }
StLauncher_Error >> skip [

	^ skip ifNil: [ skip := false ]
]

{ #category : 'accessing' }
StLauncher_Error >> skip: aBool [

	skip := aBool
]

{ #category : 'script implementation' }
StLauncher_Error >> skipError [

	self skip: true
]

{ #category : 'usage' }
StLauncher_Error >> usage [
	| dashes |
	dashes := '----------------------------------------------------
'.
  self stdout nextPutAll: dashes,
		(self manPageClass
          fromString:
'NAME
	error.st - signal an error.

SYNOPSIS
  error.st [ imageName [-H] [-D] [-V] [st vm args] -- ]  [script args]

  error.st [--help] [--info] [--skip]

DESCRIPTION

	By default this script signals an error. 

	If the --skip option is specified, a skip message is written to stderr
	and the error is not signalled

EXAMPLES
	./error.st --help
	./error.st --info

	./error.st
	./error.st -D -- 
	./error.st --skip

') printString, dashes
]
