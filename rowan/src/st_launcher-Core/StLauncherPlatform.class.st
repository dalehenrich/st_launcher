"
Abstract class that defines the standard protocol expected to be implemented by each platform
"
Class {
	#name : 'StLauncherPlatform',
	#superclass : 'StLauncherCommon',
	#instVars : [
		'structureProperties'
	],
	#category : 'st_launcher-Core'
}

{ #category : 'instance creation' }
StLauncherPlatform class >> createImageNamed: imageName platform: platformName version: versionString [

	^ (self platformClassFor: platformName) createImageNamed: imageName version: versionString
]

{ #category : 'instance creation' }
StLauncherPlatform class >> download: productVersionString platform: platformName [

	^ (self platformClassFor: platformName) download: productVersionString
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

{ #category : 'products' }
StLauncherPlatform >> download: productVersionString alternateFtpDir: alternameFtpDir [

	self subclassResponsibility: #download:alternateFtpDir:
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

	^ structureProperties ifNil: [ structureProperties := super structureProperties ]
]

{ #category : 'properties' }
StLauncherPlatform >> structureProperties: aValueOrNil [

	^ structureProperties := aValueOrNil
]
