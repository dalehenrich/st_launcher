Class {
	#name : 'StLauncherScript',
	#superclass : 'AbstractLauncherProgram',
	#instVars : [
		'scriptOptionsMap',
		'orderedOptions'
	],
	#category : 'st_launcher-Stash'
}

{ #category : 'io' }
StLauncherScript class >> stderr [

	^StLauncherCommon stderr
]

{ #category : 'io' }
StLauncherScript class >> stdin [

	^StLauncherCommon stdin
]

{ #category : 'io' }
StLauncherScript class >> stdout [

	^StLauncherCommon stdout
]

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

{ #category : 'accessing' }
StLauncherScript >> orderedOptions [

	^ orderedOptions ifNil: [ orderedOptions := OrderedCollection new ]
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

{ #category : 'script utilities' }
StLauncherScript >> stderr [

	^ self class stderr
]

{ #category : 'script utilities' }
StLauncherScript >> stdin [

	^ self class stdin
]

{ #category : 'script utilities' }
StLauncherScript >> stdout [

	^ self class stdout
]
