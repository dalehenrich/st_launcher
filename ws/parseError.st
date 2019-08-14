#!/usr/local/bin/smalltalk/gemstone/st_launcher
"
When run, I produce a Smalltalk compile error 
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
	^ { 
		1. 
		'key' -> 'value'.
		Object new.
		Dictionary new at: #'x' put: ; yourself.
	}
]


