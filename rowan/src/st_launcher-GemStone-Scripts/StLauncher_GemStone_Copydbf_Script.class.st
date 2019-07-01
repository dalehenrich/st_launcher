#!/usr/local/bin/smalltalk/gemstone/stash
"
a Stash Script
"
Class {
	#name : 'StLauncher_GemStone_Copydbf_Script',
	#superclass : 'StashScript',
	#category : 'st_launcher-GemStone-Scripts'
}

{ #category : 'script execution' }
StLauncher_GemStone_Copydbf_Script >> executeScript [

	opts
		at: 'help'
    ifAbsent: [
		| copyDbfArgs dest |
		args size ~= 2
			ifTrue: [ self error: 'missing required positional parameters' ].
		copyDbfArgs := ''.
		opts at: 'gz' ifPresent: [:ignored | copyDbfArgs := '-C' ].
		opts at: 'lz4' ifPresent: [:ignored | copyDbfArgs := '-Z' ].
		dest :=  (args at: 2) asFileReference.
		dest exists ifTrue:  [ dest delete].
		^ StLauncherGemStoneSystem copydbf: (args at: 1) to: (args at: 2) args: copyDbfArgs
	] 
    ifPresent: [ ^ self usage ]
]

{ #category : 'script execution' }
StLauncher_GemStone_Copydbf_Script >> scriptOptions [
	^ {
			#('help' $h #'none').
			#('gz' nil #'none').
			#('lz4' nil #'none').
	}
]

{ #category : 'usage' }
StLauncher_GemStone_Copydbf_Script >> usage [
	| dashes |
	dashes := '----------------------------------------------------
'.
  GsFile stdout nextPutAll: dashes,
		(self manPageClass
          fromString:
'NAME
	copydbf.st - Demonstrate the issue when calling copydbf using GsHostProcess.

SYNOPSIS
  copydbf.st [--help] [--gz] [--lz4] src dest

DESCRIPTION

EXAMPLES
	copydbf.st --help -- MyStone -lq

	copydbf.st extents/extent0.dbf snapshots/extent0.test.dbf -- MyStone -lq
	copydbf.st extents/extent0.dbf snapshots/extent0.test.dbf.gz --gz -- MyStone -lq
	copydbf.st extents/extent0.dbf snapshots/extent0.test.dbf.lz4 --lz4 -- MyStone -lq

') printString, dashes
]
