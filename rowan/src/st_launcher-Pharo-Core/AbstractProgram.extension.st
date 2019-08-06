Extension { #name : #AbstractProgram }

{ #category : '*st_launcher-pharo-core' }
AbstractProgram >> globalNamed: aString [

	^ Smalltalk at: aString asSymbol
]

{ #category : #'*st_launcher-Pharo-Core' }
AbstractProgram >> objOut [

	^ objOut ifNil: [ 
		objOut := (STONWriter on: self stdout)
			prettyPrint: true; 
			newLine: String lf;
			yourself ]
]
