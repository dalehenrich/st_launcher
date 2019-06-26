#!/usr/local/bin/smalltalk/gemstone/stash
"
	Write `Hello World` to stdout and exit.
"
Class {
	#name : 'StLHello',
	#superclass : 'StashScript',
	#category : 'st_launcher-Scripts'
}

{ #category : 'script execution' }
StLHello >> executeScript [

	opts at: 'help' ifPresent: [ ^ self usage ].
	GsFile stdout nextPutAll: 'Hello World'; lf
]

{ #category : 'usage' }
StLHello >> usage [

	self usage: 'hello.st' description: 'Write `hello world` to stdout and exit.'
]
