Extension { #name : 'AbstractLauncherProgram' }

{ #category : '*st_launcher-program-gemstone' }
AbstractLauncherProgram class >> stderr [

	^ GsFile stderr
]

{ #category : '*st_launcher-program-gemstone' }
AbstractLauncherProgram class >> stdin [

	^ GsFile stdin
]

{ #category : '*st_launcher-program-gemstone' }
AbstractLauncherProgram class >> stdout [

	^ GsFile stdout
]
