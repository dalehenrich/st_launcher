#!/usr/local/bin/smalltalk/gemstone/stash
"
	Write `Hello World` to stdout and exit.
"
Class {
	#name : 'StLauncher_Hello',
	#superclass : 'StashScript',
	#category : 'st_launcher-Scripts'
}

{ #category : 'script execution' }
StLauncher_Hello >> executeScript [

	opts at: 'help' ifPresent: [ ^ self usage ].
	GsFile stdout nextPutAll: 'Hello World'; lf
]

{ #category : 'usage' }
StLauncher_Hello >> usage [

	self usage: 'hello.st' description: 'Write `hello world` to stdout and exit.'
]
