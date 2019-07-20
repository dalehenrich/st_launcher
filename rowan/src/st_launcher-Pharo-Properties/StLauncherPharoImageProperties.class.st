Class {
	#name : 'StLauncherPharoImageProperties',
	#superclass : 'StLauncherImageProperties',
	#instVars : [
		'pharoVersion',
		'productPath'
	],
	#category : 'st_launcher-Pharo-Properties'
}

{ #category : 'instance creation' }
StLauncherPharoImageProperties class >> named: nameString version: pharoVersionString [

	^ (self new)
		name: nameString;
		pharoVersion: pharoVersionString;
		yourself
]

{ #category : 'launcher' }
StLauncherPharoImageProperties >> generateVmScriptLaunchCommandLineFrom: vmOptions debugCommandError: debugCommandErrorBool [

	"fabricate a pharo command line for executing the stashFile using a headless vm (headful for debugging)"

	| vmExec |
	vmExec := debugCommandErrorBool
		ifTrue: [ 'pharo-ui ' ]
		ifFalse: [ 'pharo ' ].
	GsFile stdout 
		nextPutAll: self imageDirectory pathString, '/', vmExec;
		nextPutAll: ' ', vmOptions, ' ' ;
		nextPutAll: '  ', self imageDirectory pathString, '/Pharo.image ';
		lf;
		yourself.
]

{ #category : 'accessing' }
StLauncherPharoImageProperties >> pharoVersion [

	^ pharoVersion
]

{ #category : 'accessing' }
StLauncherPharoImageProperties >> pharoVersion: aPharoVersionString [

	pharoVersion := aPharoVersionString
]

{ #category : 'accessing' }
StLauncherPharoImageProperties >> productPath [

	^ productPath
]

{ #category : 'accessing' }
StLauncherPharoImageProperties >> productPath: aString [

	productPath := aString
]
