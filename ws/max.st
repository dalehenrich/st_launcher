#!/usr/local/bin/smalltalk/gemstone/st_launcher
"
Find the StLObjOutSample instance read from objin with the maximum count value.
"
Class {
	#name : 'WS_',
	#superclass : 'AbstractProgram',
	#instVars : [
	],
	#category : 'st_launcher-Workspaces'
}

{ #category : 'main' }
WS_ >> main [
	| max |
	max := StLObjOutSample new 
			name: max ; 
			count: 0; 
			yourself. 
	self objIn next collect: [:each | each count > max count ifTrue: [max := each ] ].
	^ max
]

WS_ >> usageExamples: scriptName [

	^	scriptName, '
	', scriptName, ' -D --		# debug errors
'
]

