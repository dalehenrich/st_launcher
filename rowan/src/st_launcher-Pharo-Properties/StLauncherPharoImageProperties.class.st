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
StLauncherPharoImageProperties >> generateVmScriptLaunchCommandLineFrom: vmArgs vmScriptPath: scriptFilePath debugCommandError: debugCommandErrorBool [

	"fabricate a pharo command line for executing the stashFile using a headless vm (headful for debugging)"

	| theVmArgs  stArg |
	theVmArgs := vmArgs isEmpty
		ifTrue: [
			debugCommandErrorBool
				ifTrue: [ '' ]
				ifFalse: [ ' --nodisplay' ] ]
		ifFalse: [ vmArgs ].
	stArg := debugCommandErrorBool
		ifTrue: [ '' ]
		ifFalse: [ ' --quit ' ].
	GsFile stdout 
		nextPutAll: (self productDirectory / 'pharo-vm' / 'pharo') pathString;
		nextPutAll: ' ', theVmArgs ;
		nextPutAll: '  ', (self imageDirectory / 'Pharo.image') pathString;
		nextPutAll: '  st ', stArg, scriptFilePath asFileReference pathString; 
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
StLauncherPharoImageProperties >> productDirectory [

	^ self productPath asFileReference
]

{ #category : 'accessing' }
StLauncherPharoImageProperties >> productPath [

	^ productPath
]

{ #category : 'accessing' }
StLauncherPharoImageProperties >> productPath: aString [

	productPath := aString
]
