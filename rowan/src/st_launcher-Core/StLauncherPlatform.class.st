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
StLauncherPlatform class >> generateVmScriptLaunchCommandLineFor: imageName vmScriptPath: scriptFilePath launcherArgs:  launcherVmOptions launcherArgMap: launcherArgMap debugCommandError: debugCommandErrorBool [
	"fabricate a platform-specific command line for executing the stashFile"

	"
	<launcherArgMap> is a dictionary whose keys are launcher options and values:
		#none		- no argument
		#required	- required argement
		#optional	- optional argument

	Options in <launcherArgMap> are not to be added to <vmArgs>
	"

	"
	The launcher/vm args may not use positional arguments. The scriptName is the
		first positional parameter on a command line.
	If the same argument is provided in each set of [launcher/vm args], the last 
		version should override any previous versions.
	"

	"return true if the command line was successfully written on stdot, otherwise return false"

	[
		self new 
			generateVmScriptLaunchCommandLineFor: imageName
				vmScriptPath: scriptFilePath
				launcherArgs:  launcherVmOptions 
				launcherArgMap: launcherArgMap 
				debugCommandError: debugCommandErrorBool.
		^ true ]
		on: StashCommandError, Error
		do: [:ex |
			debugCommandErrorBool
				ifTrue: [ ex pass ]
				ifFalse: [
					StashScript 
						ansiRedOn: GsFile stderr 
						during: [ GsFile stderr nextPutAll: ex description ].
					GsFile stderr lf.
				^ false ] ].
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

{ #category : 'launcher' }
StLauncherPlatform >> generateVmScriptLaunchCommandLineFor: defaultImageName vmScriptPath: scriptFilePath launcherArgs:  launcherVmOptions launcherArgMap: launcherArgMap  debugCommandError: debugCommandErrorBool [

	"fabricate a platform-specific command line for executing the stashFile"

	"
	<launcherArgMap> is a dictionary whose keys are launcher options and values:
		#none		- no argument
		#required	- required argement
		#optional	- optional argument

	Options in <launcherArgMap> are not to be added to <vmArgs>
	"

	"
	The launcher/vm args may not use positional arguments. The scriptName is the
		first positional parameter on a command line.
	If the same argument is provided in each set of [launcher/vm args], the last 
		version should override any previous versions.
	"

	| imagePath imageName imageProperties idx tokens vmArgs |

	vmArgs := ''.
	imageName := defaultImageName.

	tokens := launcherVmOptions subStrings.
	idx := tokens indexOf: '--'.
	idx > 0
		ifTrue: [
			1 to: idx -1 do: [:i |
				| token |
				token := tokens at: i.
				(token findString: '-' startingAt: 1) = 1
					ifTrue: [
						launcherArgMap
							at: token
							ifAbsent: [ vmArgs := vmArgs, ' ', token ] ]
					ifFalse: [
						i = 1 
							ifTrue: [ imageName := token ] ] ] ].
	
	imagePath := (StLauncherPlatform 
		imageNamed: imageName 
		ifAbsent: [ self error: 'No image named ', imageName printString, ' found ' ]) asFileReference.
	imageProperties := StLauncherProperties propertyFile: imagePath / StLauncherImageProperties defaultPropertyFilename.
	^ imageProperties 
		generateVmScriptLaunchCommandLineFrom: vmArgs 
			vmScriptPath: scriptFilePath
			debugCommandError: debugCommandErrorBool
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

{ #category : 'images' }
StLauncherPlatform >> propertiesForImageNamed: aString ifPresent: presentBlock ifAbsent: absentBlock [

	^ self structureProperties propertiesForImageNamed: aString ifPresent: presentBlock ifAbsent: absentBlock
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
