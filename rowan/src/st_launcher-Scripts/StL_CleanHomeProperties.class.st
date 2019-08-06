#!/usr/local/bin/smalltalk/gemstone/st_launcher
"
Rewrite st_launcher_home.ston and st_launcher_default.env making sure that any
	env vars in paths get resolved. Pharo does not resolve env vars in FileSytem
	paths.

	Mainly needed in order to run tests on travis-ci, since env vars are used to
	define location of checkout.
"
Class {
	#name : 'StL_CleanHomeProperties',
	#superclass : 'AbstractProgram',
	#category : 'st_launcher-Scripts'
}

{ #category : 'main' }
StLauncher_CleanHomeProperties >> main [

	| structureProperties imageMap pharoProductMap |
	structureProperties := self structureProperties.
	structureProperties homePath: structureProperties homePath.
	imageMap := structureProperties imageMap.
	imageMap keys do: [:aName |
		imageMap at: aName put: (imageMap at: aName) asFileReference pathString ].
	pharoProductMap := structureProperties productMap at: 'pharo' ifAbsent: [ Dictionary new ].
	pharoProductMap keys do: [:aName |
		pharoProductMap at: aName put: (pharoProductMap at: aName) asFileReference pathString ].
	structureProperties export.	"write structure properties and env file"
	^ true
]
