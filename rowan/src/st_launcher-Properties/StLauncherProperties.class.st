Class {
	#name : 'StLauncherProperties',
	#superclass : 'StLauncherCommon',
	#instVars : [
		'name'
	],
	#category : 'st_launcher-Properties'
}

{ #category : 'accessing' }
StLauncherProperties class >> defaultPropertiesDirectory [

	^ '$HOME' asFileReference / '.st_launcher'
]

{ #category : 'instance creation' }
StLauncherProperties class >> defaultPropertyFile [

	^ self propertyFileNamed: self defaultPropertyFilename
]

{ #category : 'accessing' }
StLauncherProperties class >> defaultPropertyFilename [

	^ 'st_launcher_home'
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

{ #category : 'ston' }
StLauncherProperties >> excludedInstVarNames [

	^ #()
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

{ #category : 'accessing' }
StLauncherProperties >> name [

	^ name
]

{ #category : 'accessing' }
StLauncherProperties >> name: aString [

	name := aString
]

{ #category : 'ston' }
StLauncherProperties >> stonInstVarNames [
  | oc |
  oc := self class allInstVarNames asOrderedCollection.
  oc removeAll: self excludedInstVarNames.
  ^ oc
]

{ #category : 'ston' }
StLauncherProperties >> stonOn: stonWriter [
  stonWriter
    writeObject: self
    streamMap: [ :dictionary | 
      self stonInstVarNames
        do: [ :each | 
			| value |
			value := self instVarAt: (self class allInstVarNames indexOf: each asSymbol).
			dictionary at: each asSymbol put: value ] ]
]

{ #category : 'ston' }
StLauncherProperties >> stonShouldWriteNilInstVars [
	"Return true if my instance variables that are nil should be written out, 
	false otherwise. Overwrite when necessary. By default, return false."
	
	^ true
]
