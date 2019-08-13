#!/usr/local/bin/smalltalk/gemstone/st_launcher
"
Template workspace script ... copy me to a new file and put the code you want
to run into the main method. Change the comment to reflect help text you want
to have.

If you want to make the resulting script available in an image, move it to th 
stl_launcher-Worspaces package and give it a unique class name ...
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
	^ ((ClassOrganizer new) classes collect: [:class | 
		| methodCount |
		methodCount := (class persistentMethodDictForEnv: 0) size + (class class persistentMethodDictForEnv: 0) size. 
		StLObjOutSample new 
			name: class name ; 
			count: methodCount; 
			yourself]) asArray
]

WS_ >> usageExamples: scriptName [

	^	scriptName, '
	', scriptName, ' -D --		# debug errors
'
]

