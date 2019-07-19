Class {
	#name : #'BaselineOfSt_launcher',
	#superclass : #BaselineOf,
	#category : #'BaselineOfSt_launcher'
}

{ #category : #baselines }
BaselineOfSt_launcher >> baseline: spec [
	<baseline>
	spec
		for: #common
		do: [ 
			spec
				project: 'Stash'
				with: [ spec
					repository: 'tonel:////home/dhenrich/rogue/_homes/rogue/_home/shared/repos/stash/rowan/src';
					loads: 'ALL' ].
			spec
				package: #'st_launcher-Core';
				package: #'st_launcher-Properties' with: [ spec requires: #('st_launcher-Core') ];
				package: #'st_launcher-Scripts' with: [ spec requires: #('st_launcher-Core') ];
				package: #'st_launcher-GemStone-Core' with: [ spec requires: #('st_launcher-Core') ];
				package: #'st_launcher-GemStone-Properties' with: [ spec requires: #('st_launcher-Properties') ];
				package: #'st_launcher-GemStone-Scripts' with: [ spec requires: #('Stash' 'st_launcher-Scripts') ];
				package: #'st_launcher-Pharo-Properties' with: [ spec requires: #('st_launcher-Core') ];
				yourself ].

]

{ #category : #accessing }
BaselineOfSt_launcher >> projectClass [
    ^ MetacelloMCBaselineProject
]
