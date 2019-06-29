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

	^ self propertyFileNamed: self defaultPropertyFilename
]

{ #category : 'accessing' }
StLauncherProperties class >> defaultPropertyFilename [

	^ 'st_launcher_home'
]

{ #category : 'instance creation' }
StLauncherProperties class >> propertyFile: aFilePath [

	aFilePath asFileReference readStreamDo: [:fileStream | 
		| stream |
		stream := ZnBufferedReadStream on: fileStream. "hack for now"
	^ STON fromStream: stream ]
]

{ #category : 'instance creation' }
StLauncherProperties class >> propertyFileNamed: aName [

	^ self propertyFile:  self defaultPropertiesDirectory / aName, 'ston'
]

{ #category : 'exporting' }
StLauncherProperties >> export [

	self subclassResponsibility: #export
]

{ #category : 'accessing' }
StLauncherProperties >> name [

	^ name
]

{ #category : 'accessing' }
StLauncherProperties >> name: aString [

	name := aString
]
