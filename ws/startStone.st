#!/usr/local/bin/smalltalk/gemstone/st_launcher
"
Read image properties off of objin (or file on command line) and start the 
	stone using the `startstone` command: 

		Usage: startstone [options] [name]
		where 'options' are any of:
		  -C   Startup for conversion of Gs64 v2.4 repository to v3.x.
		  -e   Specifies executable specific configuration file. Default is $GEMSTONE_EXE_CONF
		       environment varible if defined, else  ./<name>.conf . If not found -z must
		       be specified have a usable default (see below).
		  -h   Prints usage information and exits.
		  -l   Specifies the name of the stone log file. Default is per $GEMSTONE_LOG
		       environment variable if defined, else $GEMSTONE/data/<name>.log
		  -N   Startup does not require transaction logs.
		  -R   Start from most recent checkpoint to go into restore mode.
		  -v   Print version and exit.
		  -z   Specifies system configuration file. Default is per $GEMSTONE_SYS_CONF
		       environment variable if defined, else $GEMSTONE/data/system.conf .
		  name is the name of the process.  Default is gs64stone.
"
Class {
	#name : 'WS_',
	#superclass : 'AbstractProgram',
	#instVars : [
		'imageProperties',
		'verbose'
	],	
	#category : 'st_launcher-Workspaces'
}

{ #category : 'main' }
WS_ >> main [
	| cmdStream ar |

	imageProperties := (args size = 1)
		ifTrue: [ (STONReader on: (args at: 1) asFileReference contents readStream) next ]
		ifFalse: [ self objIn next ].
	cmdStream := WriteStream on: String new.
	cmdStream
		nextPutAll: (imageProperties productDirectory / 'bin' / 'startstone') pathString;
		nextPutAll: ' -z ', (imageProperties extentsDirectory / 'system.conf') pathString;
		nextPutAll: ' -l ', (imageProperties logsDirectory  / imageProperties name, 'log') pathString;
		nextPutAll: ' ', imageProperties name;
		yourself.
	self verbose ifTrue: [ self stderr nextPutAll: cmdStream contents; lf ].
	ar := GsHostProcess _execute: cmdStream contents encodeAsUTF8 input: nil.
	(ar at: 1) isEmpty ifFalse: [ self stderr nextPutAll: (ar at: 1) ; lf ].
	(ar at: 2) isEmpty ifFalse: [ self stderr nextPutAll: (ar at: 2); lf ].
	^ imageProperties
]
{ #category : 'accessing' }
WS_ >> verbose [

	^ verbose ifNil: [ false ]
]

{ #category : 'accessing' }
WS_ >> verbose: aBool [

	^ verbose := aBool
]

WS_ >> usageExamples: scriptName [

	^	scriptName, ' -D -- home/images/gs_350/imageProperties.ston
	', scriptName, ' < home/images/gs_350/imageProperties.ston
'
]

