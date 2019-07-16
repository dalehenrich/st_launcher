#!/usr/local/bin/smalltalk/gemstone/st_launcher
"
a Stash Script
"
Class {
	#name : 'StLauncher_GemStone_Commit_Restore_Script',
	#superclass : 'StLauncherScript',
	#instVars : [
	],
	#category : 'st_launcher-GemStone-Scripts'
}

{ #category : 'script execution' }
StLauncher_GemStone_Commit_Restore_Script >> postExecute [

	| status index |
	status := SystemRepository restoreStatus.
	index := status 
			findString: 'Restoring from transaction log files' 
			startingAt: 1 
			caseSensitive: false.
	index > 1
		ifTrue: [ ^self error: 'System is not prepared to commit restore: ', status].
	GsFile stderr
		nextPutAll: 'Performing commitRestore ... log in again to start using the restored system';
		lf.
	status := SystemRepository commitRestore.
	"normally terminates the session"
	^self error: 'Commit restore failed: ', status
]

{ #category : 'options' }
StLauncher_GemStone_Commit_Restore_Script >> scriptMethodOptions [
	^ {
			#('help' $h #'none' #usage).
	}
]

{ #category : 'usage' }
StLauncher_GemStone_Commit_Restore_Script >> usage [
	"Man page for script"
	| dashes |
	dashes := '----------------------------------------------------
'.
	^ GsFile stdout nextPutAll: dashes,
		(self manPageClass
			fromString:
'NAME
	commitRestore.gs.st - do a GemStone commit restore
SYNOPSIS
	commitRestore.gs.st [ <image-name> [ <vm-arguments> ] -- ]

DESCRIPTION
	After running the restore.gs.st script, a commitRestore.gs.st is required.

EXAMPLES
	./commitRestore.gs.st --help
	./commitRestore.gs.st gs_350

') printString, dashes
]
