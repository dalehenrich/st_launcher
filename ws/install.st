#!/usr/local/bin/smalltalk/gemstone/st_launcher
"
Install <your-project> into the named image. You have the option of installing
	using either Rowan or Metacello:

	--rowan[=<load-spec-file-name>]
		Use Rowan to install <your-project> into the named image. The 
		<load-spec-file-name> is located in the rowan/specs directory. If no 
		<load-spec-file-name> is specified, `Default.ston` will be used.

	--metacello=[<load-list>]
		Use Metacello to install <your-project> into the named image. The <load-list>
		is the list of packages/groups/proect that you want loaded. By default the 
		`default` group will be loaded.
"

Class {
	#name : 'WS_InstallTemplate',
	#superclass : 'AbstractProgram',
	#instVars : [
		'installMethod'
	],
	#category : 'st_launcher-Workspaces'
}


{ #category : 'main' }
WS_InstallTemplate >> main [
	"installation logic"
]

{ #category : 'options' }
WS_InstallTemplate >> scriptMethodOptions [
	^ super scriptMethodOptions, 
	{
			#('rowan' nil #optional #rowan: ).
			#('metacello' nil #optional #metacello: ).
	}
]

{ #category : 'usage' }
WS_InstallTemplate >> usageExamples: scriptName [
	^	scriptName, ' --rowan gs_350
	', scriptName, ' --rowan=example.ston gs_350
	', scriptName, ' --metacello pharo_70
	', scriptName, ' --metacello="Example Tests" pharo_70
'
]

{ #category : 'usage' }
WS_InstallTemplate >> usageSynopsis: scriptName [

	^	(super usageSynopsis: scriptName), ' /
		[ --rowan[=<spec-file-name>] | --metacello[=<load-list>] ] <image-name>
'
]
