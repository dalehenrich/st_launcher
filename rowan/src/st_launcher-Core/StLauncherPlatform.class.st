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

{ #category : 'images' }
StLauncherPlatform >> createImageNamed: imageName platform: platformName version: versionString [

	| imageProperties |
	self imageNamed: imageName
		ifPresent: [:imageProps | self error: 'An image named ', imageName printString, ' already exists.']
		ifAbsent: [].
	imageProperties := ((StLauncherImageProperties propertyClassForPlatform: platformName) named: imageName version: versionString)
		structureName: self structureProperties name;
		yourself
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

{ #category : 'io' }
StLauncherPlatform >> stdout: aString [
	"Write aString to stdout with a trailing lf"

	self subclassResponsibility: #stdout:
]

{ #category : 'properties' }
StLauncherPlatform >> structureProperties [

	^ structureProperties ifNil: [ structureProperties := StLauncherProperties defaultPropertyFile ]
]
