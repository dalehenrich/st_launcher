Class {
	#name : 'StLauncherGemStoneSnapshots',
	#superclass : 'StLauncherGemStoneSystem',
	#category : 'st_launcher-GemStone-Services'
}

{ #category : 'public' }
StLauncherGemStoneSnapshots >> snapshot: snapshotExtension to: snapshotDirPath suspendInMinutes: suspendInMinutes safely: safely [

	"a commit should be performed before calling this method, to make sure that the snapshot contains any changed state 
		in the current session that you want preserved"
]
