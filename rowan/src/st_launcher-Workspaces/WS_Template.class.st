#!/usr/local/bin/smalltalk/gemstone/st_launcher
"
Template workspace script ... copy me to a new file and put the code you want
to run into the main method. Change the comment to reflect help text you want
to have and change the class name
"
Class {
	#name : 'WS_Template',
	#superclass : 'AbstractProgram',
	#category : 'st_launcher-Workspaces'
}

{ #category : 'main' }
WS_Template >> main [
	"object returned by main, will be written to objOut"

	^ self sentinel "do not write objects to objOut"
]
