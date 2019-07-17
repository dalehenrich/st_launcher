Extension { #name : 'FileDoesNotExistException' }

{ #category : '*st_launcher-gemstone-kernel' }
FileDoesNotExistException >> _description: subclassDetails [

	| msg |
	msg := messageText isNil
		ifTrue: [ fileName asString, (self readOnly ifTrue: [' (RO)'] ifFalse: ['']) ]
		ifFalse: [ messageText ].
	^ super _description: msg
]
