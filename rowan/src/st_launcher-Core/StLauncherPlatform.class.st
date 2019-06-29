"
Abstract class that defines the standard protocol expected to be implemented by each platform
"
Class {
	#name : 'StLauncherPlatform',
	#superclass : 'Object',
	#category : 'st_launcher-Core'
}

{ #category : 'io' }
StLauncherPlatform >> stdout: aString [
	"Write aString to stdout with a trailing lf"

	self subclassResponsibility: #stdout:
]
