Extension { #name : 'StLauncherAbstractPlatform' }

{ #category : '*st_launcher-gemstone-services' }
StLauncherAbstractPlatform class >> checkpoints [

	^ StLauncherGemStoneCheckpoints new
]

{ #category : '*st_launcher-gemstone-services' }
StLauncherAbstractPlatform class >> snapshots [

	^ StLauncherGemStoneSnapshots new
]

{ #category : '*st_launcher-gemstone-services' }
StLauncherAbstractPlatform >> checkpoints [

	^ self checkpoints
]

{ #category : '*st_launcher-gemstone-services' }
StLauncherAbstractPlatform >> snapshots [

	^ self snapshots
]
