#!/usr/local/bin/smalltalk/gemstone/st_launcher
"
Create a new gemstone or pharo image of the given version in the given 
	directory. 

	First, the script creates the necessary directory structure to house the
	image. Then the script installs the st_launcher support code into the image.

	For gemstone images, the stone and netldi processes are started.

	For GemstoneSolo images, the extent file is copied from the source path, or
	source image.

	--gemstone
		Create a gemstone image

	--gemstoneSolo
		Create a gemstone solo image

	--pharo
		Create a pharo image

	--dir=<directory-path>
		Create the image in <directory-path>. If no directory is specified, create
		image in the `images` subdirectory of the `#homePath` directory specified 
		in the `$HOME/.config/st_launcher/st_launcher_home.ston` properties file.

	--install=rowan|st_launcher
		After image is created install additional resources. The `rowan` keyword 
		will install Rowan. The `st_launcher` keyword will install Rowan and then
		st_launcher. The --inatall option only applies to pharo and gemstone 
		images.

	--sourceImage=<source-image-name>
		When creating a gemstone solo image, this option defines which image to use
		as the source of the solo extent. The gemstone image is snapshotted and the
		resulting snapshot file is copied to the image's snapshots directory.

	--sourcePath=<solo-extent-path>
		The extent is copied from the given <solo-extent-path> to the image's 
		snapshot directory. Note, the <solo-extent-path> should not point to an extent
		for a running gemstone image.

	--version=<image-version>
		Use the artifacts in the existing <image-version> product tree
		listed in the `platforms/gemstone|pharo` directory relative to the 
		`#homePath` directory specified in the 
		`$HOME/.config/st_launcher/st_launcher_home.ston` properties file.
"
Class {
	#name : 'StL_CreateImage',
	#superclass : 'AbstractProgram',
	#instVars : [
		'imageType',
		'imageDirectory',
		'imageVersion',
		'sourceImage',
		'sourcePath',
		'comment'
	],
	#category : 'st_launcher-Commands'
}

{ #category : 'private' }
StL_CreateImage >> _platformClass [

	self imageType = 'pharo' ifTrue: [ ^ StLauncherPharoPlatform ].
	self imageType = 'gemstone' ifTrue: [ ^ StLauncherGemStonePlatform ].
	self imageType = 'gemstoneSolo' 
		ifTrue: [ 
		self sourceImage 
			ifNil: [ 
				self sourcePath 
					ifNil: []
					ifNotNil: [:path | 
						path asFileReference exists 
							ifFalse: [ self error: 'The snapshot file ', path printString, ' does not exist'] ] ]
			ifNotNil: [:sourceImageName |
				StLauncherPlatform 
					imageNamed: sourceImageName 
					ifAbsent: [ self error: 'The image ', sourceImageName printString, ' doe not exist'] ].
		^ StLauncherGemStoneSoloPlatform ].
	self error: 'Unknown image type', self imageType printString, '. Expecting pharo | gemstone | gemstoneSolo'
]

{ #category : 'private' }
StL_CreateImage >> _validateOptions [
	self imageType ifNil: [ self error: 'Required imageType argument is missing' ].
	self _platformClass.	"triggers error, if not a know image type"
	self imageVersion ifNil: [ self error: 'Require `--version` option is not specified' ].
]

{ #category : 'accessing' }
StL_CreateImage >> comment [

	^ comment ifNil: [ '' ]
]

{ #category : 'accessing' }
StL_CreateImage >> comment: aString [

	comment := aString
]

{ #category : 'script options' }
StL_CreateImage >> gemstoneImage [

	self imageType: 'gemstone'
]

{ #category : 'script options' }
StL_CreateImage >> gemstoneSoloImage [

	self imageType: 'gemstoneSolo'
]

{ #category : 'accessing' }
StL_CreateImage >> imageDirectory [

	^ imageDirectory ifNil: [ imageDirectory := StLauncherProperties defaultPropertiesDirectory images ]
]

{ #category : 'accessing' }
StL_CreateImage >> imageDirectory: aFilePath [ 

	imageDirectory := aFilePath asFileReference
]

{ #category : 'accessing' }
StL_CreateImage >> imageName [

	^ args at: 1
]

{ #category : 'accessing' }
StL_CreateImage >> imageType [

	^ imageType
]

{ #category : 'accessing' }
StL_CreateImage >> imageType: aString [ 

	imageType := aString
]

{ #category : 'accessing' }
StL_CreateImage >> imageVersion [

	^ imageVersion
]

{ #category : 'accessing' }
StL_CreateImage >> imageVersion: aString [ 

	imageVersion := aString
]

{ #category : 'main' }
StL_CreateImage >> main [
	self _validateOptions.
	^ self _platformClass
		createImageNamed: self imageName
		comment: self comment
		version: self imageVersion
		from: self
]

{ #category : 'script options' }
StL_CreateImage >> pharoImage [

	self imageType: 'pharo'
]

{ #category : 'script options' }
StL_CreateImage >> scriptMethodOptions [
	^ super scriptMethodOptions, 
	{
			#('gemstoneSolo' $g #none #gemstoneSoloImage).
			#('gemstone' $g #none #gemstoneImage).
			#('pharo' $p #none #pharoImage).
			#('sourceImage' nil #required #sourceImage).
			#('dir' nil #required #imageDirectory:).
			#('version' nil #required #imageVersion:).
	}
]

{ #category : 'accessing' }
StL_CreateImage >> soloExtentPath [

	"somebody needs to do some copying ... probably the imageProperties guy"
	self halt: 'use source image (or default) to find the location of the solo extent'
]

{ #category : 'usage' }
StL_CreateImage >> usageExamples: scriptName [

	^	scriptName, ' --gemstone --version=3.5.0 gs_350
	', scriptName, ' --gemstone --version=3.5.0 --install=st_launcher gs_350

	', scriptName, ' --gemstoneSolo --sourceImage=gs_350 gs_solo_350

	', scriptName, ' --pharo --version=70-64 pharo_70
	', scriptName, ' --pharo --dir=$HOME/images --version=70-64 pharo_70
'
]

{ #category : 'usage' }
StL_CreateImage >> usageSynopsis: scriptName [

	^	(super usageSynopsis: scriptName), ' ( [--gemstone | -g] | [--pharo| -p ] ) \
		--version=<image-version> [--dir=<directory-path> ] [--install=rowan|st_launcher ] \
		<image-name>'
]
