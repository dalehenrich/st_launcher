Class {
	#name : 'StLauncherGemStoneProductProperties',
	#superclass : 'StLauncherProductProperties',
	#instVars : [
		'ftpSiteFilename',
		'ftpSiteDirectoryname',
		'downloadFilename'
	],
	#category : 'st_launcher-GemStone-Properties'
}

{ #category : 'accessing' }
StLauncherGemStoneProductProperties class >> platformName [

	^ 'gemstone'
]

{ #category : 'accessing' }
StLauncherGemStoneProductProperties >> downloadFile [

	^ self downloads / self downloadFilename
]

{ #category : 'accessing' }
StLauncherGemStoneProductProperties >> downloadFilename [

	^ downloadFilename ifNil: [ 'not defined yet' ]
]

{ #category : 'accessing' }
StLauncherGemStoneProductProperties >> ftpSiteDirectoryname [

	^ ftpSiteDirectoryname ifNil: [ ftpSiteDirectoryname := self productVersionString ]
]

{ #category : 'accessing' }
StLauncherGemStoneProductProperties >> ftpSiteFilename [

	^ ftpSiteFilename ifNil: [ ftpSiteFilename := self productName ]
]

{ #category : 'accessing' }
StLauncherGemStoneProductProperties >> productVersionNameFor: aVersionString [

	^ 'GemStone64Bit', aVersionString, '-x86_64.Linux'
]

{ #category : 'accessing' }
StLauncherGemStoneProductProperties >> version [

	^ RwGemStoneVersionNumber fromString: self productVersionString
]
