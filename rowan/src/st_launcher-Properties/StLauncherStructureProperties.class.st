Class {
	#name : 'StLauncherStructureProperties',
	#superclass : 'StLauncherProperties',
	#instVars : [
		'homePath',
		'defaultImageName',
		'imageMap'
	],
	#category : 'st_launcher-Properties'
}

{ #category : 'instance creation' }
StLauncherStructureProperties class >> homePath: aString [

	^ self named: self defaultPropertyFilename homePath: aString
]

{ #category : 'instance creation' }
StLauncherStructureProperties class >> named: aName homePath: aString [

	^ (self new)
			name: aName;
			homePath: aString; 
			yourself
]

{ #category : 'image mgmnt' }
StLauncherStructureProperties >> addImageForProperties: imageProperties [

	self imageMap at: imageProperties name put: imageProperties imagePath
]

{ #category : 'accessing' }
StLauncherStructureProperties >> defaultImage [

	^ self images / self defaultImageName
]

{ #category : 'accessing' }
StLauncherStructureProperties >> defaultImageName [

	^ defaultImageName
]

{ #category : 'accessing' }
StLauncherStructureProperties >> defaultImageName: aString [

	defaultImageName := aString
]

{ #category : 'exporting' }
StLauncherStructureProperties >> export [

	self export: self defaultPropertiesDirectory / self name, 'ston'
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

	homePath := aString asFileReference resolve pathString "resolve any environment variables in path in current environment"
]

{ #category : 'accessing' }
StLauncherStructureProperties >> imageMap [

	^ imageMap ifNil: [ imageMap := Dictionary new ]
]

{ #category : 'accessing' }
StLauncherStructureProperties >> imageMap: aDictionary [

	imageMap := aDictionary
]

{ #category : 'accessing' }
StLauncherStructureProperties >> images [

	^ self home / 'images'
]

{ #category : 'accessing' }
StLauncherStructureProperties >> platforms [

	^ self home / 'platforms'
]