Class {
	#name : 'AbstractProgram',
	#superclass : 'AbstractLauncherProgram',
	#instVars : [
		'objIn',
		'objOut',
		'sentinelObject'
	],
	#category : 'st_launcher-Program'
}

{ #category : 'utility' }
AbstractProgram >> evaluate: stExpression [

	^ self evaluate: stExpression inContext: nil
]

{ #category : 'script execution' }
AbstractProgram >> executeScript [

	opts
		at: 'help'
		ifAbsent: [
			opts
				at: 'imageProperties'
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
				ifPresent: [ self objOut nextPut: self imageProperties ] ]
		ifPresent: [ ^ self usage ]
]

{ #category : 'script execution' }
AbstractProgram >> main [

	self subclassResponsibility: #main
]

{ #category : 'io' }
AbstractProgram >> objIn [

	^ objIn ifNil: [ objIn := STONReader on: self stdin ]
]

{ #category : 'script execution' }
AbstractProgram >> postExecute [

	| object |
	object := self main.
	object ~~ self sentinelObject ifTrue: [ self objOut nextPut: object ]
]

{ #category : 'options' }
AbstractProgram >> scriptMethodOptions [
	^ {
			#('help' $h  #none).
			#('imageProperties' nil #none).
	}
]

{ #category : 'accessing' }
AbstractProgram >> sentinelObject [
	"unique instance that is used to indicate that the stream of objects being processed is complete"

	sentinelObject ifNil: [ sentinelObject := Object new ]
]

{ #category : 'usage' }
AbstractProgram >> usage [

	^ self usage: self scriptName description: self class comment
]

{ #category : 'usage' }
AbstractProgram >> usage: scriptName description: description [

	^ self usage: scriptName shortDescription: self usageSummary description: description
]

{ #category : 'usage' }
AbstractProgram >> usage: scriptName shortDescription: shortDescription description: description [
	| dashes |
	dashes := '----------------------------------------------------
'.
  self stdout nextPutAll: "dashes,"
		(self manPageClass
          fromString:
'NAME
	', scriptName, ' - ', shortDescription, '.

SYNOPSIS
	', scriptName, ' [ [ <image-name> ] [-H] [-D] [-V] [ <st-vm-args> ] -- ]  <script options>
----------
	', (self usageSynopsis: scriptName), '

DESCRIPTION
	', description, '
',
	self usageDescription, '

	<image-name>
		name of the st_launcher image to be used to run the script. If
		no <image-name> is specified the default image will be used.

	-H
		help. st_launcher script interpreter help message

	-D
		debug. bring up debugger if an error occurs while running script

	-V
		verbose. display more detail about script interpreter execution

	<st-vm-args>
		smalltalk vm specific arguments passed directly to vm when launching script

EXAMPLES
	', (self usageStandardExamples: scriptName), 
	(self usageExamples: scriptName), '
') printString", dashes"
]

{ #category : 'usage' }
AbstractProgram >> usageDescription [

	^	'
	--help
		display this message

	--imageProperties
		return (on objOut) the image properties object for the image running
		this script
'
]

{ #category : 'usage' }
AbstractProgram >> usageExamples: scriptName [

	^	scriptName, '
'
]

{ #category : 'usage' }
AbstractProgram >> usageStandardExamples: scriptName [

	^ scriptName, ' -h
	', scriptName, ' --help
	', scriptName, ' --imageProperties

	', scriptName, ' pharo -- --imageProperties

	'
]

{ #category : 'usage' }
AbstractProgram >> usageSummary [

	^ 	(ReadStream on: self class comment) nextLine, '...'
]

{ #category : 'usage' }
AbstractProgram >> usageSynopsis: scriptName [

	^	scriptName, ' [ -h | --help ] [ --imageProperties ]'
]
