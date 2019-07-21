Class {
	#name : 'StLauncherGemStonePlatform',
	#superclass : 'StLauncherPlatform',
	#category : 'st_launcher-GemStone-Platform'
}

{ #category : 'instance creation' }
StLauncherGemStonePlatform class >> createImageNamed: imageName version: versionString [

	^ self new createImageNamed: imageName version: versionString
]

{ #category : 'instance creation' }
StLauncherGemStonePlatform class >> createSoloImageNamed: imageName version: versionString sourceSnapshotFile: snapshotPath [

	^ self new createSoloImageNamed: imageName version: versionString sourceSnapshotFile: snapshotPath
]

{ #category : 'instance creation' }
StLauncherGemStonePlatform class >> download: productVersionString [


	^ self download: productVersionString alternateFtpDir: nil
]

{ #category : 'instance creation' }
StLauncherGemStonePlatform class >> download: productVersionString alternateFtpDir: alternameFtpDir [


	^ self new download: productVersionString alternateFtpDir: alternameFtpDir
]

{ #category : 'accessing' }
StLauncherGemStonePlatform class >> platformName [

	^ 'gemstone'
]

{ #category : 'actions' }
StLauncherGemStonePlatform >> addImageForProperties: imageProperties [

	self structureProperties addImageForProperties: imageProperties.
	self structureProperties export.
	self structureProperties: nil.
]

{ #category : 'actions' }
StLauncherGemStonePlatform >> createImageNamed: imageName version: versionString [

	| imageProperties |
	self imageNamed: imageName
		ifPresent: [:imagePath | self error: 'An image named ', imageName printString, ' already exists (', imagePath printString, ' ).' ]
		ifAbsent: [].
	((self structureProperties productMap at: self platformName ifAbsent: [ Dictionary new ]) includesKey: versionString)
		ifFalse: [ self download: versionString ].
	imageProperties := ((StLauncherImageProperties propertyClassForPlatform: self platformName) 
			named: imageName version: versionString)
				structureName: self structureProperties name;
				yourself.
	imageProperties productPath: ((self structureProperties productMap at: self platformName) at: versionString).
	imageProperties 
		export;							"initializes directory paths to defaults if not explicitly set"
		createStandardStructure;	"create structure on disk"
		yourself.

	self addImageForProperties: imageProperties.	"register image"

	imageProperties export.

	^ imageProperties
]

{ #category : 'actions' }
StLauncherGemStonePlatform >> createSoloImageNamed: imageName version: versionString sourceSnapshotFile: snapshotPath [

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

{ #category : 'products' }
StLauncherGemStonePlatform >> download: productVersionString [

	^ self download: productVersionString alternateFtpDir: nil
]

{ #category : 'products' }
StLauncherGemStonePlatform >> download: productVersionString alternateFtpDir: alternameFtpDir [

	| productProperties |
	productProperties := StLauncherGemStoneProductProperties version: productVersionString.
	productProperties downloadFile exists
		ifFalse: [
true ifTrue: [
			'$GS_HOME/shared/downloads/zip/GemStone64Bit3.5.0-x86_64.Linux.zip' asFileReference copyTo: productProperties downloadFile.
]
ifFalse: [
			StLauncherGemStoneSystem 
				downloadHttps: productProperties downloadHttpsUrl
				to: productProperties downloadFile pathString.
] ].
	StLauncherGemStoneSystem unzip: productProperties downloadFile to: productProperties products.

	productProperties productDirectory exists
		ifFalse: [ "ln -s $GS_SHARED_DOWNLOADS/products/${dlvers} ${gs_product}" self halt].

	productProperties export.
	(productProperties structureProperties productMap 
		at: productProperties platformName
		ifAbsentPut: [ Dictionary new ])
			at: productProperties productVersionString
			put: productProperties productDirectory pathString.
	productProperties structureProperties export.
	self structureProperties: nil.
]
