Class {
	#name : 'AbstractLauncherProgram',
	#superclass : 'AbstractStashScript',
	#instVars : [
		'currentImageName',
		'_scriptName'
	],
	#category : 'st_launcher-Program'
}

{ #category : 'instance creation' }
AbstractLauncherProgram class >> stashFilePath: stashFilePath imageName: theImageName stashArgs: stashArgs workingDir: workingDir [

	^ self new
		stashFilePath: stashFilePath;
		currentImageName: theImageName; 
		stashArgString: stashArgs; 
		workingDirectoryPath: workingDir;
		yourself
]

{ #category : 'io' }
AbstractLauncherProgram class >> stderr [

	^StLauncherCommon stderr
]

{ #category : 'io' }
AbstractLauncherProgram class >> stdin [

	^StLauncherCommon stdin
]

{ #category : 'io' }
AbstractLauncherProgram class >> stdout [

	^StLauncherCommon stdout
]

{ #category : 'accessing' }
AbstractLauncherProgram >> currentImageName [

	^ currentImageName
]

{ #category : 'accessing' }
AbstractLauncherProgram >> currentImageName: aString [

	currentImageName := aString
]

{ #category : 'accessing' }
AbstractLauncherProgram >> scriptName [

	^ _scriptName
]

{ #category : 'accessing' }
AbstractLauncherProgram >> scriptName: aString [

	_scriptName := aString
]

{ #category : 'script utilities' }
AbstractLauncherProgram >> stderr [

	^ self class stderr
]

{ #category : 'script utilities' }
AbstractLauncherProgram >> stdin [

	^ self class stdin
]

{ #category : 'script utilities' }
AbstractLauncherProgram >> stdout [

	^ self class stdout
]
