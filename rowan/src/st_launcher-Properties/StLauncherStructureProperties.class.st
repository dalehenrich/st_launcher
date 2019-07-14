Class {
	#name : 'StLauncherStructureProperties',
	#superclass : 'StLauncherProperties',
	#instVars : [
		'homePath',
		'defaultImageName',
		'imageMap',
		'productMap'
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

{ #category : 'image management' }
StLauncherStructureProperties >> addImageForProperties: imageProperties [

	self imageMap at: imageProperties name put: imageProperties imagePath
]

{ #category : 'product management' }
StLauncherStructureProperties >> addProductProperties: productProperties [

	self addProductProperties: productProperties for: productProperties platformName
]

{ #category : 'product management' }
StLauncherStructureProperties >> addProductProperties: productProperties for: platformName [

	(self productMap at: platformName ifAbsentPut: [ Dictionary new ])
		at: productProperties name
		put: productProperties
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

	| defaultEnvFile |
	self export: self defaultPropertiesDirectory / self name, 'ston'.
	defaultEnvFile := self defaultPropertiesDirectory / 'st_launcher_default.env'.
	self 
		propertiesForImageNamed: self defaultImageName 
		ifPresent: [:defaultImageProperties |
			defaultEnvFile
				writeStreamDo: [:stream |
					stream
						nextPutAll: 'export ST_LAUNCHER_DEFAULT_PLATFORM=', defaultImageProperties platformName;
						lf;
						nextPutAll: 'export ST_LAUNCHER_DEFAULT_IMAGE_NAME=', defaultImageProperties name;
						lf;
						nextPutAll: 'export ST_LAUNCHER_DEFAULT_IMAGE_PATH=', defaultImageProperties imagePath;
						lf;
						nextPutAll: 'export ST_LAUNCHER_DEFAULT_PRODUCT_PATH="', defaultImageProperties productPath, '"';
						lf;
						nextPutAll: 'export ST_LAUNCHER_DEFAULT_SNAPSHOT_PATH="', defaultImageProperties soloSnapshot, '"';
						lf;
						yourself ] ]
		ifAbsent: [ 
			"no default image present, so we can't execute scripts, until it reappears"
			defaultEnvFile deleteIfAbsent: [ "not there, so we're good" ] ].
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

{ #category : 'image management' }
StLauncherStructureProperties >> imageNamed: aString ifAbsent: absentBlock [

	^ self imageNamed: aString ifPresent: [:imagePath | imagePath ] ifAbsent: absentBlock
]

{ #category : 'image management' }
StLauncherStructureProperties >> imageNamed: aString ifPresent: presentBlock ifAbsent: absentBlock [

	| imagePropertiesPath |
	imagePropertiesPath := self imageMap at: aString ifAbsent: [ ^ absentBlock value ].
	^ presentBlock cull: imagePropertiesPath
]

{ #category : 'accessing' }
StLauncherStructureProperties >> images [

	^ self home / 'images'
]

{ #category : 'accessing' }
StLauncherStructureProperties >> platforms [

	^ self home / 'platforms'
]

{ #category : 'accessing' }
StLauncherStructureProperties >> productMap [

	^ productMap ifNil: [ productMap := Dictionary new ]
]

{ #category : 'accessing' }
StLauncherStructureProperties >> productMap: aDictionary [

	productMap := aDictionary
]

{ #category : 'image management' }
StLauncherStructureProperties >> propertiesForImageNamed: aString [

	^ self propertiesForImageNamed: aString ifAbsent: [ self error: 'No image found for ', aString printString, '.' ]
]

{ #category : 'image management' }
StLauncherStructureProperties >> propertiesForImageNamed: aString ifAbsent: absentBlock [

	^ self propertiesForImageNamed: aString ifPresent: [:imageProperties | imageProperties ] ifAbsent: absentBlock
]

{ #category : 'image management' }
StLauncherStructureProperties >> propertiesForImageNamed: aString ifPresent: presentBlock ifAbsent: absentBlock [

	| imagePath imagePropertiesPath imageProperties |
	imagePath := self imageNamed: aString ifAbsent: absentBlock.
	imagePropertiesPath := imagePath asFileReference / StLauncherImageProperties defaultPropertyFilename.
	imagePropertiesPath exists 
		ifFalse: [ 
			"no file no properties"
			^ absentBlock value ].
	imageProperties := StLauncherProperties propertyFile: imagePropertiesPath.
	^ presentBlock cull: imageProperties
]
