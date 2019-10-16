Class {
	#name : 'StLauncherScript',
	#superclass : 'AbstractLauncherProgram',
	#instVars : [
	],
	#category : 'st_launcher-Stash'
}

{ #category : 'script execution' }
StLauncherScript >> executeScript [

	opts
		at: 'help'
    ifAbsent: [
		self preExecute.
		self orderedOptions do: [:option |
			(opts includesKey: option)
				ifTrue: [
					| selector |
					selector := (self scriptOptionsMap at: option) at: 4.
					selector numArgs = 0
						ifTrue: [ self perform: selector asSymbol ]
						ifFalse: [ self perform: selector asSymbol with: (opts at: option) ] ] ].
		self postExecute ] 
    ifPresent: [ ^ self usage ]
]

