Class {
	#name : 'StLObjOutSample',
	#superclass : 'Object',
	#instVars : [
		'name',
		'count'
	],
	#category : 'st_launcher-Samples'
}

{ #category : 'accessing' }
StLObjOutSample >> count [

	^ count
]

{ #category : 'accessing' }
StLObjOutSample >> count: anInteger [

	count := anInteger
]

{ #category : 'accessing' }
StLObjOutSample >> name [

	^ name
]

{ #category : 'accessing' }
StLObjOutSample >> name: aString [

	name := aString
]

{ #category : 'formatting' }
StLObjOutSample >> printString [

	^ self name
]
