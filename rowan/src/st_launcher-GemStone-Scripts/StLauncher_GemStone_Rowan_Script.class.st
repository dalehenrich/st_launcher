#!/usr/local/bin/smalltalk/gemstone/st_launcher
"
a command line interface to Rowan. See `StashRowanScript.st -h` for more information.
"
Class {
	#name : 'StLauncher_GemStone_Rowan_Script',
	#superclass : 'StLauncherScript',
	#instVars : [
		'operations',
		'theProjectName',
		'theSpecUrl'
	],
	#category : 'st_launcher-GemStone-Scripts'
}

{ #category : 'script execution' }
StLauncher_GemStone_Rowan_Script >> executeScript [
	"Called to initiate execution of the script"
	^ opts
			at: 'help'
			ifAbsent: [ 
				opts at: 'edit' ifPresent: [:arg | self edit ].
				opts at: 'install' ifPresent: [:arg | self install: arg ].
				opts at: 'load' ifPresent: [:arg | self load: arg ].
				opts at: 'unload' ifPresent: [:arg | self unload: arg ].
				opts at: 'write' ifPresent: [:arg | self write: arg ].
				opts at: 'commit' ifPresent: [:arg | self commit: arg message: (args at: 1) ].
				opts at: 'list' ifPresent: [:arg | self list ].
				^ true ]
			ifPresent: [ self usage ]
]

{ #category : 'script implementation' }
StLauncher_GemStone_Rowan_Script >> install: projectSpecUrl [
	| url errFilename spec specUrl specFile |
	specUrl := projectSpecUrl.
	url := specUrl asRwUrl.
	url scheme = 'https'
		ifTrue: [
			| filename |
			filename :=  '/tmp/', self class name asString, '.ston'.
			errFilename := self downloadHttpsFile: specUrl to: filename username: nil pass: nil.
			specUrl := 'file:', filename.
			url := specUrl asRwUrl ].
	specFile := url pathString.
	[specFile  asFileReference readStreamDo: [:fStream | 
		"verify that the .ston file exists and can be read..."
		spec := STON fromString: fStream contents ] ]
		on: Error
		do: [:ex |
			self error: 'ERROR :: ', ex description, ' :: reading project spec from ', specUrl printString, ' ::error could have been cause by:: ', errFilename asFileReference contents ].
	"clone the project to disk"
	Rowan projectTools clone
		cloneSpecUrl: specUrl
		gitRootPath: '$ROWAN_PROJECTS_HOME'
		useSsh: true.
	"load the project"
	^ self load: spec specName
]

{ #category : 'script implementation' }
StLauncher_GemStone_Rowan_Script >> list [

	| stream fields userIdHeader stoneHeader |
	stream := GsFile stdin.

	stoneHeader := (self sessionIsSolo
		ifTrue: [ 'Stone: (solo session)' ]
		ifFalse: [ 'Stone: ', (System stoneName subStrings: $!) last ]) .
	userIdHeader := 'User:  ', System myUserProfile userId.

	fields := (((Rowan projectNames 
		select: [:aProjectName | aProjectName ~= '__EXECUTE_STASH_SCRIPT_PROJECT__']) 
			collect: [:aProjectName | Rowan projectNamed: aProjectName ]) 
				sort: [:a :b | a name <= b name])
					collect: [:project |
						| field branch path isSkew loadedCommitId repositoryCommitId |
						loadedCommitId := project loadedCommitId.
						repositoryCommitId := project repositoryCommitId.
						isSkew := loadedCommitId ~= repositoryCommitId.
						isSkew ifTrue: [ loadedCommitId := loadedCommitId, ' -> ', repositoryCommitId ].
						[ branch :=  project currentBranchName ] on: Error do: [:ex | branch :=  'ERROR getting repository branch' ].
						path := (project repositoryRootPath ifNil: ['no repositoryRootPath']).
						field := Array new: 5.
						field
							at: 1 put: project name;
							at: 2 put: loadedCommitId;
							at: 3 put: branch;
							at: 4 put: path;
							at: 5 put: isSkew;
							yourself ].

	self 
		asciiTabulate: 1 
		titleRow: #()
		bodyRows: { { stoneHeader } . { userIdHeader } }
		do: [:rowString :rowArray | stream nextPutAll: rowString; lf ].

	self 
		asciiTabulate: 4 
		titleRow: { 'Project'. 'Commit'. 'Branch'. 'Repository' }
		bodyRows: fields
		do: [:rowString :rowArray | 
			((rowArray size = 5) and: [ rowArray at: 5 ])
				ifTrue: [ 
					self ansiRedOn: stream during: [ stream nextPutAll: rowString ] ]
				ifFalse: [ stream nextPutAll: rowString ].
			stream lf ].
]

{ #category : 'script implementation' }
StLauncher_GemStone_Rowan_Script >> load: aProjectName [
	"load the project"

	| result |
	result := Rowan projectTools load loadProjectNamed: aProjectName.
	self deleteScriptProject.
	self commit.
	^ result
]

{ #category : 'script execution' }
StLauncher_GemStone_Rowan_Script >> scriptOptions [
	"specify the command line options"
	^ {
			#('help' $h #none).
			#('install' nil #required #install:).
			#('load' nil #required #load:).
			#('unload' nil #required #unload:).
			#('list' nil #none #list).
			#('write' nil #required #write:).
			#('commit' nil #required #commit: ).
			#('edit' nil #none #edit).
	}
]

{ #category : 'script implementation' }
StLauncher_GemStone_Rowan_Script >> unload: aProjectName [
	"unload the project"

	| result |
	result := Rowan projectTools delete deleteProjectNamed: aProjectName.
	self deleteScriptProject.
	self commit.
	^ result
]

{ #category : 'usage' }
StLauncher_GemStone_Rowan_Script >> usage [
	"Man page for script"
	| dashes |
	dashes := '----------------------------------------------------
'.
	^ GsFile stdout nextPutAll: dashes,
		(self manPageClass
			fromString:
'NAME
	StashRowanScript.st - manage Rowan projects
SYNOPSIS
	rowan.gs.st [ imageName [-H] [-D] [-V] [st vm args] -- ]  [script args]

	rowan.gs.st [--help] 
	rowan.gs.st [--install=<spec-url>] 
	rowan.gs.st [--load=<project-name>] 
	rowan.gs.st [--list] 

DESCRIPTION

	--install=<spec-url>
		Download and install the project as specified in the given <spec-url>.

	--load=<project-name>
		load the given <project-name>.

	--list
		list the projects that are loaded in the current image.

EXAMPLES
	rowan.gs.st --help

	rowan.gs.st --install=file:$ROWAN_PROJECTS_HOME/st_launcher/rowan/specs/st_launcher_scripts.ston
	rowan.gs.st --load=st_launcher_scripts
	rowan.gs.st --list 
') printString, dashes
]

{ #category : 'script implementation' }
StLauncher_GemStone_Rowan_Script >> write: aProjectName [
	"write the project to disk"

	Rowan projectTools write writeProjectNamed: aProjectName.
	self deleteScriptProject.
	self commit.
]
