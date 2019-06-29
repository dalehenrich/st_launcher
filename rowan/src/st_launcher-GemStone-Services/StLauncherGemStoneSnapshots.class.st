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

	^ checkpoints ifNil: [ checkpoints := super checkpoints ]
]

{ #category : 'accessing' }
StLauncherGemStoneSnapshots >> snapshotExtentFilePaths [
	^ SystemRepository fileNames
		collect: [ :each | 
			(each indexOf: $! startingAt: 1) = 0
				ifTrue: [ each ]
				ifFalse: [ 
					| idx |
					"in 2.4.x, the NRS is tacked on the front of the filename"
					idx := each indexOf: $! startingAt: 2.
					each copyFrom: idx + 1 to: each size ] ]
]

{ #category : 'public' }
StLauncherGemStoneSnapshots >> takeSnapshots: snapshotExtension to: snapshotDirPath suspendInMinutes: suspendInMinutes safely: safely [

	"
		acommit should be performed before calling this method, to make sure that the snapshot contains any changed state 
		in the current session that you want preserved.

		One snapshot file is copied to the shapshotDirPath per system extent.  The name of the snapshot file itself is 
		constructed by replacing the extension of the extent file name with <snapshotExtension>.

		The list of new snapshotFiles is returned.
	"

	| snapshots snapshotDirRef |
	snapshotDirRef := snapshotDirPath asFileReference.
	[ 
	self checkpoints suspendCheckpoints: suspendInMinutes.
	snapshots := {}.
	self snapshotExtentFilePaths
		do: [ :extentPath | 
			| extent snapshotName snapshotFile performCopy |
			extent := extentPath asFileReference.
			snapshotName := extent basenameWithoutExtension.
			snapshotFile:= snapshotDirRef / snapshotName, snapshotExtension.
			performCopy := true.
			safely
				ifTrue: [ 
					snapshotFile exists 
						ifTrue: [ 
							GsFile stdout 
								lf;
								nextPutAll:
									'The snapshot file exists, --safely present, copy skipped for: '
										, snapshotFile printString;
								lf.
							performCopy := false ] ].
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
