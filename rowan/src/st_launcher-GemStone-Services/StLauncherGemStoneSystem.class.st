Class {
	#name : 'StLauncherGemStoneSystem',
	#superclass : 'StLauncherServices',
	#category : 'st_launcher-GemStone-Services'
}

{ #category : 'shell commands' }
StLauncherGemStoneSystem class >> copydbf: sourceFile to: destFile args: args [

	| cmdPath ar cmd |
	cmdPath := '$GEMSTONE/bin/copydbf' asFileReference resolve pathString.
	cmd := cmdPath, ' ', sourceFile asFileReference resolve pathString, ' ', destFile asFileReference resolve pathString, ' ', args.
	GsFile stdout lf; nextPutAll: cmd; lf.
	ar := GsHostProcess 
		_execute: cmd
		input: nil.
	GsFile stdout 
		nextPutAll: (ar at: 1);
		yourself.
	GsFile stderr
		nextPutAll: (ar at: 2);
		yourself.
	^ ar at: 1	"stdout"
]

{ #category : 'copydbf' }
StLauncherGemStoneSystem >> copydbf: sourceFile to: destFile args: args [

	self class copydbf: sourceFile to: destFile args: args
]
