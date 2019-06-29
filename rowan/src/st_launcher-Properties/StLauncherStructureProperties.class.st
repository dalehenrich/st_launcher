Class {
	#name : 'StLauncherStructureProperties',
	#superclass : 'StLauncherProperties',
	#instVars : [
		'rootPath'
	],
	#category : 'st_launcher-Properties'
}

{ #category : 'accessing' }
StLauncherStructureProperties >> gemstone [

	^ self platforms / 'gemstone'
]

{ #category : 'accessing' }
StLauncherStructureProperties >> images [

	^ self rootPath asFileReference / 'images'
]

{ #category : 'accessing' }
StLauncherStructureProperties >> platforms [

	^ self rootPath asFileReference / 'platforms'
]

{ #category : 'accessing' }
StLauncherStructureProperties >> rootPath [

	^ rootPath
]

{ #category : 'accessing' }
StLauncherStructureProperties >> rootPath: aString [ 

	rootPath := aString
]
