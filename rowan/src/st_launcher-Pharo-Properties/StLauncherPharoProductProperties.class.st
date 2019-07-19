Class {
	#name : 'StLauncherPharoProductProperties',
	#superclass : 'StLauncherProductProperties',
	#instVars : [
		'productPath',
		'pharoVersion'
	],
	#category : 'st_launcher-Pharo-Properties'
}

{ #category : 'install / uninstall' }
StLauncherPharoProductProperties class >> _deleteStructure [

	| launcherProperties |
	launcherProperties := StLauncherProperties defaultPropertyFile.

	(launcherProperties pharo) exists
		ifTrue: [ 
			(launcherProperties pharo) hasChildren
				ifTrue: [
		 			launcherProperties pharo children 
						do: [:productTree | 
							productTree isDirectory
								ifTrue: [
									(self permanentProductTrees includesValue: productTree basename)
										ifFalse: [
											productTree ensureDeleteAll.
											(launcherProperties productsMap
												at: self platformName) 
												removeKey: (self permanentProductTrees keyAtValue: productTree basename)
												ifAbsent: [] ] ] ] ] ].
	launcherProperties export.
]

{ #category : 'accessing' }
StLauncherPharoProductProperties class >> permanentProductTrees [

	^ Dictionary new
			at: '70-64' put: '70-64';
			yourself
]

{ #category : 'accessing' }
StLauncherPharoProductProperties class >> platformName [

	^ 'pharo'
]
