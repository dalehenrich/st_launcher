Class {
	#name : 'StLauncherCommon',
	#superclass : 'Object',
	#category : 'st_launcher-Core'
}

{ #category : 'install / uninstall' }
StLauncherCommon class >> _deleteStructure [

	| launcherProperties |
	launcherProperties := StLauncherProperties defaultPropertyFile.
	launcherProperties images children 
		do: [:ent | 
			ent isDirectory
				ifTrue: [ ent ensureDeleteAll ] ].
	launcherProperties imageMap: nil.

	launcherProperties platforms children 
		do: [:ent | 
			ent isDirectory
				ifTrue: [ ent ensureDeleteAll ] ].
	launcherProperties productMap: nil.

	launcherProperties export.
]

{ #category : 'properties' }
StLauncherCommon >> structureProperties [

	^ StLauncherProperties defaultPropertyFile
]
