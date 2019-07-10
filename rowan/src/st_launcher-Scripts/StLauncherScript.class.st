Class {
	#name : 'StLauncherScript',
	#superclass : 'StashScript',
	#instVars : [
		'scriptOptionsMap',
		'orderedOptions'
	],
	#category : 'st_launcher-Scripts'
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
					selector := self optionsMap at: option.
					selector numArgs = 0
						ifTrue: [ self perform: selector asSymbol ]
						ifFalse: [ self perform: selector asSymbol withArg: (opts at: option) ] ] ].
		self postExecute ] 
    ifPresent: [ ^ self usage ]
]

{ #category : 'accessing' }
StLauncherScript >> orderedOptions [

	^ orderedOptions ifNil: [ orderedOptions := {} ]
]

{ #category : 'script execution' }
StLauncherScript >> postExecute [
]

{ #category : 'script execution' }
StLauncherScript >> preExecute [
]

{ #category : 'options' }
StLauncherScript >> scriptMethodOptions [
	^ {
			#('help' $h  #none #usage).
	}
]

{ #category : 'script execution' }
StLauncherScript >> scriptOptions [

	| ar ordered |
	ar := self scriptMethodOptions.
	ordered := self orderedOptions.
	^ ar collect: [:argAr |
		self scriptOptionsMap at: (argAr at: 1) put: argAr.
		orderedOptions add: (argAr at: 1).
		argAr copyFrom: 1 to: 3 ].
]

{ #category : 'accessing' }
StLauncherScript >> scriptOptionsMap [

	^ scriptOptionsMap ifNil: [ scriptOptionsMap := Dictionary new ]
]
