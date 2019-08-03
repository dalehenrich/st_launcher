Extension { #name : #StdioStream }

{ #category : #'*st_launcher-Pharo-Core' }
StdioStream >> next [
	"https://github.com/pharo-project/pharo/issues/4173"

	"Answer the next character from this file, or nil if at the end of the file."

	^ super next ifNotNil: [:byte | byte asCharacter ]
]

{ #category : #'*st_launcher-Pharo-Core' }
StdioStream >> next: n [
	"Return a string with the next n characters of the filestream in it."
	| readBuffer read startingAt |
	readBuffer := ByteArray new: n.
	startingAt := 1.
	peekBuffer ifNotNil: [ 
		readBuffer at: 1 put: peekBuffer asInteger.
		startingAt := startingAt + 1.
		peekBuffer := nil ].
	read := File read: handle into: readBuffer startingAt: startingAt count: n - startingAt + 1.
	^read = (n - startingAt + 1)
		ifTrue: [ readBuffer ]
		ifFalse: [ readBuffer copyFrom: 1 to: read ]
]

{ #category : #'*st_launcher-Pharo-Core' }
StdioStream >> peek [
	"https://github.com/pharo-project/pharo/issues/4173"

	"Answer the next element of the stream, but do not advance the stream pointer. 
	If the receiver is at the end, answer nil."

	self atEnd ifTrue: [ ^ nil ].
	peekBuffer ifNotNil: [ ^ peekBuffer asCharacter ].
	peekBuffer := self next.
	peekBuffer ifNotNil: [ ^ peekBuffer asCharacter ].
	^ peekBuffer
]

{ #category : #'*st_launcher-Pharo-Core' }
StdioStream >> peekFor: anObject [
	"https://github.com/pharo-project/pharo/issues/4173"

	"Answer false and do not move over the next element if it is not equal to 
	the argument, anObject, or if the receiver is at the end. Answer true 
	and increment the position for accessing elements, if the next element is 
	equal to anObject."

	self atEnd
		ifTrue: [ ^ false ].
	peekBuffer 
		ifNil: [ peekBuffer := self next ].	
	"peek for matching element"
	anObject = peekBuffer asCharacter
		ifTrue: [ 
			peekBuffer := nil.	"gobble it if found"
			^ true ].
	^ false
]

{ #category : #'*st_launcher-Pharo-Core' }
StdioStream >> tab [
	"https://github.com/pharo-project/pharo/issues/4169"

	^ self nextPutAll: String tab
]
