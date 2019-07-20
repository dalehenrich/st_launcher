Class {
	#name : 'StLauncherScript',
	#superclass : 'StashScript',
	#instVars : [
		'currentImageName',
		'scriptOptionsMap',
		'orderedOptions'
	],
	#category : 'st_launcher-Stash'
}

{ #category : 'script launching' }
StLauncherScript class >> loadAndExecuteScriptClassFile: script_file stashArgs: stash_args imageName: theImageName workingDir: working_dir projectName: projectName packageName: packageName symDictName: symbolDictName [

	| projectDefinition scriptClassDefinition stash |
	self _createScriptExecutionSymbolDictionaryNamed: symbolDictName.
	projectDefinition := Rowan stashTools classTool 
		loadTonelClassFile: script_file
		projectName: projectName
		packageName: packageName
		symDictName: symbolDictName.
	scriptClassDefinition := (projectDefinition packages values any) classDefinitions values any.
	stash := ((GsCurrentSession currentSession symbolList objectNamed: scriptClassDefinition name) 
		stashFilePath: script_file 
		imageName: theImageName 
		stashArgs: stash_args
		workingDir: working_dir)
			projectName: projectName;
			packageName: packageName;
			yourself.
	^ stash setupAndExecuteScript
]

{ #category : 'script launching' }
StLauncherScript class >> loadAndExecuteScriptClassFile: script_file stashArgs: stash_args topazArgs: topaz_args workingDir: working_dir projectName: projectName packageName: packageName symDictName: symbolDictName [

	| projectDefinition scriptClassDefinition stash |
	self _createScriptExecutionSymbolDictionaryNamed: symbolDictName.
	projectDefinition := Rowan stashTools classTool 
		loadTonelClassFile: script_file
		projectName: projectName
		packageName: packageName
		symDictName: symbolDictName.
	scriptClassDefinition := (projectDefinition packages values any) classDefinitions values any.
	stash := ((GsCurrentSession currentSession symbolList objectNamed: scriptClassDefinition name) 
		stashFilePath: script_file 
		topazArgs: topaz_args 
		stashArgs: stash_args
		workingDir: working_dir)
			projectName: projectName;
			packageName: packageName;
			yourself.
	^ stash setupAndExecuteScript
]

{ #category : 'instance creation' }
StLauncherScript class >> stashFilePath: stashFilePath imageName: theImageName stashArgs: stashArgs workingDir: workingDir [

	^ self new
		stashFilePath: stashFilePath;
		currentImageName: theImageName; 
		stashArgString: stashArgs; 
		workingDirectoryPath: workingDir;
		yourself
]

{ #category : 'io' }
StLauncherScript class >> stderr [

	^StLauncherCommon stderr
]

{ #category : 'io' }
StLauncherScript class >> stdout [

	^StLauncherCommon stdout
]

{ #category : 'accessing' }
StLauncherScript >> currentImageName [

	^ currentImageName
]

{ #category : 'accessing' }
StLauncherScript >> currentImageName: aString [

	currentImageName := aString
]

{ #category : 'script execution' }
StLauncherScript >> executeScript [

	opts
		at: 'help'
    ifAbsent: [
		self preExecute.
		self orderedOptions do: [:option |
			(opts includesKey: option)
				ifTrue: [
					| selector |
					selector := (self scriptOptionsMap at: option) at: 4.
					selector numArgs = 0
						ifTrue: [ self perform: selector asSymbol ]
						ifFalse: [ self perform: selector asSymbol with: (opts at: option) ] ] ].
		self postExecute ] 
    ifPresent: [ ^ self usage ]
]

{ #category : 'accessing' }
StLauncherScript >> orderedOptions [

	^ orderedOptions ifNil: [ orderedOptions := {} ]
]

{ #category : 'script execution' }
StLauncherScript >> postExecute [
]

{ #category : 'script execution' }
StLauncherScript >> preExecute [
]

{ #category : 'options' }
StLauncherScript >> scriptMethodOptions [
	^ {
			#('help' $h  #none #usage).
	}
]

{ #category : 'script execution' }
StLauncherScript >> scriptOptions [

	| ar ordered |
	ar := self scriptMethodOptions.
	ordered := self orderedOptions.
	^ ar collect: [:argAr |
		self scriptOptionsMap at: (argAr at: 1) put: argAr.
		orderedOptions add: (argAr at: 1).
		argAr copyFrom: 1 to: 3 ].
]

{ #category : 'accessing' }
StLauncherScript >> scriptOptionsMap [

	^ scriptOptionsMap ifNil: [ scriptOptionsMap := Dictionary new ]
]

{ #category : 'script utilities' }
StLauncherScript >> stderr [

	^ self class stderr
]

{ #category : 'script utilities' }
StLauncherScript >> stdout [

	^ self class stdout
]
