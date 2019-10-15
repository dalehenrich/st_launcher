Extension { #name : 'StLauncherServices' }

{ #category : '*st_launcher-gemstone-core' }
StLauncherServices class >> chmod: args [

	|  ar cmd |
	cmd := '/bin/chmod ', args .
	ar := GsHostProcess 
		_execute: cmd
		input: nil.
	^ar at: 1
]

{ #category : '*st_launcher-gemstone-core' }
StLauncherServices class >> downloadHttps: httpsUrl  to:  filePath [

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
		nextPutAll: (ar at: 1);
		yourself.
	GsFile stderr
		nextPutAll: (ar at: 2);
		yourself.
].
	^ (ar at: 1) "stdout"
]

{ #category : '*st_launcher-gemstone-core' }
StLauncherServices class >> uname [

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
		nextPutAll: (ar at: 1);
		yourself.
	GsFile stderr
		nextPutAll: (ar at: 2);
		yourself.
].
	^ (ar at: 1) trimRight	"stdout"
]

{ #category : '*st_launcher-gemstone-core' }
StLauncherServices class >> unzip: zipFile to: directory [
    

	| ar cmd |
	cmd := '/usr/bin/unzip -q -d ', directory asFileReference resolve pathString, ' ',  zipFile asFileReference resolve pathString.
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

{ #category : '*st_launcher-gemstone-core' }
StLauncherServices class >> which: filename [

	|  ar cmd |
	cmd := '/usr/bin/which ', filename .
	[
	ar := GsHostProcess 
		_execute: cmd
		input: nil.
	^(ar at: 1) trimRight ] on: Error do: [:ignored | ^ nil ]
]
