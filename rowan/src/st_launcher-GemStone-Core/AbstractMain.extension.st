Extension { #name : 'AbstractMain' }

{ #category : '*st_launcher-gemstone-core' }
AbstractMain >> objOut [

	^ objOut ifNil: [ 
		objOut := (STONWriter on: self stdout)
			prettyPrint: true; 
			yourself ]
]

{ #category : '*st_launcher-gemstone-core' }
AbstractMain >> systemInfo [

	^'GemStone/S ', (System gemVersionReport at: 'gsVersion')
]
