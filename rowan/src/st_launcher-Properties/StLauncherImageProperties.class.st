Class {
	#name : 'StLauncherImageProperties',
	#superclass : 'StLauncherProperties',
	#instVars : [
		'structureName',
		'structureProperties',
		'imagePath',
		'imageDirectory'
	],
	#category : 'st_launcher-Properties'
}

{ #category : 'accessing' }
StLauncherImageProperties class >> defaultPropertyFilename [

	^ 'imageProperties.ston'
]

{ #category : 'accessing' }
StLauncherImageProperties class >> platformName [

	^ ''
]

{ #category : 'accessing' }
StLauncherImageProperties class >> propertyClassForPlatform: platformName [

	^ self subclasses detect: [:each | each platformName = platformName ] ifNone: [ self error: 'Platform name ', platformName printString , ' not reconized.' ]
]

{ #category : 'actions' }
StLauncherImageProperties >> createStandardStructure [
	"create standard directory structure on disk"
]

{ #category : 'accessing' }
StLauncherImageProperties >> defaultPropertiesDirectory [

	^ self structureProperties images / self name
]

{ #category : 'accessing' }
StLauncherImageProperties >> defaultPropertyFilename [

	^ self class defaultPropertyFilename
]

{ #category : 'ston' }
StLauncherImageProperties >> excludedInstVarNames [

	^ super excludedInstVarNames , #( imageDirectory )
]

{ #category : 'exporting' }
StLauncherImageProperties >> export [

	self export: self defaultPropertiesDirectory / self defaultPropertyFilename
]

{ #category : 'exporting' }
StLauncherImageProperties >> export: aFileReferenceOrPath [

	"lazily initialize any of the fields that haven't already been set, that need to be set"

	self 
		imageDirectory;
		yourself.
	super export: aFileReferenceOrPath
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
StLauncherImageProperties >> structureProperties [

	^ structureProperties ifNil: [ structureProperties := super structureProperties ]
]

{ #category : 'accessing' }
StLauncherImageProperties >> version [

	self subclassResponsibility: #version
]