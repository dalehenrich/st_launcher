Extension { #name : #StLauncherScript }

{ #category : #'*st_launcher-Stash-Pharo' }
StLauncherScript class >> loadAndExecuteScriptClassFile: script_file stashArgs: stash_args imageName: theImageName workingDir: working_dir [ 

	| scriptClassFile  stashScriptClass definitions definitionOrders stash |
	definitionOrders := TonelReader definitionOrders.
	scriptClassFile := script_file asFileReference.
	definitions := (scriptClassFile readStreamDo: [ :s | 
		s nextLine.	"skip the shebang line"
		TonelParser parseStream: s ])
			flattened
			sort: [ :a :b | (definitionOrders at: a class) < (definitionOrders at: b class) ].
	definitions sort do: [ :definition | definition load ].
	stashScriptClass := self environment classNamed: definitions first className.
	stash := stashScriptClass
		stashFilePath: script_file 
		imageName: theImageName 
		stashArgs: stash_args
		workingDir: working_dir.
	^ stash setupAndExecuteScript
]
