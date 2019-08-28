#!/usr/local/bin/smalltalk/gemstone/st_launcher
"
Collect a list of classes and their method counts, recording the results in the
	class StLObjectOutSample. The collection is suitable for use as objIn for the
	pie.st script:

		ws/gsClassesAndMethodCounts.st gemstone -- | bin/pie.pharo.st pharo-ui --
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

	^	scriptName, 'gemstone --
	', scriptName, ' gemstone -D --		# debug errors

	', scriptName, ' gemstone -- | bin/pie.pharo.st pharo-ui --
'
]

