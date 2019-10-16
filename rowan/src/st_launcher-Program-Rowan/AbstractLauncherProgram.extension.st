Extension { #name : 'AbstractLauncherProgram' }

{ #category : '*st_launcher-program-rowan' }
AbstractLauncherProgram class >> loadAndExecuteScriptClassFile: script_file stashArgs: stash_args imageName: theImageName scriptName: theScriptName workingDir: working_dir [ 

	^ self 
		loadAndExecuteScriptClassFile: script_file 
			stashArgs: stash_args 
			imageName: theImageName 
			scriptName: theScriptName
			workingDir: working_dir 
			projectName: '__EXECUTE_STASH_SCRIPT_PROJECT__'
			packageName: '__EXECUTE_STASH_SCRIPT_PACKAGE__'
			symDictName: '_EXECUTE_STASH_SCRIPT_SymbolDict__'
]

{ #category : '*st_launcher-program-rowan' }
AbstractLauncherProgram class >> loadAndExecuteScriptClassFile: script_file stashArgs: stash_args imageName: theImageName scriptName: theScriptName workingDir: working_dir projectName: projectName packageName: packageName symDictName: symbolDictName [

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
			scriptName: theScriptName;
			yourself.
	^ stash setupAndExecuteScript
]
