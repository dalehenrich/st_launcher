#!/usr/local/bin/smalltalk/gemstone/st_launcher
"
Example script that signals an error.
"
Class {
	#name : 'StLauncher_Error',
	#superclass : 'AbstractProgram',
	#category : 'st_launcher-Scripts'
}

{ #category : 'main' }
StLauncher_Error >> main [

	Error signal: 'You wanted an error?'.
	^ nil
]

{ #category : 'usage' }
StLauncher_Error >> usageExamples: scriptName [

	^	scriptName, '
	', scriptName, ' -D --
	', scriptName, ' gemstone -D --
	', scriptName, ' pharo -D --
'
]
