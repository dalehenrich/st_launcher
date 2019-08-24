#!/usr/local/bin/smalltalk/gemstone/st_launcher
"
bug sript utility template
"

Class {
	#name : 'WS_BugTemplate',
	#superclass : 'AbstractProgram',
	#instVars : [
		'indexedCollection'
	],
	#category : 'st_launcher-Workspaces'
}

{ #category : 'accessing' }
WS_BugTemplate >> boom [
	"recreate bug here"
]

{ #category : 'accessing' }
WS_BugTemplate >> clean [
	"clean up indexes here"
]

{ #category : 'accessing' }
WS_BugTemplate >> create [
	"set up for recrating the bug here"
]

{ #category : 'accessing' }
WS_BugTemplate >> install [
	"install supporting code here"
]

{ #category : 'main' }
WS_BugTemplate >> main [
	| theColl analysis |
	theColl := self theColl.
	^ analysis
		at: 'nsc' put: theColl;
		at: 'query' put: ('each.value1 <= 1' asQueryOn: theColl);
		yourself.
]

{ #category : 'accessing' }
WS_BugTemplate >> theColl [
	^ indexedCollection 
		ifNil: [ indexedCollection := UserGlobals at: #'coll' ifAbsent: [ Set new ] ].
]

{ #category : 'options' }
WS_BugTemplate >> scriptMethodOptions [
	^ super scriptMethodOptions, 
	{
			#('boom' nil #'none' #boom).
			#('clean' nil #'none' #clean).
			#('create' nil #'none' #create).
			#('install' nil #'none' #install).
	}
]

{ #category : 'usage' }
WS_BugTemplate >> usageExamples: scriptName [
	^	scriptName, ' --install
	', scriptName, ' --clean --create --boom; edit
'
]

{ #category : 'usage' }
WS_BugTemplate >> usageSynopsis: scriptName [

	^	(super usageSynopsis: scriptName), ' [ --install ] [ --clean ] [ --create ] [ --boom ]'
]
