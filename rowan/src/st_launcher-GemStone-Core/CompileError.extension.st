Extension { #name : 'CompileError' }

{ #category : '*st_launcher-gemstone-core' }
CompileError >> description [
	| errorString stream |
	errorString := GsNMethod
		_sourceWithErrors: self errorDetails
		fromString: (gsArgs at: 2).
	stream := WriteStream on: String new.
	stream
		nextPutAll: super description;
		lf;
		nextPutAll: '-------------------------------------------------------';
		lf;
		nextPutAll: errorString;
		lf;
		yourself.
	^ stream contents
]
