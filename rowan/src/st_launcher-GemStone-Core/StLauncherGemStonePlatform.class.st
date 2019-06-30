Class {
	#name : 'StLauncherGemStonePlatform',
	#superclass : 'StLauncherPlatform',
	#category : 'st_launcher-GemStone-Core'
}

{ #category : 'images' }
StLauncherGemStonePlatform >> createImageNamed: imageName platform: platformName version: versionString [

	| imageProperties |
	self imageNamed: imageName
		ifPresent: [:imageProps | self error: 'An image named ', imageName printString, ' already exists.']
		ifAbsent: [].
	imageProperties := ((StLauncherImageProperties propertyClassForPlatform: platformName) named: imageName version: versionString)
		structureName: self structureProperties name;
		yourself
]

{ #category : 'images' }
StLauncherGemStonePlatform >> createImageNamed: imageName version: versionString [

	^ self createImageNamed: imageName platform: self platformName version: versionString
]

{ #category : 'io' }
StLauncherGemStonePlatform >> stdout: aString [
	"Write aString to stdout with a trailing lf"

	GsFile stdout nextPutAll: aString; lf.
]
