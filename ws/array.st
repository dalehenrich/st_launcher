#!/usr/local/bin/smalltalk/gemstone/st_launcher
"
Answer a somewhat arbitrary array of objects, so be displayed in STON format
"
Class {
	#name : 'WS_',
	#superclass : 'AbstractProgram',
	#category : 'st_launcher-Workspaces'
}

{ #category : 'main' }
WS_ >> main [
	^ { 
		1. 
		'key' -> 'value'.
		Object new.
		Dictionary new at: #'x' put: 'y'; yourself.
	}
]


