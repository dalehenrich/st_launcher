Class {
	#name : 'StLauncherGemStoneSystem',
	#superclass : 'StLauncherServices',
	#category : 'st_launcher-GemStone-Services'
}

{ #category : 'io' }
StLauncherGemStoneSystem >> stdout: aString [
	"Write aString to stdout with a trailing lf"

	GsFile stdout nextPutAll: aString; lf.
]
