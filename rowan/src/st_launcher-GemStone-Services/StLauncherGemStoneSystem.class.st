Class {
	#name : 'StLauncherGemStoneSystem',
	#superclass : 'StLauncherServices',
	#category : 'st_launcher-GemStone-Services'
}

{ #category : 'copydbf' }
StLauncherGemStoneSystem class >> copydbf: sourceFile to: destFile args: args [

	| cmdPath ar cmd |
	cmdPath := '$GEMSTONE/bin/copydbf' asFileReference resolve pathString.
	cmd := cmdPath, ' ', sourceFile asFileReference resolve pathString, ' ', destFile asFileReference resolve pathString, ' ', args.
	GsFile stdout lf; nextPutAll: cmd; lf.
	ar := GsHostProcess 
		_execute: cmd
		input: nil.
	GsFile stdout 
		lf; 
		nextPutAll: 'STDOUT:';
		lf; 
		nextPutAll: (ar at: 1);
		lf;
		nextPutAll: 'STDERR:';
		lf; 
		nextPutAll: (ar at: 2);
		yourself.
	^ ar at: 1	"stdout"
]

{ #category : 'copydbf' }
StLauncherGemStoneSystem class >> uname [

	|  ar cmd |
	cmd := '/bin/uname -sm'.
	ar := GsHostProcess 
		_execute: cmd
		input: nil.
	cmd :=  '/usr/bin/tr '' '' ''-'''.
	ar := GsHostProcess 
		_execute: cmd
		input: (ar at: 1).
false ifTrue: [
	GsFile stdout 
		lf; 
		nextPutAll: 'STDOUT:';
		lf; 
		nextPutAll: (ar at: 1);
		lf;
		nextPutAll: 'STDERR:';
		lf; 
		nextPutAll: (ar at: 2);
		yourself.
].
	^ ar at: 1	"stdout"
]

{ #category : 'copydbf' }
StLauncherGemStoneSystem >> copydbf: sourceFile to: destFile args: args [

	self class copydbf: sourceFile to: destFile args: args
]

{ #category : 'io' }
StLauncherGemStoneSystem >> stdout: aString [
	"Write aString to stdout with a trailing lf"

	GsFile stdout nextPutAll: aString; lf.
]
