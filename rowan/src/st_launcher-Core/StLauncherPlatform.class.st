"
Abstract class that defines the standard protocol expected to be implemented by each platform
"
Class {
	#name : 'StLauncherPlatform',
	#superclass : 'Object',
	#instVars : [
		'structureProperties'
	],
	#category : 'st_launcher-Core'
}

{ #category : 'image creation' }
StLauncherPlatform >> createImageNamed: imageNameS platform: platformName version: versionString [
]

{ #category : 'io' }
StLauncherPlatform >> stdout: aString [
	"Write aString to stdout with a trailing lf"

	self subclassResponsibility: #stdout:
]

{ #category : 'properties' }
StLauncherPlatform >> structureProperties [

	^ structureProperties ifNil: [ structureProperties := StLauncherProperties defaultPropertyFile ]
]
