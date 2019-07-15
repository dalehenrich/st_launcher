#!/usr/local/bin/smalltalk/gemstone/st_launcher
"
a Stash Script
"
Class {
	#name : 'StLauncher_GemStone_Restore_Script',
	#superclass : 'StLauncherScript',
	#instVars : [
		'backupDirectory',
		'backupFile'
	],
	#category : 'st_launcher-GemStone-Scripts'
}

{ #category : 'private' }
StLauncher_GemStone_Restore_Script >> _backupDirectory [

	| structureProperties imageProperties |
	backupDirectory ifNotNil: [ ^ backupDirectory ].
	structureProperties := StLauncherProperties defaultPropertyFile.
	imageProperties := structureProperties propertiesForImageNamed: self currentImageName.
	backupDirectory :=  imageProperties backupsDirectory.
	^ backupDirectory
]

{ #category : 'actions' }
StLauncher_GemStone_Restore_Script >> backupFile: aString [

	backupFile := aString
]

{ #category : 'private' }
StLauncher_GemStone_Restore_Script >> _backupFile [

	^ backupFile ifNil: [ self args at: 1 ]
]

{ #category : 'actions' }
StLauncher_GemStone_Restore_Script >> backupPath: fullOrRelativePath [

	| fileRef structureProperties imageProperties |
	fileRef := fullOrRelativePath asFileReference.
	fileRef isAbsolute
		ifTrue: [ 
			backupDirectory := fileRef.
			^ self ].
	structureProperties := StLauncherProperties defaultPropertyFile.
	imageProperties := structureProperties propertiesForImageNamed: self currentImageName.
	backupDirectory :=  imageProperties imageDirectory / fileRef
]

{ #category : 'script execution' }
StLauncher_GemStone_Restore_Script >> postExecute [

	| status count |
	status := SystemRepository restoreStatus.
	status = 'Restore is not active.'
		ifFalse: [ ^ self error: 'System is already in restore mode: ' , status ].
	System stopUserSessions.
	count := 0.
	[ 
	| sessionCount |
	sessionCount := 0.
	System currentSessions
		do: [ :index | 
			| id sessionArray |
			sessionArray := System descriptionOfSession: index.
			id := (sessionArray at: 1) userId.
			(id = 'GcUser' or: [ id = 'SymbolUser' ])
				ifFalse: [ sessionCount := sessionCount + 1 ] ].
	count < 30 and: [ sessionCount > 1 ] ]
		whileTrue: [ 
			(Delay forSeconds: 1) wait.
			count := count + 1 ].
	count >= 30
		ifTrue: [ 
			^ self
				error:
					'Could not restore from backup because there are still sessions logged in.' ].
	self restoreFromBackup: self _backupDirectory / self _backupFile
]

{ #category : 'restore' }
StLauncher_GemStone_Restore_Script >> restoreFromBackup: aBackupFileRef [

	"restore from backup"

	| backupPath |
	backupPath := aBackupFileRef pathString.
  GsFile stderr
    nextPutAll: '---Starting restore from ' , backupPath printString , ' (', DateAndTime now printString, ')';
		lf.
 	[SystemRepository restoreFromBackup: backupPath ]
		on: Error
		do: [:ex |
			ex gsNumber  ~~ 4046
        ifTrue: [ ^ ex pass ].
      GsFile stderr
       	nextPutAll: ex description;
				lf ].
	"must logout to continue execution"
]

{ #category : 'options' }
StLauncher_GemStone_Restore_Script >> scriptMethodOptions [
	^ {
			#('help' $h #'none' #usage).
			#('dir' nil #'required' #backupPath:).
	}
]

{ #category : 'usage' }
StLauncher_GemStone_Restore_Script >> usage [
	"Man page for script"
	| dashes |
	dashes := '----------------------------------------------------
'.
	^ GsFile stdout nextPutAll: dashes,
		(self manPageClass
			fromString:
'NAME
	restore.gs.st - do a GemStone restore into the current image
SYNOPSIS
	restore.gs.st [ <image-name> [ <vm-arguments> ] -- ] [ --dir=<backup-directory> ] \
		<restore-filename> 

DESCRIPTION
	Default <restore-directory> is $ST_LAUNCHER_HOME/images/<image-name>/backups.
	If <restore-directory> is a relative path, the directory will be resolved relative to
	$ST_LAUNCHER_HOME/images/<image-name>. 

	Default <image-name> is defined by the #defaultImageName field in 
	$HOME/.st_launcher/st_launcher_home.ston.

EXAMPLES
	./restore.gs.st --help
	./restore.gs.st gs_350 -- extent0.st_launcher.dbf
	./restore.gs.st --dir=snapshots extent0.st_launcher.dbf
	./restore.gs.st --dir=/home/me/backups extent0.st_launcher.dbf

') printString, dashes
]
