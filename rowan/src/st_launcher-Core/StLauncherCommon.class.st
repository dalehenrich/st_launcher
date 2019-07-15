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

{ #category : 'properties' }
StLauncherCommon >> structureProperties [

	^ StLauncherProperties defaultPropertyFile
]
