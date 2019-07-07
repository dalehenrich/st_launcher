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

{ #category : 'properties' }
StLauncherCommon >> structureProperties [

	^ StLauncherProperties defaultPropertyFile
]
