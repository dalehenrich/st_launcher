Class {
	#name : 'StLauncherGemStoneImageProperties',
	#superclass : 'StLauncherImageProperties',
	#instVars : [
		'gemstoneVersion'
	],
	#category : 'st_launcher-GemStone-Properties'
}

{ #category : 'instance creation' }
StLauncherGemStoneImageProperties class >> named: nameString version: gemstoneVersionString [

	^ self new
		name: nameString;
		gemStoneVersion: gemstoneVersionString;
		yourself
]

{ #category : 'accessing' }
StLauncherGemStoneImageProperties class >> platformName [

	^ 'gemstone'
]

{ #category : 'accessing' }
StLauncherGemStoneImageProperties >> gemstoneVersion [

	^ gemstoneVersion
]

{ #category : 'accessing' }
StLauncherGemStoneImageProperties >> gemstoneVersion: aGemStoneVersionString [

	gemstoneVersion := aGemStoneVersionString
]

{ #category : 'accessing' }
StLauncherGemStoneImageProperties >> version [

	^ RwGemStoneVersionNumber fromString: self gemstoneVersion
]
