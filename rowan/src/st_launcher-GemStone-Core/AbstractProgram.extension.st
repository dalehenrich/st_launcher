Extension { #name : 'AbstractProgram' }

{ #category : '*st_launcher-gemstone-core' }
AbstractProgram >> globalNamed: aString [

	^ Rowan globalNamed: aString
]

{ #category : '*st_launcher-gemstone-core' }
AbstractProgram >> objOut [

	^ objOut ifNil: [ 
		objOut := (STONWriter on: self stdout)
			prettyPrint: true; 
			yourself ]
]
