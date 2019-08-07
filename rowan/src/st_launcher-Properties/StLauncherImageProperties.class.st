Class {
	#name : 'StLauncherImageProperties',
	#superclass : 'StLauncherProperties',
	#instVars : [
		'aliasProperties',
		'imageAlias',
		'structureName',
		'imagePath',
		'imageDirectory'
	],
	#category : 'st_launcher-Properties'
}

{ #category : 'install / uninstall' }
StLauncherImageProperties class >> _deleteStructure [

	| launcherProperties |
	launcherProperties := StLauncherProperties defaultPropertyFile.
	launcherProperties images children 
		do: [:ent | 
			ent isDirectory
				ifTrue: [ 
					(self permanentImageNames includes: ent basename)
						ifFalse: [ 
							launcherProperties imageMap removeKey: ent basename ifAbsent: [].
							ent ensureDeleteAll ] ] ].

	launcherProperties export.
]

{ #category : 'accessing' }
StLauncherImageProperties class >> defaultPropertyFilename [

	^ 'imageProperties.ston'
]

{ #category : 'accessing' }
StLauncherImageProperties class >> permanentImageNames [

	^#( 'gemstone' 'gemstone_DataCurator' 'pharo' ' pharo-ui')
]

{ #category : 'accessing' }
StLauncherImageProperties class >> platformName [

	^ ''
]

{ #category : 'accessing' }
StLauncherImageProperties class >> propertyClassForPlatform: platformName [

	^ self allSubclasses detect: [:each | each platformName = platformName ] ifNone: [ self error: 'Platform name ', platformName printString , ' not reconized.' ]
]

{ #category : 'accessing' }
StLauncherImageProperties >> aliasProperties [
	"aliasProperties are alternate names for an image directory ... the aliasProperties dictionary should contain
		properties that are specific to the alias. The primary use case is to allow a pharo image
		to be launced with or without a ui"

	"the contents of the Dictionary are accessed via imageAlias, so that different sets of properties
		can be maintained under different aliases, while utilizing a single concrete image"

	^ aliasProperties ifNil: [ aliasProperties := Dictionary new ]
]

{ #category : 'actions' }
StLauncherImageProperties >> createStandardStructure [
	"create standard directory structure on disk"
]

{ #category : 'accessing' }
StLauncherImageProperties >> defaultPropertiesDirectory [

	^ self structureProperties images / self name
]

{ #category : 'ston' }
StLauncherImageProperties >> excludedInstVarNames [

	^ super excludedInstVarNames , #( imageDirectory )
]

{ #category : 'exporting' }
StLauncherImageProperties >> export [

	| copy |
	copy := self copy.
	copy imageAlias: nil. "imageAlias should not be exported to disk"
	copy export: self defaultPropertiesDirectory / self defaultPropertyFilename
]

{ #category : 'exporting' }
StLauncherImageProperties >> exportToStream: aStream [

	"lazily initialize any of the fields that haven't already been set, that need to be set"

	self 
		imageDirectory;
		yourself.
	super exportToStream: aStream
]

{ #category : 'launcher' }
StLauncherImageProperties >> generateLaunchScriptFrom: scriptFilePath debugCommandError: debugCommandErrorBool [

	"The scriptFilePath file contains the smalltalk code to launch a smalltalk script ... 
		in general nothing needs to be done to the script. Override if the vm
		needs to handle smalltalk execution differently"
]

{ #category : 'accessing' }
StLauncherImageProperties >> imageAlias [
	"an imageAlias allows one to use a different set of properties while running 
		in the same image. See aliases."

	"imageAlias should not be exported to disk"

	^ imageAlias ifNil: [ self name ]
]

{ #category : 'accessing' }
StLauncherImageProperties >> imageAlias: aString [
	"an imageAlias allows one to use a different set of properties while running 
		in the same image. See aliases."

	"imageAlias should not be exported to disk"

	imageAlias := aString
]

{ #category : 'accessing' }
StLauncherImageProperties >> imageDirectory [

	^ imageDirectory ifNil: [ imageDirectory := self imagePath asFileReference ]
]

{ #category : 'accessing' }
StLauncherImageProperties >> imagePath [

	^ imagePath ifNil: [ imagePath := self defaultPropertiesDirectory pathString ]
]

{ #category : 'accessing' }
StLauncherImageProperties >> imagePath: aString [

	imagePath := aString
]

{ #category : 'accessing' }
StLauncherImageProperties >> structureName [

	^ structureName
]

{ #category : 'accessing' }
StLauncherImageProperties >> structureName: aString [

	structureName := aString
]

{ #category : 'accessing' }
StLauncherImageProperties >> version [

	self subclassResponsibility: #version
]
