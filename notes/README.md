Here's some example code for cleaning up cached full paths in Pharo [from Sean DeNigris](http://forum.world.st/more-fun-with-System-Local-directory-settings-tp5101824p5101851.html):
``` smalltalk
	| imageRoot repos |
	imageRoot := FileLocator home / 'Dynabook' / 'Working Images'.
	repos := IceLibgitRepository allSubInstances
		select: [ :e | 
			e location isNotNil
				and: [ (FileLocator imageDirectory contains: e location) not
						and: [ imageRoot contains: e location ] ] ].
	repos
		do: [ :e | 
			| oldPath newPath fixedLocation |
			oldPath := e location relativeTo: imageRoot.
			newPath := RelativePath withAll: oldPath segments allButFirst.
			fixedLocation := FileLocator imageDirectory withPath: newPath.
			e location: fixedLocation ]
```

### Roassal pie chart
```smalltalk
| b |
b := RTPieBuilder new.
b interaction popup.
b
	objects:
		(Array
			with: ('Dictionary' -> 10)
			with: ('Collection' -> 10)
			with: ('Set' -> 5)
			with: ('OrderedCollection' -> 1)).
b slice: #value.
b normalizer distinctColor.
b labeled.
^ b
```
