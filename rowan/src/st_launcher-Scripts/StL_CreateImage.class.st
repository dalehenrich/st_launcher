#!/usr/local/bin/smalltalk/gemstone/st_launcher
"
Create a new gemstone or pharo image of the given version in the given 
	directory. 

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
		'snapshotPath'
	],
	#category : 'st_launcher-Scripts'
}

{ #category : 'private' }
StL_CreateImage >> _platformClass [

	self imageType = 'pharo' ifTrue: [ ^ StLauncherPharoPlatform ].
	self imageType = 'gemstone' ifTrue: [ ^ StLauncherGemStonePlatform ].
	self imageType = 'gemstoneSolo' ifTrue: [ ^ StLauncherGemStoneSoloPlatform ].
	self error: 'Unknown image type', self imageType printString, '. Expecting pharo | gemstone | gemstoneSolo'
]

{ #category : 'private' }
StL_CreateImage >> _validateOptions [
	self imageType ifNil: [ self error: 'Required imageType argument is missing' ].
	self _platformClass.	"triggers error, if not a know image type"
	self imageVersion ifNil: [ self error: 'Require `--version` option is not specified' ].
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
	self _platformClass
		createImageNamed: self imageName
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
			#('gemstone' $g #none #gemstoneImage).
			#('pharo' $p #none #pharoImage).
			#('dir' nil #required #imageDirectory:).
			#('version' nil #required #imageVersion:).
	}
]

{ #category : 'accessing' }
StL_CreateImage >> snapshotPath [

	^ snapshotPath ifNil: []
]

{ #category : 'usage' }
StL_CreateImage >> usageExamples: scriptName [

	^	scriptName, ' --gemstone --version=3.5.0 gs_350
	', scriptName, ' --pharo --version=70-64 pharo_70

	', scriptName, ' --pharo --dir=$HOME/images --version=70-64 pharo_70
'
]

{ #category : 'usage' }
StL_CreateImage >> usageSynopsis: scriptName [

	^	(super usageSynopsis: scriptName), ' ( [--gemstone | -g] | [--pharo| -p ] ) \
		--version=<image-version> [--dir=<directory-path> ] <image-name>'
]
