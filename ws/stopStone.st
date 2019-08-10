#!/usr/local/bin/smalltalk/gemstone/st_launcher
"
Read image properties off of objin (or file on command line) and stop the 
	stone using the `stopstone` command: 

		stopstone[Info]: GemStone version '3.5.0'
		Usage: stopstone [-h] [-i] [-t timeout] [name [account [password]]]
		  where -h       prints usage information and exits.
		        -i       stops the stone immediately even if others are logged in.
		        -t       specifies how long to wait for other processes to detach the cache.
		                 Default is -1 which means wait forever.
		        name     is the name of the stone to stop (default is gs64stone).
		        account  a privileged GemStone user ID, typically DataCurator.
		        password for the specified account (default will be prompted for).

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
	| cmdStream stdInStream ar |

	imageProperties := (args size = 1)
		ifTrue: [ (STONReader on: (args at: 1) asFileReference contents readStream) next ]
		ifFalse: [ self objIn next ].
	cmdStream := (WriteStream on: String new)
		nextPutAll: (imageProperties productDirectory / 'bin' / 'stopstone') pathString;
		nextPutAll: ' -i';
		nextPutAll: ' ', imageProperties name;
		nextPutAll: ' SystemUser';
		yourself.
	stdInStream := (WriteStream on: String new) 
		nextPutAll: 'swordfish';
		lf;
		yourself.
	self verbose ifTrue: [ self stderr nextPutAll: cmdStream contents; lf ].
	ar := GsHostProcess _execute: cmdStream contents encodeAsUTF8 input: stdInStream contents.
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

