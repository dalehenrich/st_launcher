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

{ #category : 'accessing' }
StLauncherProductProperties >> productName [

	^ productName ifNil: [ productName := 'GemStone64Bit', self productVersionString ]
]

{ #category : 'accessing' }
StLauncherProductProperties >> productName: aString [ 

	productName := aString
]

{ #category : 'accessing' }
StLauncherProductProperties >> productVersionString [

	^ productVersionString
]

{ #category : 'accessing' }
StLauncherProductProperties >> productVersionString: aString [ 

	productVersionString := aString
]
