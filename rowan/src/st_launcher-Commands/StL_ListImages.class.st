#!/usr/local/bin/smalltalk/gemstone/st_launcher
"
Write the list of currently registered images to objOut.

	--verbose | -v
		List names and image paths for registered images
"
Class {
	#name : 'StL_ListImages',
	#superclass : 'AbstractProgram',
	#instVars : [
		'verbose'
	],
	#category : 'st_launcher-Commands'
}


{ #category : 'script options' }
StL_ListImages >> isVerbose [

	^ verbose ifNil: [ false ]
]

{ #category : 'main' }
StL_ListImages >> main [
	| structureProperties |
	structureProperties := StLauncherProperties defaultPropertyFile.
	^ self isVerbose
		ifTrue: [ structureProperties imageMap ]
		ifFalse: [ structureProperties imageMap keys sort ]
]

{ #category : 'script options' }
StL_ListImages >> verbose [

	verbose := true
]

{ #category : 'script options' }
StL_ListImages >> scriptMethodOptions [
	^ super scriptMethodOptions, 
	{
		#('verbose' $v #none #verbose).
	}
]

{ #category : 'usage' }
StL_ListImages >> usageExamples: scriptName [

	^	scriptName, '
	', scriptName, ' -v
	', scriptName, ' --verbose
'
]

{ #category : 'usage' }
StL_ListImages >> usageSynopsis: scriptName [

	^	(super usageSynopsis: scriptName), ' [ --verbose | -v ]'
]
