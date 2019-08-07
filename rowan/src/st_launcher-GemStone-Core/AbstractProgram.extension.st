Extension { #name : 'AbstractProgram' }

{ #category : '*st_launcher-gemstone-core' }
AbstractProgram >> about [

	| reportDict |
	reportDict := Dictionary new
			at: 'gemVersionReport' put: System gemVersionReport;
			at: 'isSolo' put: GsSession isSolo;
			at: 'userId' put: System myUserProfile userId;
			at: 'cacheName' put: ((System gemCacheStatisticsForSessionId: System session) at: 1);
			yourself.
	GsSession isSolo
		ifFalse: [ 
			reportDict
				at: 'stoneVersionReport' put: System stoneVersionReport;
				yourself ].
	^ reportDict
]

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
