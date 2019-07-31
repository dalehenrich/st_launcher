#!/usr/local/bin/smalltalk/gemstone/st_launcher
"
Hello world smalltalk script
"
Class {
	#name : 'StLauncher_Hello',
	#superclass : 'StLauncherScript',
	#category : 'st_launcher-Scripts'
}

{ #category : 'script execution' }
StLauncher_Hello >> postExecute [

	self stdout
		nextPutAll: 'hello world';
		lf;
		yourself
]

{ #category : 'usage' }
StLauncher_Hello >> usage [
	| dashes |
	dashes := '----------------------------------------------------
'.
  self stdout nextPutAll: dashes,
		(self manPageClass
          fromString:
'NAME
	hello.st - hello world.

SYNOPSIS
  hello.st [ imageName [-H] [-D] [-V] [st vm args] -- ]  [script args]

  hello.st [--help]

DESCRIPTION

	Hello world for Smalltalk.

EXAMPLES
	./hello.st --help

	./hello.st
') printString, dashes
]
