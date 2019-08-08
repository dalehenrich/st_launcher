#!/usr/local/bin/smalltalk/gemstone/st_launcher
"
Provide detailed information about the image that this script is running in
	return a dictionary with fields for all sorts of interesting information 
	not recorded in image properties file (--imageProperties)
"
Class {
	#name : 'StL_About',
	#superclass : 'AbstractProgram',
	#category : 'st_launcher-Scripts'
}

{ #category : 'main' }
StL_About >> main [

	| dict |
	dict := self about.
	dict at: 'imageProperties' put: self imageProperties.
	^ dict
]
