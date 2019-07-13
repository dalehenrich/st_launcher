#!/usr/local/bin/smalltalk/gemstone/st_launcher
"
a Stash Script
"
Class {
	#name : 'StLauncher_GemStone_Backup_Script',
	#superclass : 'StLauncherScript',
	#instVars : [
		'backupDirectory'
	],
	#category : 'st_launcher-GemStone-Scripts'
}

{ #category : 'private' }
StLauncher_GemStone_Backup_Script >> _backupDirectory [
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

{ #category : 'script execution' }
StLauncher_GemStone_Backup_Script >> postExecute [

	| theBackupPath sessId result |
	theBackupPath :=  self _backupDirectory.
	GsFile stdout nextPutall: 'Waiting for vote to complete...'; lf.
	System waitForVoteStateIdle.
	sessId := System sessionIdHoldingGcLock.
	sessId ~~ 0
		ifTrue: [ 
			self
				error:
					'System has completed voting, but the gc lock is still being held by session with id '
						, sessId printString , '.' ].
	GsFile stdout nextPutall: 'Vote complete.'; lf.
	GsFile stdout nextPutall: '---Starting backup to ' , theBackupPath printString , ' (';
		nextPutall: DateAndTime now asString;
		nextPutall: ')';
		lf.
	result := SystemRepository fullBackupTo: theBackupPath.
	result == true
		ifFalse: [ ^ self error: 'Could not complete the backup: ' , result ].
	GsFile stdout nextPutall: '---Finished backup '; lf
]

{ #category : 'options' }
StLauncher_GemStone_Backup_Script >> scriptMethodOptions [
	^ {
			#('help' $h #'none' #usage).
			#('dir' nil #'required' #backupPath:).
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
	backup.gs.st [ <image-name> [ <vm-arguments> ] -- ] [ --dir=<backup-directory> ] <backup-filename> 

DESCRIPTION
	Default <backup-directory> is $ST_LAUNCHER_HOME/images/<image-name>/backups.
	If <backup-directory> is a relative path, the directory will be resolved relative to
	$ST_LAUNCHER_HOME/images/<image-name>. 

	Default <image-name> is defined by the #defaultImageName field in 
	$HOME/.st_launcher/st_launcher_home.ston.

EXAMPLES
	./backup.gs.st --help
	./backup.gs.st gs_350 -- extent0.st_launcher.dbf
	./backup.gs.st  --dir=snapshots extent0.st_launcher.dbf

') printString, dashes
]
