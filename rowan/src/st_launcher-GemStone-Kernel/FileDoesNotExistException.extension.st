Extension { #name : 'FileDoesNotExistException' }

{ #category : '*st_launcher-gemstone-kernel' }
FileDoesNotExistException >> _description: subclassDetails [

	self messageText ifNotNil:[ :s | ^ s ].
	super _description: subclassDetails
]
