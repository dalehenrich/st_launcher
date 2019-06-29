Class {
	#name : 'StLauncherImageProperties',
	#superclass : 'StLauncherProperties',
	#instVars : [
		'structureName'
	],
	#category : 'st_launcher-Properties'
}

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
