Class {
	#name : 'StLauncherProperties',
	#superclass : 'Object',
	#instVars : [
		'name'
	],
	#category : 'st_launcher-Properties'
}

{ #category : 'accessing' }
StLauncherProperties class >> defaultPropertiesDirectory [

	^ '$HOME' asFileReference / '.st_launcher'
]

{ #category : 'instance creation' }
StLauncherProperties class >> defaultPropertyFile [

	self self propertyFileNamed: self defaultPropertyFilename
]

{ #category : 'accessing' }
StLauncherProperties class >> defaultPropertyFilename [

	^ 'st_launcher_home'
]

{ #category : 'instance creation' }
StLauncherProperties class >> propertyFile: aFilePath [

	aFilePath asFileReference readStreamDo: [:stream | ^ STON fromStream: stream ]
]

{ #category : 'instance creation' }
StLauncherProperties class >> propertyFileNamed: aName [

	self propertyFile:  self defaultPropertiesDirectory / aName, 'ston'
]

{ #category : 'accessing' }
StLauncherProperties >> name [

	^ name
]

{ #category : 'accessing' }
StLauncherProperties >> name: aString [

	name := aString
]
