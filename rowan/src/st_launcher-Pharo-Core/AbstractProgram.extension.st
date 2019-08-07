Extension { #name : #AbstractProgram }

{ #category : '*st_launcher-gemstone-core' }
AbstractProgram >> about [

	| reportDict |
	reportDict := Dictionary new
		at: 'systemVersion' put: SystemVersion current dottedMajorMinorPatch;
		at: 'build' put: SystemVersion current asString;
		yourself.
^ reportDict
]

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
