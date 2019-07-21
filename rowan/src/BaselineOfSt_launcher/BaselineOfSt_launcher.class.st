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
				baseline: 'Stash'
				with: [ spec
					repository: 'tonel:///home/dhenrich/rogue/_homes/rogue/_home/shared/repos/stash/rowan/src';
					loads: 'ALL' ].
			spec
				package: #'st_launcher-Core';
				package: #'st_launcher-Pharo-Core' with: [ spec requires: #('st_launcher-Core') ];
				package: #'st_launcher-Properties' with: [ spec requires: #('st_launcher-Core') ];
				package: #'st_launcher-GemStone-Platform' with: [ spec requires: #('st_launcher-Core') ];
				package: #'st_launcher-GemStone-Properties' with: [ spec requires: #('st_launcher-Properties') ];
				package: #'st_launcher-Pharo-Properties' with: [ spec requires: #('st_launcher-Core') ];
				package: #'st_launcher-Stash' with: [ spec requires: #('st_launcher-Core') ];
				package: #'st_launcher-Stash-Pharo' with: [ spec requires: #('st_launcher-Stash') ];
				yourself ].
	spec for: #scripts do: [
			spec
				package: #'st_launcher-Scripts' with: [ spec requires: #('st_launcher-Core') ];
				package: #'st_launcher-GemStone-Scripts' with: [ spec requires: #('Stash' 'st_launcher-Scripts') ];
				yourself ].

]

{ #category : #accessing }
BaselineOfSt_launcher >> projectClass [
    ^ MetacelloMCBaselineProject
]
