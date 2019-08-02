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

	(args includes: '-') 
		ifTrue: [ "read an object from stdin" ].
	^ resultObject ifNil: [ { 7 } ]
]

{ #category : 'options' }
StL_ObjOut >> scriptMethodOptions [
	^ {
			#('help' $h  #none #usage).
	}
]

{ #category : 'script options' }
StL_ObjOut >> scriptOptions [
	"specify the command line options"
	^ {
			#('help' $h #none).
			#('info' nil #none).
	}
]

{ #category : 'usage' }
StL_ObjOut >> usage: scriptName shortDescription: shortDescription description: description [
	| dashes |
	dashes := '----------------------------------------------------
'.
  self stdout nextPutAll: dashes,
		(self manPageClass
          fromString:
'NAME
	', scriptName, ' - ', shortDescription, '.

SYNOPSIS
  ', scriptName, ' [ [ imageName ] [-H] [-D] [-V] [st vm args] -- ]  <script options>
----------
  ', scriptName, ' [ -h | --help ] [ --info ]

DESCRIPTION
	', description, '

EXAMPLES
	', scriptName, ' -h
	', scriptName, ' --help

	', scriptName, '
') printString, dashes
]
