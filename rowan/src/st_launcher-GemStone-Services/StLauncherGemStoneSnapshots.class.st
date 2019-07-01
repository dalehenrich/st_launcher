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
			| extent snapshotName snapshotFile snapshotFileRef performCopy |
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
					snapshotFileRef := snapshotFile asFileReference.
					snapshotFileRef extensions last ~= 'gz'
						ifTrue: [ snapshotFileRef := snapshotFileRef , 'gz' ].	".gz extension required for gzip compression"
					GsFile stdout nextPutAll:
							'---Starting snapshot to ' , (extentPath , ' ' , snapshotFileRef pathString) printString
								, '(' , DateAndTime now asString , ')';
						lf.
					snapshotFileRef exists
						ifTrue: [ snapshotFileRef delete ].
					self copydbf: extent to: snapshotFileRef args: '-C'.	"use gzip compression"
					snapshots add: snapshotFileRef.
					GsFile stdout
						nextPutAll:
								'---Finishing snapshot ' , DateAndTime now asString , ' -- ' , snapshotFileRef pathString;
						lf ] ].
	self checkpoints checkpointsSuspended
		ifFalse: [ 
			snapshots do: [ :snapshotFile| snapshotFile delete ].
			self
				error:
					'Checkpoints were resumed before the extent copies were completed. Extent copies have been deleted.' ] ]
		ensure: [ self checkpoints resumeCheckpoints ].
	snapshots do: [:snapShotFile |
		"in order for snapshot files to be usable by a topaz solo gem, the snapshot must be read only"
		| resultString |
		resultString := GsHostProcess execute: '/bin/chmod -w ', snapShotFile pathString.
		GsFile stdout nextPutAll: resultString ].
	^ snapshots
]
