Extension { #name : 'StLauncherServices' }

{ #category : '*st_launcher-gemstone-services' }
StLauncherServices class >> checkpoints [

	^ StLauncherGemStoneCheckpoints new
]

{ #category : '*st_launcher-gemstone-services' }
StLauncherServices class >> snapshots [

	^ StLauncherGemStoneSnapshots new
]

{ #category : '*st_launcher-gemstone-services' }
StLauncherServices >> checkpoints [

	^ self class checkpoints
]

{ #category : '*st_launcher-gemstone-services' }
StLauncherServices >> snapshots [

	^ self class snapshots
]
