Class {
	#name : 'AbstractMain',
	#superclass : 'StLauncherScript',
	#instVars : [
		'objIn',
		'objOut',
		'sentinelObject'
	],
	#category : 'st_launcher-Stash'
}

{ #category : 'script execution' }
AbstractMain >> executeScript [

	opts
		at: 'help'
		ifAbsent: [
			opts
				at: 'info'
				ifAbsent: [
					self preExecute.
					self orderedOptions do: [:option |
						(opts includesKey: option)
							ifTrue: [
								| selector |
								selector := (self scriptOptionsMap at: option) at: 4.
								selector numArgs = 0
									ifTrue: [ self perform: selector asSymbol ]
									ifFalse: [ self perform: selector asSymbol with: (opts at: option) ] ] ].
					self postExecute ] 
				ifPresent: [ ^ self info ] ]
		ifPresent: [ ^ self usage ]
]

{ #category : 'info' }
AbstractMain >> info [

	self stderr
		nextPutAll: self systemInfo;
		lf;
		yourself
]

{ #category : 'script execution' }
AbstractMain >> main [

	self subclassResponsibility: #main
]

{ #category : 'io' }
AbstractMain >> objIn [

	^ objIn ifNil: [ objIn := STONReader on: self stdin ]
]

{ #category : 'script execution' }
AbstractMain >> postExecute [

	| object |
	object := self main.
	object ~~ self sentinelObject ifTrue: [ self objOut nextPut: object ]
]

{ #category : 'accessing' }
AbstractMain >> sentinelObject [
	"unique instance that is used to indicate that the stream of objects being processed is complete"

	sentinelObject ifNil: [ sentinelObject := Object new ]
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
  ', scriptName, ' [ [ imageName ] [-H] [-D] [-V] [st vm args] -- ]  <script options>
----------
  ', scriptName, ' [ -h | --help ] [ --info ]

DESCRIPTION
	', description, '

EXAMPLES
	', scriptName, ' -h
	', scriptName, ' --help

	', scriptName, '
') printString, dashes
]