#!/usr/local/bin/smalltalk/gemstone/st_launcher
"
Delete the given image from the registry and delete the imageProperties.ston
	file from the image directory. 

	--deleteImageDir
		Instead of deleting just the imageProperties.ston file, delete the entire
		image directory.
"
Class {
	#name : 'StL_DeleteImage',
	#superclass : 'AbstractProgram',
	#instVars : [
		'deleteImageDir'
	],
	#category : 'st_launcher-Commands'
}

{ #category : 'script options' }
StL_DeleteImage >> shoulDeleteImageDir [

	^ deleteImageDir ifNil: [ false ]
]

{ #category : 'script options' }
StL_DeleteImage >> deleteImageDir [

	deleteImageDir := true
]

{ #category : 'accessing' }
StL_DeleteImage >> imageName [

	^ args at: 1
]

{ #category : 'main' }
StL_DeleteImage >> main [
	| structureProperties imageDirPath imageDir |
	structureProperties := StLauncherProperties defaultPropertyFile.
	imageDirPath := structureProperties imageMap 
		removeKey: self imageName
		ifAbsent: [ self error: 'The image named ' , self imageName printString , ' is not registered as an image' ].
	self shoulDeleteImageDir ifFalse: [
		structureProperties export.
		self stderr nextPutAll: self imageName printString, ' removed from registry.'; lf.
 		^ self sentinelObject ].
	imageDir := imageDirPath asFileReference.
	imageDir deleteAll. 
	structureProperties export.
	self stderr 
		nextPutAll: 
			self imageName printString, 
				' removed from registry. Directory ';
		lf;
		nextPutAll: 
				imageDir pathString asString, 
				' deleted.';
		lf.
]

{ #category : 'script options' }
StL_DeleteImage >> scriptMethodOptions [
	^ super scriptMethodOptions, 
	{
			#('deleteImageDir' nil #none #deleteImageDir).
	}
]

{ #category : 'usage' }
StL_DeleteImage >> usageExamples: scriptName [

	^	scriptName, ' gs_350
	', scriptName, ' --deleteImageDir gs_350
'
]

{ #category : 'usage' }
StL_DeleteImage >> usageSynopsis: scriptName [

	^	(super usageSynopsis: scriptName), ' ( [--deleteImageDir ] <image-name>'
]
