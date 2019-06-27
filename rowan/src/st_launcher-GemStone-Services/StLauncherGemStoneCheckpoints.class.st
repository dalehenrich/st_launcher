Class {
	#name : 'StLauncherGemStoneCheckpoints',
	#superclass : 'StLauncherGemStoneSystem',
	#category : 'st_launcher-GemStone-Services'
}

{ #category : 'utilities' }
StLauncherGemStoneCheckpoints >> checkpointsSuspended [

	^ self checkpointStatus at: 1
]

{ #category : 'utilities' }
StLauncherGemStoneCheckpoints >> checkpointStatus [
 "An array of 2 elements.  The first element is a boolean indicating
 if checkpoints are currently suspended.  The second element is an
 Integer indicating the number of seconds before checkpoints will be
 resumed by the stone."

	^ System checkpointStatus
]

{ #category : 'utilities' }
StLauncherGemStoneCheckpoints >> resumeCheckpoints [

"Resumes regular checkpoints if they were previously suspended by
 the System suspendCheckpointsForMinutes: method.
 
 Requires the SystemControl privilege.

 Returns the previous checkpoint state.  Returns true if checkpoints
 were suspended or false if checkpoints were not suspended."

	^ System resumeCheckpoints
]

{ #category : 'utilities' }
StLauncherGemStoneCheckpoints >> startCheckpointSync [
"Starts a synchronous checkpoint.  If a checkpoint is already
 in progress, this method will not start another.  Instead, it
 will block until the current checkpoint completes.
 
 If successful, this method returns after the checkpoint has
 completed.  To start a new checkpoint and return before it
 completes, use the startCheckpointAsync method instead
 of this one.

 This method does not commit (or otherwise modify) the current
 transaction.

 Requires the SystemControl privilege.

 A result of true means a checkpoint was successfully finished.
 A result of false means a checkpoint could not be started.  This
 usually happens because checkpoints are suspended or no tranlog
 space is available, or the repository is in restore-from-log mode.
 It can also happen if more than one session
 calls this method at the same time."

	^ System startCheckpointSync
		ifFalse: [ 
			self
				error:
					'Could not start a checkpoint, see comment in this method for possible reasons for failure.' ].
]

{ #category : 'utilities' }
StLauncherGemStoneCheckpoints >> suspendCheckpointsForMinutes: anInt [
"Suspend all checkpoints for the given number of minutes or until the
 resumeCheckpoints method is executed, which ever occurs first.  anInt
 must be a positive SmallInteger.
 
 Requires the SystemControl privilege.

 It is safe to copy the repository extents for backup purposes while
 checkpoints are suspended.

 Checkpoint suspension is not supported in partial tranlog mode.  This
 method will always return false STN_TRAN_FULL_LOGGING is set to FALSE.  

 Certain operations which require checkpoints are not permitted while
 checkpoints are suspended, such as full backups.

 Calling this method while checkpoints are already suspended has
 the effect of changing the duration of the suspension.

 If a checkpoint is in progress when this method is called, the call
 will block until the current checkpoint completes, at which time
 checkpoints will be suspended.  If any session has made this
 call and is waiting for the current checkpoint to complete, calls
 to this method by other sessions will fail.

 Returns true if checkpoints were successfully suspended.  Returns
 false if checkpoints could not be suspended because the repository
 is in partial log mode or is in restore from backup or log mode."

	^ System suspendCheckpointsForMinutes: anInt
]
