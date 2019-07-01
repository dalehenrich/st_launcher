Class {
	#name : 'StLauncherGemStoneProductProperties',
	#superclass : 'StLauncherProductProperties',
	#category : 'st_launcher-GemStone-Properties'
}

{ #category : 'accessing' }
StLauncherGemStoneProductProperties class >> platformName [

	^ 'gemstone'
]

{ #category : 'accessing' }
StLauncherGemStoneProductProperties >> version [

	^ RwGemStoneVersionNumber fromString: self productVersionString
]
