#!/usr/local/bin/smalltalk/gemstone/st_launcher
"
Start a smalltalk client for the image named on the command line.
"
Class {
	#name : 'StL_StartImage',
	#superclass : 'AbstractProgram',
	#instVars : [
		'imageProperties',
		'verbose'
	],	
	#category : 'st_launcher-Workspaces'
}

{ #category : 'main' }
StL_StartImage >> main [
	| cmdStream ar platform imageName |

	args size < 1 ifTrue: [ self error: 'Required image name missing' ].
	imageName := args at: 1.
	imageProperties := StLauncherPlatform 
		propertiesForImageNamed: imageName 
		ifAbsent: [ self error: 'No image named ', imageName printString, ' found' ].
	cmdStream := WriteStream on: String new.
	platform := imageProperties platformName.
	platform = 'pharo'
		ifTrue: [
			| cmd |
			cmd := imageProperties isHeadless
				ifTrue: [ 'pharo' ]
				ifFalse: [ 'pharo-ui' ].
			cmdStream
				nextPutAll: (imageProperties imageDirectory / cmd) pathString;
				nextPutAll: ' Pharo.image ';
				yourself ]
		ifFalse: [ 
			platform = 'gemstone'
				ifTrue: [
					cmdStream
						nextPutAll: (imageProperties productDirectory / 'bin' / 'topaz') pathString;
						nextPutAll: ' -I ', (imageProperties imageDirectory / imageProperties topaziniFilename) pathString;
						nextPutAll: ' -u ', imageProperties cacheName;
						nextPutAll: ' -l';
						yourself.
					imageProperties isTopazSolo
			 			ifTrue: [
							cmdStream 
								nextPutAll: ' -C "GEM_SOLO_EXTENT=';
								nextPutAll: self soloSnapshot;
								nextPutAll: '"';
								yourself ] ]
				ifFalse: [ self error: 'Unsupported platform ', platform printString ] ].
			
	self verbose ifTrue: [ self stderr nextPutAll: cmdStream contents; lf ].
	ar := GsHostProcess _execute: cmdStream contents encodeAsUTF8 input: nil.
	(ar at: 1) isEmpty ifFalse: [ self stderr nextPutAll: (ar at: 1) ; lf ].
	(ar at: 2) isEmpty ifFalse: [ self stderr nextPutAll: (ar at: 2); lf ].
	^ imageProperties
]

{ #category : 'accessing' }
StL_StartImage >> imageProperties: aStLauncherImageProperties [

	^ imageProperties := aStLauncherImageProperties
]

{ #category : 'accessing' }
StL_StartImage >> verbose [

	^ verbose ifNil: [ false ]
]

{ #category : 'accessing' }
StL_StartImage >> verbose: aBool [

	^ verbose := aBool
]

StL_StartImage >> usageExamples: scriptName [

	^	scriptName, ' <image-name> 
'
]

