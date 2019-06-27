"
Abstract class that defines the standard protocol expected to be implemented by each platform
"
Class {
	#name : 'StLauncherAbstractPlatform',
	#superclass : 'Object',
	#category : 'st_launcher-Core'
}

{ #category : 'io' }
StLauncherAbstractPlatform >> stdout: aString [
	"Write aString to stdout with a trailing lf"

	self subclassResponsibility: #stdout:
]
