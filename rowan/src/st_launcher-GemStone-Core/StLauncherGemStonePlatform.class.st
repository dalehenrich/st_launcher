Class {
	#name : 'StLauncherGemStonePlatform',
	#superclass : 'StLauncherPlatform',
	#category : 'st_launcher-GemStone-Core'
}

{ #category : 'io' }
StLauncherGemStonePlatform >> stdout: aString [
	"Write aString to stdout with a trailing lf"

	GsFile stdout nextPutAll: aString; lf.
]
