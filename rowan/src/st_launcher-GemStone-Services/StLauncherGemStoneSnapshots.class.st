Class {
	#name : 'StLauncherGemStoneSnapshots',
	#superclass : 'StLauncherGemStoneSystem',
	#instVars : [
		'checkpoints'
	],
	#category : 'st_launcher-GemStone-Services'
}

{ #category : 'accessing' }
StLauncherGemStoneSnapshots >> checkpoints [

	checkpoints ifNil: [ checkpoints := super checkpoints ]
]

{ #category : 'public' }
StLauncherGemStoneSnapshots >> takeSnapshots: snapshotExtension to: snapshotDirPath suspendInMinutes: suspendInMinutes safely: safely [

	"a commit should be performed before calling this method, to make sure that the snapshot contains any changed state 
		in the current session that you want preserved"

	"one snapshot file is copied to the shapshotDirPath per system extent"

	| snapshots snapshotDirRef |
	snapshotDirRef := snapshotDirPath asFileReference.
	[ 
	self checkpoints suspendCheckpoints: suspendInMinutes suspendInMinutes.
	snapshots := {}.
	self snapshotExtentFilePaths
		do: [ :extentPath | 
			| extent extentName snapshotName snapshotFile performCopy |
			extent := extentPath asFileReference.
			snapshotName := extentName := extent basename.
			(extentName asFileReference extension = 'dbf')
				ifTrue: [ 
					snapshotName := (extentName copyFrom: 1 to: extentName size - 3)
						, snapshotExtension ].
			snapshotFile:= snapshotDirRef / snapshotName.
			performCopy := safely
				ifTrue: [ snapshotFile exists not ]
				ifFalse: [ true ].
			GsFile stdout lf.
			performCopy
				ifTrue: [ 
					GsFile stdout nextPutAll:
							'---Starting snapshot to ' , (extentPath , ' ' , snapshotFile pathString) printString
								, '(' , DateAndTime now asString , ')';
						lf.
					snapshotFile exists
						ifTrue: [ snapshotFile delete ].
					extent copyTo: snapshotFile.
					snapshots add: snapshotFile.
					GsFile stdout
						nextPutAll:
								'---Finishing snapshot ' , DateAndTime now asString , ' -- ' , snapshotFile pathString;
						lf]
				ifFalse: [ 
					GsFile stdout nextPutAll:
							'The snapshot file exists, --safely present, copy skipped for: '
								, snapshotFile printString;
						lf ] ].
	self checkpoints checkpointsSuspended
		ifFalse: [ 
			snapshots do: [ :snapshotFile| snapshotFile delete ].
			self
				error:
					'Checkpoints were resumed before the extent copies were completed. Extent copies have been deleted.' ] ]
		ensure: [ self checkpoints resumeCheckpoints ].
	^ snapshots
]
