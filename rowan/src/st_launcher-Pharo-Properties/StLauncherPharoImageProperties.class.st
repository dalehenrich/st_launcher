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
			(debugCommandErrorBool or: [ self isHeadless not ])
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
		nextPutAll: '  stash ', stArg, scriptFilePath asFileReference pathString; 
		lf;
		yourself.
]

{ #category : 'aliased properties' }
StLauncherPharoImageProperties >> headless: anImageNameOrAlias [

	"answer true if <anImageNameOrAlias> should run scripts in headless mode"

	^ (self aliasProperties at: anImageNameOrAlias ifAbsent: [ ^ true ])
		at: 'headless' ifAbsent: [ true ]
]

{ #category : 'aliased properties' }
StLauncherPharoImageProperties >> headless: anImageNameOrAlias  put: aBool [

	"answer true if <anImageName> should run scripts in headless mode"

	(self aliasProperties at: anImageNameOrAlias ifAbsentPut: [ Dictionary new ])
		at: 'headless' put: aBool
]

{ #category : 'testing' }
StLauncherPharoImageProperties >> isHeadless [

	^ self headless: self imageAlias
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
