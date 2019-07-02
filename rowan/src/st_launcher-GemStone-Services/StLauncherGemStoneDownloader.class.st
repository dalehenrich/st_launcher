Class {
	#name : 'StLauncherGemStoneDownloader',
	#superclass : 'StLauncherGemStoneSystem',
	#instVars : [
		'version',
		'safely',
		'targetDirectory',
		'structureProperties'
	],
	#category : 'st_launcher-GemStone-Services'
}

{ #category : 'instance creation' }
StLauncherGemStoneDownloader class >> downloadGemStoneVersion: versionString to: directoryReferenceOrPath [

	^ self downloadGemStoneVersion: versionString to: directoryReferenceOrPath safely: true
]

{ #category : 'instance creation' }
StLauncherGemStoneDownloader class >> downloadGemStoneVersion: versionString to: directoryReferenceOrPath safely: safely [

	^ self new downloadGemStoneVersion: versionString to: directoryReferenceOrPath safely: safely
]

{ #category : 'actions' }
StLauncherGemStoneDownloader >> downloadGemStoneVersion: versionString to: directoryReferenceOrPath safely: safelyBoolean [

	version := RwGemStoneVersionNumber fromString: versionString.
	targetDirectory := directoryReferenceOrPath asFileReference.
	safely := safelyBoolean
]

{ #category : 'accessing' }
StLauncherGemStoneDownloader >> ftpServerUrl [

	^ 'https://downloads.gemtalksystems.com'
]

{ #category : 'accessing' }
StLauncherGemStoneDownloader >> safely [

	^ safely
]

{ #category : 'accessing' }
StLauncherGemStoneDownloader >> structureProperties [

	^ structureProperties ifNil: [ structureProperties := super structureProperties ]
]

{ #category : 'accessing' }
StLauncherGemStoneDownloader >> targetDirectory [

	^ targetDirectory
]

{ #category : 'accessing' }
StLauncherGemStoneDownloader >> version [

	^ version
]
