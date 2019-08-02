Extension { #name : #StLauncherCommon }

{ #category : #'*st_launcher-pharo-core' }
StLauncherCommon class >> stderr [

	^ Stdio stderr
]

{ #category : #'*st_launcher-pharo-core' }
StLauncherCommon class >> stdin [

	^ Stdio stdin
]

{ #category : #'*st_launcher-pharo-core' }
StLauncherCommon class >> stdout [

	^ Stdio stdout
]
