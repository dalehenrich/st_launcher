Class {
	#name : 'StLauncherStructureProperties',
	#superclass : 'StLauncherProperties',
	#instVars : [
		'homePath'
	],
	#category : 'st_launcher-Properties'
}

{ #category : 'instance creation' }
StLauncherStructureProperties class >> homePath: aString [

	^ self named: 'st_launcher_home' homePath: aString
]

{ #category : 'instance creation' }
StLauncherStructureProperties class >> named: aName homePath: aString [

	^ (self new)
			name: aName
			homePath: aString; 
			yourself
]

{ #category : 'exporting' }
StLauncherStructureProperties >> export [

	self export: '$HOME' asFileReference / '.st_launcher' / self name, 'ston'
]

{ #category : 'exporting' }
StLauncherStructureProperties >> export: aFileReferenceOrPath [

	| file |
	file := aFileReferenceOrPath asFileReference.
	file parent exists ifFalse: [ file parent ensureCreateDirectory ].
	file writeStreamDo: [:stream | STON put: self onStreamPretty: stream ]
]

{ #category : 'accessing' }
StLauncherStructureProperties >> home [

	^ self homePath asFileReference
]

{ #category : 'accessing' }
StLauncherStructureProperties >> homePath [

	^ homePath
]

{ #category : 'accessing' }
StLauncherStructureProperties >> homePath: aString [ 

	homePath := aString
]

{ #category : 'accessing' }
StLauncherStructureProperties >> images [

	^ self home / 'images'
]

{ #category : 'accessing' }
StLauncherStructureProperties >> platforms [

	^ self home / 'platforms'
]
