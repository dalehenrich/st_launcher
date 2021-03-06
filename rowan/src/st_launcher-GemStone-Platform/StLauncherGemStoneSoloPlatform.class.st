Class {
	#name : 'StLauncherGemStoneSoloPlatform',
	#superclass : 'StLauncherGemStonePlatform',
	#category : 'st_launcher-GemStone-Platform'
}

{ #category : 'instance creation' }
StLauncherGemStoneSoloPlatform class >> createImageNamed: imageName comment: commentString version: versionString from: aRequestor [
	^ self createImageNamed: imageName comment: commentString version: versionString soloExtentPath: aRequestor soloExtentPath
]

{ #category : 'instance creation' }
StLauncherGemStoneSoloPlatform class >> createImageNamed: imageName comment: commentString version: versionString soloExtentPath: soloExtentPath [
	^ self new
		createImageNamed: imageName
		comment: commentString
		version: versionString
		soloExtentPath: soloExtentPath
]

{ #category : 'accessing' }
StLauncherGemStoneSoloPlatform class >> platformType [

	^ 'gemstoneSolo'
]

{ #category : 'actions' }
StLauncherGemStoneSoloPlatform >> createImageNamed: imageName comment: commentString version: versionString soloExtentPath: soloExtentPath [

	| imageProperties |
	self imageNamed: imageName
		ifPresent: [:imagePath | self error: 'An image named ', imageName printString, ' already exists (', imagePath printString, ' ).' ]
		ifAbsent: [].
	imageProperties := (StLauncherGemStoneSoloImageProperties 
			named: imageName version: versionString)
				comment: commentString;
				structureName: self structureProperties name;
				yourself.
	imageProperties productPath: ((self structureProperties productMap at: self platformName) at: versionString).

	imageProperties soloSnapshot: soloExtentPath asFileReference pathString.

	imageProperties 
		export;							"initializes directory paths to defaults if not explicitly set"
		createStandardStructure;	"create structure on disk"
		yourself.

	self addImageForProperties: imageProperties.	"register image"

	imageProperties export.

	^ imageProperties
]
