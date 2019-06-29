Extension { #name : 'StLauncherPlatform' }

{ #category : '*st_launcher-gemstone-services' }
StLauncherPlatform class >> checkpoints [

	^ StLauncherGemStoneCheckpoints new
]

{ #category : '*st_launcher-gemstone-services' }
StLauncherPlatform class >> snapshots [

	^ StLauncherGemStoneSnapshots new
]

{ #category : '*st_launcher-gemstone-services' }
StLauncherPlatform >> checkpoints [

	^ self checkpoints
]

{ #category : '*st_launcher-gemstone-services' }
StLauncherPlatform >> snapshots [

	^ self snapshots
]
