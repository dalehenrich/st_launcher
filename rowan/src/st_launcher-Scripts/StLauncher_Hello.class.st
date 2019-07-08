#!/usr/local/bin/smalltalk/gemstone/stash
"
Hello world smalltalk script
"
Class {
	#name : 'StLauncher_Hello',
	#superclass : 'StashScript',
	#category : 'st_launcher-Scripts'
}

{ #category : 'script execution' }
StLauncher_Hello >> executeScript [

	opts
		at: 'help'
    ifAbsent: [
			self stdout: 'hello world'; lf
		] 
    ifPresent: [ ^ self usage ]
]

{ #category : 'script execution' }
StLauncher_Hello >> scriptOptions [
	^ {
			#('help' $h #'none').
	}
]

{ #category : 'usage' }
StLauncher_Hello >> usage [
	| dashes |
	dashes := '----------------------------------------------------
'.
  GsFile stdout nextPutAll: dashes,
		(self manPageClass
          fromString:
'NAME
	hello.st - hello world.

SYNOPSIS
  hello.st [--help]

DESCRIPTION

	Hello world for Samlltalk.

EXAMPLES
	./hello.st --help

	./hello.st
') printString, dashes
]
