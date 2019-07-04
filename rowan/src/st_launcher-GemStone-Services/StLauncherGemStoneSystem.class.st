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

{ #category : 'shell commands' }
StLauncherGemStoneSystem class >> downloadHttps: httpsUrl  to:  filePath [

	| downloadCmd ar |
	downloadCmd := (self which: 'wget')
		ifNotNil: [:cmdPath |  cmdPath, ' --no-verbose -O ', filePath, ' ', httpsUrl ]
		ifNil: [
			(self which: 'curl')
					ifNotNil: [:cmdPath |  cmdPath, ' -O -s -S -o ', filePath, ' ', httpsUrl ]
					ifNil: [ self error: 'neither wget nor curl found ... cannot download' ] ].
	ar := GsHostProcess 
		_execute: downloadCmd
		input: nil.
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
	^ (ar at: 1) "stdout"
]

{ #category : 'shell commands' }
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
	^ (ar at: 1) trimRight	"stdout"
]

{ #category : 'shell commands' }
StLauncherGemStoneSystem class >> unzip: zipFile to: directory [
    

	| ar cmd |
	cmd := '/usr/bin/unzip -q -d ', directory asFileReference resolve pathString, ' ',  zipFile asFileReference resolve pathString.
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

{ #category : 'shell commands' }
StLauncherGemStoneSystem class >> which: filename [

	|  ar cmd |
	cmd := '/usr/bin/which ', filename .
	[
	ar := GsHostProcess 
		_execute: cmd
		input: nil.
	^(ar at: 1) trimRight ] on: Error do: [:ignored | ^ nil ]
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
