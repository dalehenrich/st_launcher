Extension { #name : #AbstractProgram }

{ #category : '*st_launcher-pharo-core' }
AbstractProgram >> about [

	| reportDict |
	reportDict := Dictionary new
		at: 'systemVersion' put: SystemVersion current dottedMajorMinorPatch;
		at: 'build' put: SystemVersion current asString;
		at: 'image file' put: Smalltalk image imageFile;
		at: 'image version' put: Smalltalk vm imageVersionNmber;
		at: 'vm directory' put: Smalltalk vmDirectory;
		at: 'vm build' put: Smalltalk vm buildDate;
		at: 'vm version' put: Smalltalk vm version;
		yourself.
^ reportDict
]

{ #category : '*st_launcher-pharo-core' }
AbstractProgram >> evaluate: stExpression inContext: anObject [

	^ Smalltalk compiler
		source: stExpression;
		receiver: anObject;
		evaluate
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
