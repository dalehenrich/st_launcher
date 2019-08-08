#!/usr/local/bin/smalltalk/gemstone/st_launcher
"
Example script that signals an error.

	--skip
		write message to stderr and skip signalling an error
"
Class {
	#name : 'StLauncher_Error',
	#superclass : 'AbstractProgram',
	#instVars : [
		'skip'
	],
	#category : 'st_launcher-Scripts'
}

{ #category : 'main' }
StLauncher_Error >> main [

	self skip
		ifTrue: [ self stderr nextPutAll: 'Skipping error'; lf ]
		ifFalse: [ Error signal: 'You wanted an error?' ].
	^ self sentinelObject "don't write anything to objOut"
]

{ #category : 'script options' }
StLauncher_Error >> scriptMethodOptions [
	^ super scriptMethodOptions, 
	{
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
StLauncher_Error >> usageExamples: scriptName [

	^	scriptName, '
	', scriptName, ' -D --
	', scriptName, ' pharo -D --
	', scriptName, ' --skip
'
]

{ #category : 'usage' }
StLauncher_Error >> usageSynopsis: scriptName [

	^	(super usageSynopsis: scriptName), ' [ skip ]'
]
