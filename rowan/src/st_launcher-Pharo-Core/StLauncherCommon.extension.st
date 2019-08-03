Extension { #name : #StLauncherCommon }

{ #category : #'*st_launcher-pharo-core' }
StLauncherCommon class >> stderr [

	^ ZnCharacterWriteStream
		on: Stdio stderr
		encoding: ZnCharacterEncoder utf8
]

{ #category : #'*st_launcher-pharo-core' }
StLauncherCommon class >> stdin [

	^ ZnCharacterReadStream
		on: Stdio stdin
		encoding: ZnCharacterEncoder utf8
]

{ #category : #'*st_launcher-pharo-core' }
StLauncherCommon class >> stdout [

	^ ZnCharacterWriteStream
		on: Stdio stdout
		encoding: ZnCharacterEncoder utf8
]
