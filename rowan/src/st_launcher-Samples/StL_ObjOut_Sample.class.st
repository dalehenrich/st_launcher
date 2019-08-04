Class {
	#name : 'StL_ObjOut_Sample',
	#superclass : 'Object',
	#instVars : [
		'name',
		'count'
	],
	#category : 'st_launcher-Samples'
}

{ #category : 'accessing' }
StL_ObjOut_Sample >> count [

	^ count
]

{ #category : 'accessing' }
StL_ObjOut_Sample >> count: anInteger [

	count := anInteger
]

{ #category : 'accessing' }
StL_ObjOut_Sample >> name [

	^ name
]

{ #category : 'accessing' }
StL_ObjOut_Sample >> name: aString [

	name := aString
]

{ #category : 'formatting' }
StL_ObjOut_Sample >> printString [

	^ self name
]
