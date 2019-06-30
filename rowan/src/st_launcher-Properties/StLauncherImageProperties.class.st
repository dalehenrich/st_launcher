Class {
	#name : 'StLauncherImageProperties',
	#superclass : 'StLauncherProperties',
	#instVars : [
		'structureName',
		'structureProperties'
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

	^ #( structureProperties )
]

{ #category : 'exporting' }
StLauncherImageProperties >> export [

	self export: self defaultPropertiesDirectory / self defaultPropertyFilename
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
