Extension { #name : 'AbstractMain' }

{ #category : '*st_launcher-gemstone-core' }
AbstractMain >> systemInfo [

	^'GemStone/S ', (System gemVersionReport at: 'gsVersion')
]
