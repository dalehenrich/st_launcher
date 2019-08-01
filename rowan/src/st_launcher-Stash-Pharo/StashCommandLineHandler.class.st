"
Usage: stash [--help] <FILE>
	--help    list this help message
	--no-source if specified, do not write to the .changes file
	<FILE>    a file containing valid Pharo expressions

Documentation:
The STASH command line handler runs the Stash driver file that executes st_launcher script files.

Example:

	pharo Pharo.image stash driver.stash
	
	# By default files ending in .stash are recognized and evaluated
	pharo Pharo.image code.stash

"
Class {
	#name : #StashCommandLineHandler,
	#superclass : #CommandLineHandler,
	#instVars : [
		'stashhDriverFile'
	],
	#category : #'st_launcher-Stash-Pharo'
}

{ #category : #accessing }
StashCommandLineHandler class >> commandName [
	^ 'stash'
]

{ #category : #accessing }
StashCommandLineHandler class >> description [
	^ 'Loads and executes .stash source files'
]

{ #category : #'handler selection' }
StashCommandLineHandler class >> isResponsibleFor: aCommandLine [
	"This handler is reponsible only for .st files"
	(aCommandLine hasFileWithExtension: '.stash')
		ifTrue: [ ^ true ].
	^ super isResponsibleFor: aCommandLine
]

{ #category : #activation }
StashCommandLineHandler >> activate [
	self activateHelp
		ifTrue: [  ^ self ].
	
	self loadStashDriverFile.
	self executeStashDriverFile.
	
	Stdio stderr nextPutAll: 'Calling exitSuccess'; lf.
	Smalltalk exit: 0
]

{ #category : #execution }
StashCommandLineHandler >> executeStashDriverFile [

	stashhDriverFile readStreamDo: [:stream |
		Smalltalk compiler evaluate: stream contents ]
]

{ #category : #loading }
StashCommandLineHandler >> loadStashDriverFile [
	"Load all the source files in the given array."

	stashhDriverFile := (self commandLine allFilesWithExtension: '.stash') first asFileReference

]
