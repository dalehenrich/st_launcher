stashFile := '/home/dhenrich/rogue/_homes/rogue/_home/shared/repos/st_launcher/rowan/src/st_launcher-Scripts/StLauncher_Hello.class.st'.
scriptArgs := ''.
imageName := 'admin_pharo_70'.
pwd := '/home/dhenrich/rogue/_homes/rogue/_home/shared/repos/st_launcher'.
debugCommandError := true.
	[
		StLauncherScript
			loadAndExecuteScriptClassFile: stashFile
			stashArgs: scriptArgs
			imageName: imageName
			workingDir: pwd
			projectName: '__EXECUTE_STASH_SCRIPT_PROJECT__'
			packageName: '__EXECUTE_STASH_SCRIPT_PACKAGE__'
			symDictName: '_EXECUTE_STASH_SCRIPT_SymbolDict__'.
		true	]
		on: StashCommandError", Error, FileDoesNotExistException"
		do: [:ex |
			debugCommandError
				ifTrue: [ ex pass ]
				ifFalse: [ 
					StashScript
						ansiRedOn: StLauncherScript stderr 
						during: [ StLauncherScript stderr nextPutAll: ex description, ' ', ex messageText ].
					StLauncherScript stderr lf.
					false ] ].

