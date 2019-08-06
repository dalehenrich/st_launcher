Extension { #name : 'AbstractMain' }

{ #category : '*st_launcher-gemstone-core' }
AbstractMain >> globalNamed: aString [

	^ Rowan globalNamed: aString
]

{ #category : '*st_launcher-gemstone-core' }
AbstractMain >> objOut [

	^ objOut ifNil: [ 
		objOut := (STONWriter on: self stdout)
			prettyPrint: true; 
			yourself ]
]
