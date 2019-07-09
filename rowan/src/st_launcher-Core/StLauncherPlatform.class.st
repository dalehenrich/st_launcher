"
Abstract class that defines the standard protocol expected to be implemented by each platform
"
Class {
	#name : 'StLauncherPlatform',
	#superclass : 'StLauncherCommon',
	#instVars : [
		'structureProperties'
	],
	#category : 'st_launcher-Core'
}

{ #category : 'instance creation' }
StLauncherPlatform class >> createImageNamed: imageName platform: platformName version: versionString [

	^ (self platformClassFor: platformName) createImageNamed: imageName version: versionString
]

{ #category : 'instance creation' }
StLauncherPlatform class >> download: productVersionString platform: platformName [

	^ (self platformClassFor: platformName) download: productVersionString
]

{ #category : 'launcher' }
StLauncherPlatform class >> generateVmScriptLaunchCommandLineFrom:  interpreterOptions [

	"fabricate a platform-specific command line for executing the stashFile"

	| imagePath imageName imageProperties idx tokens vmArgs |

	vmArgs := ''.
	imageName := self structureProperties defaultImageName.

	tokens := interpreterOptions subStrings.
	idx := tokens indexOf: '--'.
	idx > 0
		ifTrue: [
			1 to: idx -1 do: [:i |
				| arg |
				arg := tokens at: i.
				(arg findString: '-' startingAt: 1) = 1
					ifTrue: [ vmArgs := vmArgs, ' ', arg ]
					ifFalse: [
						i = 1 ifTrue: [ imageName := arg ] ] ] ].
	vmArgs isEmpty ifTrue: [ vmArgs := ' -lq' ].
	
	imagePath := (StLauncherPlatform 
		imageNamed: imageName 
		ifAbsent: [ self error: 'No image named ', imageName printString, ' found ' ]) asFileReference.
	imageProperties := StLauncherProperties propertyFile: imagePath / StLauncherImageProperties defaultPropertyFilename.
	^ imageProperties generateVmScriptLaunchCommandLineFrom:  interpreterOptions vmArgs: vmArgs
]

{ #category : 'images' }
StLauncherPlatform class >> imageNamed: aString ifAbsent: absentBlock [


	^ self new imageNamed: aString 
		ifPresent: [:imageProperties | ^ imageProperties ]
		ifAbsent: absentBlock
]

{ #category : 'images' }
StLauncherPlatform class >> imageNamed: aString ifPresent: presentBlock ifAbsent: absentBlock [


	^ self new imageNamed: aString ifPresent: presentBlock ifAbsent: absentBlock
]

{ #category : 'accessing' }
StLauncherPlatform class >> platformClassFor: platformName [

	^ self subclasses detect: [:each | each platformName = platformName] ifNone: [ self error: 'No platform class matching ', platformName printString, ' found'].
]

{ #category : 'accessing' }
StLauncherPlatform class >> platformName [

	self subclassResponsibility: #platformName
]

{ #category : 'images' }
StLauncherPlatform >> createImageNamed: imageName version: versionString [

	self subclassResponsibility: #createImageNamed:version:
]

{ #category : 'products' }
StLauncherPlatform >> download: productVersionString alternateFtpDir: alternameFtpDir [

	self subclassResponsibility: #download:alternateFtpDir:
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

{ #category : 'accessing' }
StLauncherPlatform >> platformName [

	^ self class platformName
]

{ #category : 'io' }
StLauncherPlatform >> stdout: aString [
	"Write aString to stdout with a trailing lf"

	self subclassResponsibility: #stdout:
]

{ #category : 'properties' }
StLauncherPlatform >> structureProperties [

	^ structureProperties ifNil: [ structureProperties := super structureProperties ]
]

{ #category : 'properties' }
StLauncherPlatform >> structureProperties: aValueOrNil [

	^ structureProperties := aValueOrNil
]
