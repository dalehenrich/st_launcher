Class {
	#name : 'StLauncherProductProperties',
	#superclass : 'StLauncherProperties',
	#instVars : [
		'productName',
		'productVersionString',
		'structureProperties'
	],
	#category : 'st_launcher-Properties'
}

{ #category : 'accessing' }
StLauncherProductProperties class >> defaultPropertyFilename [

	^ 'productProperties.ston'
]

{ #category : 'instance creation' }
StLauncherProductProperties class >> new [

	^ self basicNew
		initialize;
		yourself
]

{ #category : 'instance creation' }
StLauncherProductProperties class >> productName: productNameString version: productVersionString [

	^ self new
		productName: productNameString;
		productVersionString: productVersionString;
		yourself
]

{ #category : 'instance creation' }
StLauncherProductProperties class >> version: productVersionString [

	^ self new
		productVersionString: productVersionString;
		yourself
]

{ #category : 'actions' }
StLauncherProductProperties >> createStandardStructure [
	"create standard directory structure on disk"
]

{ #category : 'accessing' }
StLauncherProductProperties >> defaultPropertiesDirectory [

	^ self structureProperties platforms / self platformName
]

{ #category : 'accessing' }
StLauncherProductProperties >> downloadFilename [

	self subclassResponsibility: #downloadFilename
]

{ #category : 'accessing' }
StLauncherProductProperties >> downloads [

	^ self structureProperties  platforms / self platformName / 'downloads'
]

{ #category : 'ston' }
StLauncherProductProperties >> excludedInstVarNames [

	^ super excludedInstVarNames , #( structureProperties )
]

{ #category : 'exporting' }
StLauncherProductProperties >> export [

	self export: self defaultPropertiesDirectory / self defaultPropertyFilename
]

{ #category : 'exporting' }
StLauncherProductProperties >> exportToStream: aStream [

	"lazily initialize any of the fields that haven't already been set, that need to be set"

	self 
		productName;
		downloadFilename;
		yourself.
	super exportToStream: aStream
]

{ #category : 'initialize' }
StLauncherProductProperties >> initialize [
	"noop"
]

{ #category : 'accessing' }
StLauncherProductProperties >> productFilename [

	self subclassResponsibility: #productFilename
]

{ #category : 'accessing' }
StLauncherProductProperties >> productName [

	^ productName ifNil: [ productName := self productVersionNameFor: self productVersionString ]
]

{ #category : 'accessing' }
StLauncherProductProperties >> productName: aString [ 

	productName := aString
]

{ #category : 'accessing' }
StLauncherProductProperties >> products [

	^ self structureProperties  platforms / self platformName / 'products'
]

{ #category : 'accessing' }
StLauncherProductProperties >> productVersionNameFor: aVersionString [

	self subclassResponsibility: #productVersionNameFor:
]

{ #category : 'accessing' }
StLauncherProductProperties >> productVersionString [

	^ productVersionString
]

{ #category : 'accessing' }
StLauncherProductProperties >> productVersionString: aString [ 

	productVersionString := aString
]

{ #category : 'accessing' }
StLauncherProductProperties >> structureProperties [

	^ structureProperties ifNil: [ structureProperties := super structureProperties ]
]
