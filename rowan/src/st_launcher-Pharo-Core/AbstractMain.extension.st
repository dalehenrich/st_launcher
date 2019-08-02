Extension { #name : #AbstractMain }

{ #category : #'*st_launcher-Pharo-Core' }
AbstractMain >> objOut [

	^ objOut ifNil: [ 
		objOut := (STONWriter on: self stdout)
			prettyPrint: true; 
			newLine: String lf;
			yourself ]
]
