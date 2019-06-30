Class {
	#name : 'StLauncherImageProperties',
	#superclass : 'StLauncherProperties',
	#instVars : [
		'structureName'
	],
	#category : 'st_launcher-Properties'
}

{ #category : 'accessing' }
StLauncherImageProperties class >> platformName [

	^ ''
]

{ #category : 'accessing' }
StLauncherImageProperties class >> propertyClassForPlatform: platformName [

	^ self subclasses detect: [:each | each platformName = platformName ] ifNone: [ self error: 'Platform name ', platformName printString , ' not reconized.' ]
]

{ #category : 'exporting' }
StLauncherImageProperties >> export [

	self export: self class defaultPropertiesDirectory / self name, 'ston'
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
