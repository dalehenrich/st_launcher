Extension { #name : 'AbstractProgram' }

{ #category : '*st_launcher-stash' }
AbstractProgram >> imageProperties [

	^ self structureProperties propertiesForImageNamed: self currentImageName
]

{ #category : '*st_launcher-stash' }
AbstractProgram >> structureProperties [

	^ StLauncherProperties defaultPropertyFile
]
