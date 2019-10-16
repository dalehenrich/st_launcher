Class {
	#name : 'AbstractLauncherProgram',
	#superclass : 'AbstractStashScript',
	#instVars : [
		'currentImageName',
		'_scriptName',
		'scriptOptionsMap',
		'orderedOptions'
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

{ #category : 'accessing' }
AbstractLauncherProgram >> currentImageName [

	^ currentImageName
]

{ #category : 'accessing' }
AbstractLauncherProgram >> currentImageName: aString [

	currentImageName := aString
]

{ #category : 'accessing' }
AbstractLauncherProgram >> orderedOptions [

	^ orderedOptions ifNil: [ orderedOptions := OrderedCollection new ]
]

{ #category : 'script execution' }
AbstractLauncherProgram >> postExecute [
]

{ #category : 'script execution' }
AbstractLauncherProgram >> preExecute [
]

{ #category : 'options' }
AbstractLauncherProgram >> scriptMethodOptions [
	^ {
			#('help' $h  #none #usage).
	}
]

{ #category : 'accessing' }
AbstractLauncherProgram >> scriptName [

	^ _scriptName
]

{ #category : 'accessing' }
AbstractLauncherProgram >> scriptName: aString [

	_scriptName := aString
]

{ #category : 'script execution' }
AbstractLauncherProgram >> scriptOptions [

	| ar ordered |
	ar := self scriptMethodOptions.
	ordered := self orderedOptions.
	^ ar collect: [:argAr |
		self scriptOptionsMap at: (argAr at: 1) put: argAr.
		ordered add: (argAr at: 1).
		argAr copyFrom: 1 to: 3 ].
]

{ #category : 'accessing' }
AbstractLauncherProgram >> scriptOptionsMap [

	^ scriptOptionsMap ifNil: [ scriptOptionsMap := Dictionary new ]
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
