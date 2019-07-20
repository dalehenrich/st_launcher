Class {
	#name : 'StLauncherCommon',
	#superclass : 'Object',
	#category : 'st_launcher-Core'
}

{ #category : 'install / uninstall' }
StLauncherCommon class >> _deleteStructure [

	StLauncherImageProperties _deleteStructure.
	StLauncherProductProperties _deleteStructure.
]

{ #category : 'error handling' }
StLauncherCommon >> error: aString [

	^ StashCommandError signal: aString
]

{ #category : 'io' }
StLauncherCommon >> stderr [

	^ self class stderr
]

{ #category : 'io' }
StLauncherCommon >> stdout [

	^ self class stdout
]

{ #category : 'properties' }
StLauncherCommon >> structureProperties [

	^ StLauncherProperties defaultPropertyFile
]
