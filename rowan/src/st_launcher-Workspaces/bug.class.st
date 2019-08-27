#!/usr/local/bin/smalltalk/gemstone/st_launcher
"
bug sript utility template

	--install
		Install any additional code that may be needed to reproduce bug.

	--clean
		Remove any persistent objects used to reproduce bug.
 
	--create
		Create the initial conditions needed to reproduce bug.

	--boom
		Trigger the bug.
"
Class {
	#name : 'WS_BugTemplate',
	#superclass : 'AbstractProgram',
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
	"return status objects ... if needed"
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
	', scriptName, ' --clean --create --boom

	', scriptName, ' --clean --create
	', scriptName, ' --boom
'
]
{ #category : 'usage' }
WS_BugTemplate >> usageSynopsis: scriptName [
	^	(super usageSynopsis: scriptName), ' [ --install ] [ --clean ] [ --create ] [ --boom ]'
]
