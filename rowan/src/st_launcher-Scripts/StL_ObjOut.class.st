#!/usr/local/bin/smalltalk/gemstone/st_launcher
"
Simple script to demonstrate use of objOut
"
Class {
	#name : 'StL_ObjOut',
	#superclass : 'AbstractMain',
	#instVars : [
		'resultObject'
	],
	#category : 'st_launcher-Scripts'
}

{ #category : 'script execution' }
StL_ObjOut >> main [

	^ self resultObject
]

{ #category : 'accessing' }
StL_ObjOut >> resultObject [

	^ resultObject	ifNil: [ 7 ]
]

{ #category : 'options' }
StL_ObjOut >> scriptMethodOptions [
	^ {
			#('help' $h  #none #usage).
	}
]
