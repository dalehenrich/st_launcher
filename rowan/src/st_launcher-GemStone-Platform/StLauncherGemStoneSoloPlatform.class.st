Class {
	#name : 'StLauncherGemStoneSoloPlatform',
	#superclass : 'StLauncherGemStonePlatform',
	#category : 'st_launcher-GemStone-Platform'
}

{ #category : 'instance creation' }
StLauncherGemStoneSoloPlatform class >> createImageNamed: imageName version: versionString from: aRequestor [
	^ self createImageNamed: imageName version: versionString sourceSnapshotFile: aRequestor snapshotPath
]

{ #category : 'instance creation' }
StLauncherGemStoneSoloPlatform class >> createImageNamed: imageName version: versionString sourceSnapshotFile: snapshotPath [

	^ self new createImageNamed: imageName version: versionString sourceSnapshotFile: snapshotPath
]

{ #category : 'accessing' }
StLauncherGemStoneSoloPlatform class >> platformType [

	^ 'gemstoneSolo'
]

{ #category : 'actions' }
StLauncherGemStoneSoloPlatform >> createImageNamed: imageName version: versionString sourceSnapshotFile: snapshotPath [

	| imageProperties |
	self imageNamed: imageName
		ifPresent: [:imagePath | self error: 'An image named ', imageName printString, ' already exists (', imagePath printString, ' ).' ]
		ifAbsent: [].
	imageProperties := (StLauncherGemStoneSoloImageProperties 
			named: imageName version: versionString)
				structureName: self structureProperties name;
				yourself.
	imageProperties productPath: ((self structureProperties productMap at: self platformName) at: versionString).

	imageProperties soloSnapshot: snapshotPath asFileReference pathString.

	imageProperties 
		export;							"initializes directory paths to defaults if not explicitly set"
		createStandardStructure;	"create structure on disk"
		yourself.

	self addImageForProperties: imageProperties.	"register image"

	imageProperties export.

	^ imageProperties
]
