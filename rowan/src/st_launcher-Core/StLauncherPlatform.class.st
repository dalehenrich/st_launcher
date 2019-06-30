"
Abstract class that defines the standard protocol expected to be implemented by each platform
"
Class {
	#name : 'StLauncherPlatform',
	#superclass : 'Object',
	#instVars : [
		'structureProperties'
	],
	#category : 'st_launcher-Core'
}

{ #category : 'instance creation' }
StLauncherPlatform class >> createImageNamed: imageName platform: platformName version: versionString [

	^ (self platformClassFor: platformName)  createImageNamed: imageName version: versionString
]

{ #category : 'accessing' }
StLauncherPlatform class >> platformClassFor: platformName [

	^ self subclasses detect: [:each | each platformName = platformName] ifNone: [ self error: 'No platform class matching ', platformName printString, ' found'].
]

{ #category : 'accessing' }
StLauncherPlatform class >> platformName [

	self subclassResponsibility: #platformName
]

{ #category : 'images' }
StLauncherPlatform >> createImageNamed: imageName version: versionString [

	self subclassResponsibility: #createImageNamed:version:
]

{ #category : 'images' }
StLauncherPlatform >> imageMap [

	^ self structureProperties imageMap
]

{ #category : 'images' }
StLauncherPlatform >> imageNamed: aString ifPresent: presentBlock ifAbsent: absentBlock [

	| imageProperties |
	imageProperties := self imageMap at: aString ifAbsent: [ ^ absentBlock value ].
	^ presentBlock cull: imageProperties
]

{ #category : 'images' }
StLauncherPlatform >> images [

	^ self structureProperties images
]

{ #category : 'accessing' }
StLauncherPlatform >> platformName [

	^ self class platformName
]

{ #category : 'io' }
StLauncherPlatform >> stdout: aString [
	"Write aString to stdout with a trailing lf"

	self subclassResponsibility: #stdout:
]

{ #category : 'properties' }
StLauncherPlatform >> structureProperties [

	^ structureProperties ifNil: [ structureProperties := StLauncherProperties defaultPropertyFile ]
]
