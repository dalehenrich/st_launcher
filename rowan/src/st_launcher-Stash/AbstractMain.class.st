Class {
	#name : 'AbstractMain',
	#superclass : 'StLauncherScript',
	#instVars : [
		'objIn',
		'objOut'
	],
	#category : 'st_launcher-Stash'
}

{ #category : 'script execution' }
AbstractMain >> main [

	self subclassResponsibility: #main
]

{ #category : 'io' }
AbstractMain >> objIn [

	^ objIn ifNil: [ objIn := STONReader on: self stdin ]
]

{ #category : 'io' }
AbstractMain >> objOut [

	^ objOut ifNil: [ 
		objOut := (STONWriter on: self stdout)
			prettyPrint: true; 
			yourself ]
]

{ #category : 'script execution' }
AbstractMain >> postExecute [

	| object |
	object := self main.
	self objOut nextPut: object
]

{ #category : 'usage' }
AbstractMain >> usage [

	^ self usage: self scriptName description: self class comment
]

{ #category : 'usage' }
AbstractMain >> usage: scriptName description: description [

	^ self usage: scriptName shortDescription: '' description: description
]

{ #category : 'usage' }
AbstractMain >> usage: scriptName shortDescription: shortDescription description: description [
	| dashes |
	dashes := '----------------------------------------------------
'.
  self stdout nextPutAll: dashes,
		(self manPageClass
          fromString:
'NAME
	', scriptName, ' - ', shortDescription, '.

SYNOPSIS
  ', scriptName, ' [ [ imageName ] [-H] [-D] [-V] [st vm args] -- ]  [ -h | --help ]

DESCRIPTION
	', description, '

EXAMPLES
	', scriptName, ' -h
	', scriptName, ' --help

	', scriptName, '
') printString, dashes
]
