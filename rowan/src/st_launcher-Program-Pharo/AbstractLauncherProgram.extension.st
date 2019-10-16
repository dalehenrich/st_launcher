Extension { #name : #StLauncherCommon }

{ #category : #'*st_launcher-program-pharo' }
AbstractLauncherProgram class >> stderr [

	^ ZnCharacterWriteStream
		on: Stdio stderr
		encoding: ZnCharacterEncoder utf8
]

{ #category : #'*st_launcher-program-pharo' }
AbstractLauncherProgram class >> stdin [

	^ ZnCharacterReadStream
		on: Stdio stdin
		encoding: ZnCharacterEncoder utf8
]

{ #category : #'*st_launcher-program-pharo' }
AbstractLauncherProgram class >> stdout [

	^ ZnCharacterWriteStream
		on: Stdio stdout
		encoding: ZnCharacterEncoder utf8
]
