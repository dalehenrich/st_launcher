Class {
	#name : 'StLauncherGemStonePlatform',
	#superclass : 'StLauncherPlatform',
	#category : 'st_launcher-GemStone-Core'
}

{ #category : 'instance creation' }
StLauncherGemStonePlatform class >> createImageNamed: imageName version: versionString [

	^ (self new)
		createImageNamed: imageName version: versionString;
		yourself
]

{ #category : 'accessing' }
StLauncherGemStonePlatform class >> platformName [

	^ 'gemstone'
]

{ #category : 'images' }
StLauncherGemStonePlatform >> createImageNamed: imageName version: versionString [

	| imageProperties |
	self imageNamed: imageName
		ifPresent: [:imagePath | self error: 'An image named ', imageName printString, ' already exists (', imagePath printString, ' ).' ]
		ifAbsent: [].
	imageProperties := ((StLauncherImageProperties propertyClassForPlatform: self platformName) 
			named: imageName version: versionString)
				structureName: self structureProperties name;
				yourself.
	imageProperties 
		export;							"initializes directory paths to defaults if not explicitly set"
		createStandardStructure;	"create structure on disk"
		yourself.

	self imageMap at: imageName put: imageProperties imagePath.

	self structureProperties export.
]

{ #category : 'io' }
StLauncherGemStonePlatform >> stdout: aString [
	"Write aString to stdout with a trailing lf"

	GsFile stdout nextPutAll: aString; lf.
]
