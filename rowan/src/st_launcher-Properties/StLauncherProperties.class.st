Class {
	#name : 'StLauncherProperties',
	#superclass : 'StLauncherCommon',
	#instVars : [
		'name',
		'structureProperties'
	],
	#category : 'st_launcher-Properties'
}

{ #category : 'accessing' }
StLauncherProperties class >> defaultPropertiesDirectory [

	^ '$HOME' asFileReference / '.config' / 'st_launcher'
]

{ #category : 'instance creation' }
StLauncherProperties class >> defaultPropertyFile [

	^ self propertyFileNamed: self defaultPropertyFilename
]

{ #category : 'accessing' }
StLauncherProperties class >> defaultPropertyFilename [

	^ 'st_launcher_home'
]

{ #category : 'accessing' }
StLauncherProperties class >> platformName [

	self subclassResponsibility: #platformName
]

{ #category : 'instance creation' }
StLauncherProperties class >> propertyFile: aFilePath [

	aFilePath asFileReference readStreamDo: [:fileStream | 
		| stream |
		stream := ZnBufferedReadStream on: fileStream. "hack for now"
	^ STON fromStream: stream ]
]

{ #category : 'instance creation' }
StLauncherProperties class >> propertyFileNamed: aName [

	^ self propertyFile:  self defaultPropertiesDirectory / aName, 'ston'
]

{ #category : 'accessing' }
StLauncherProperties >> defaultPropertiesDirectory [

	^ self class defaultPropertiesDirectory
]

{ #category : 'accessing' }
StLauncherProperties >> defaultPropertyFilename [

	^ self class defaultPropertyFilename
]

{ #category : 'ston' }
StLauncherProperties >> excludedInstVarNames [

	^ #( structureProperties )
]

{ #category : 'exporting' }
StLauncherProperties >> export [

	self subclassResponsibility: #export
]

{ #category : 'exporting' }
StLauncherProperties >> export: aFileReferenceOrPath [
	| file |
	file := aFileReferenceOrPath asFileReference.
	file parent exists ifFalse: [ file parent ensureCreateDirectory ].
	file writeStreamDo: [:stream | STON put: self onStreamPretty: stream ]
]

{ #category : 'exporting' }
StLauncherProperties >> exportToStream: aStream [

	STON put: self onStreamPretty: aStream
]

{ #category : 'accessing' }
StLauncherProperties >> name [

	^ name
]

{ #category : 'accessing' }
StLauncherProperties >> name: aString [

	name := aString
]

{ #category : 'accessing' }
StLauncherProperties >> platformName [

	^self class platformName
]

{ #category : 'ston' }
StLauncherProperties >> stonInstVarNames [
  | oc |
  oc := self class allInstVarNames asOrderedCollection.
  oc removeAll: self excludedInstVarNames.
  ^ oc asArray sort
]

{ #category : 'ston' }
StLauncherProperties >> stonOn: stonWriter [
  stonWriter
    writeObject: self
    streamMap: [ :dictionary | 
      self stonInstVarNames
        do: [ :each | 
			(self instVarAt: (self class allInstVarNames indexOf: each asSymbol))
				ifNotNil: [ :value | dictionary at: each asSymbol put: value ] ] ]
]

{ #category : 'accessing' }
StLauncherProperties >> structureProperties [

	^ structureProperties ifNil: [ structureProperties := super structureProperties ]
]
