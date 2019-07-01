Class {
	#name : 'StLauncherProductProperties',
	#superclass : 'StLauncherProperties',
	#instVars : [
		'productName',
		'productVersionString'
	],
	#category : 'st_launcher-Properties'
}

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
StLauncherProductProperties >> downloads [

	^ self structureProperties  platforms / self platformName / 'downloads'
]

{ #category : 'initialize' }
StLauncherProductProperties >> initialize [
	"noop"
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
