#!/usr/local/bin/smalltalk/gemstone/st_launcher
"
a Stash Script
"
Class {
	#name : 'StLauncher_GemStone_Backup_Script',
	#superclass : 'StLauncherScript',
	#instVars : [
		'backupDirectory',
		'shouldCommit',
		'backupFile'
	],
	#category : 'st_launcher-GemStone-Scripts'
}

{ #category : 'private' }
StLauncher_GemStone_Backup_Script >> _backupDirectory [

	| structureProperties imageProperties |
	backupDirectory ifNotNil: [ ^ backupDirectory ].
	structureProperties := StLauncherProperties defaultPropertyFile.
	imageProperties := structureProperties propertiesForImageNamed: self currentImageName.	backupDirectory := 
	backupDirectory :=  imageProperties backupsDirectory.
	^ backupDirectory
]

{ #category : 'actions' }
StLauncher_GemStone_Backup_Script >> backupFile: aString [

	backupFile := aString
]

{ #category : 'private' }
StLauncher_GemStone_Backup_Script >> _backupFile [

	^ backupFile ifNil: [ self args at: 1 ]
]

{ #category : 'actions' }
StLauncher_GemStone_Backup_Script >> backupPath: fullOrRelativePath [

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

{ #category : 'actions' }
StLauncher_GemStone_Backup_Script >> shouldCommit [

	shouldCommit := true.
]

{ #category : 'script execution' }
StLauncher_GemStone_Backup_Script >> postExecute [

	| theBackupPath sessId result |
	theBackupPath :=  self _backupDirectory.
	GsFile stderr nextPutAll: 'Waiting for vote to complete...'; lf.
	System waitForVoteStateIdle.
	sessId := System sessionIdHoldingGcLock.
	sessId ~~ 0
		ifTrue: [ 
			self
				commandError:
					'System has completed voting, but the gc lock is still being held by session with id '
						, sessId printString , '.' ].
	GsFile stderr nextPutAll: 'Vote complete.'; lf.
	GsFile stderr nextPutAll: '---Starting backup to ' , theBackupPath printString , ' (';
		nextPutAll: DateAndTime now asString;
		nextPutAll: ')';
		lf.
	shouldCommit == true ifTrue: [ self commit ].
	result := SystemRepository fullBackupTo: (theBackupPath / self _backupFile) pathString.
	result == true
		ifFalse: [ ^ self commandError: 'Could not complete the backup: ' , result ].
	GsFile stderr nextPutAll: '---Finished backup '; lf
]

{ #category : 'options' }
StLauncher_GemStone_Backup_Script >> scriptMethodOptions [
	^ {
			#('help' $h #'none' #usage).
			#('dir' nil #'required' #backupPath:).
			#('commit' nil #'none' #shouldCommit).
	}
]

{ #category : 'usage' }
StLauncher_GemStone_Backup_Script >> usage [
	"Man page for script"
	| dashes |
	dashes := '----------------------------------------------------
'.
	^ GsFile stdout nextPutAll: dashes,
		(self manPageClass
			fromString:
'NAME
	backup.gs.st - do a GemStone backup of the current image
SYNOPSIS
	backup.gs.st [ <image-name> [ <vm-arguments> ] -- ] [ --dir=<backup-directory> ] \
		[ --commit ] <backup-filename> 

DESCRIPTION
	Default <backup-directory> is $ST_LAUNCHER_HOME/images/<image-name>/backups.
	If <backup-directory> is a relative path, the directory will be resolved relative to
	$ST_LAUNCHER_HOME/images/<image-name>. 

	Default <image-name> is defined by the #defaultImageName field in 
	$HOME/.st_launcher/st_launcher_home.ston.

	With the --commit option specified a commit will be performed immediately before the 
	backup is run.

EXAMPLES
	./backup.gs.st --help
	./backup.gs.st gs_350 -- extent0.st_launcher.dbf
	./backup.gs.st --dir=snapshots extent0.st_launcher.dbf
	./backup.gs.st --commit --dir=snapshots extent0.st_launcher.dbf

') printString, dashes
]
