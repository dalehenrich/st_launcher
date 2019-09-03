#!/usr/local/bin/smalltalk/gemstone/st_launcher
"
This script creates a bar chart by reading data points from objIn. The bar
	chart creation algorithm is based upon RTGrapherExample >> 
	exampleMultiDataPoint.  The data is expected to be an array of arrays with at
	least one entry. The subArray is of the form:

		{ 'data point label' . <list-of-data-points> }

	where the <list-of-data-points> is one or more $. separated numbers. Each 
	subarray will produce a group of one or more bars sharing the same label. For 
	example the following will produce three clusters of three bar charts:

		{
			{ 'day 1' . 1209 . 34 . 45 } .
			{ 'day 2' . 1207 . 36 . 45 } .
			{ 'day 3' . 1209 . 34 . 46 } .
		}

	Currently the maximum number of supported data points is seven. The color of
	each bar in a cluster may be controlled by passing in a list of color names
	of the same length as the <list-of-data-points>:

	--colors=""green red yellow""
		The color names in the list will be converted to a selector and sent to
		the class Color to create the color.
"
Class {
	#name : 'RwsTestStatsBarChart',
	#superclass : 'AbstractProgram',
	#instVars : [
		'barChartData',
		'colors'
	],
	#category : 'RWSTestStats-Pharo-Scripts'
}

{ #category : 'private' }
RwsTestStatsBarChart >> _positionNames [
	^ #( first second third fourth fifth sixth seventh)
]

{ #category : 'accessing' }
RwsTestStatsBarChart >> barChartData [
	^ barChartData
]

{ #category : 'accessing' }
RwsTestStatsBarChart >> barChartData: anArray [
	barChartData := anArray
]

{ #category : 'accessing' }
RwsTestStatsBarChart >> colors [
	^ colors 
]

{ #category : 'accessing' }
RwsTestStatsBarChart >> colors: colorNamesString [
	
	colors := (colorNamesString findTokens: ' ') collect: [:colorName | 
		(self globalNamed: 'Color') perform: colorName asSymbol  ]
]

{ #category : 'main' }
RwsTestStatsBarChart >> main [
	"read objects from objIin"

	self objIn atEnd
		ifFalse: [
			barChartData := self objIn next ].
	self makeBarChart open.
	^ barChartData
]

{ #category : 'bar chart' }
RwsTestStatsBarChart >> makeBarChart [
	| b d |
	b := (self globalNamed: 'RTGrapher') new.

	d := (self globalNamed: 'RTHorizontalMultipleData') new.
	d barShape color: (self globalNamed: 'Color') blue.
	self colors ifNotNil: [ d colors: self colors ].
	d points: self barChartData.
	self barChartData first size > 7
		ifTrue: [ self error: 'Max number of data points is 7' ].
	2 to: self barChartData first size do: [:index |
		d addMetric: (self _positionNames at: index) ].

	"d barChartWithBarCenteredTitle: #first."
	d barChartWithBarTitle: #first rotation: -30.

	b add: d.
	^ b 
]

{ #category : 'options' }
RwsTestStatsBarChart >> scriptMethodOptions [
	^ super scriptMethodOptions, 
	{
			#('colors' nil #'required' #colors:).
	}
]
{ #category : 'usage' }
RwsTestStatsBarChart >> usageExamples: scriptName [
	^	scriptName, ' pharo-ui -- < barChartData.ston
	', scriptName, ' pharo-ui -- --colors="red green yellow" < barChartData.ston

	scriptProducingBarChartData | ', scriptName, ' pharo-ui -- --colors="red green yellow"
'
]
{ #category : 'usage' }
RwsTestStatsBarChart >> usageSynopsis: scriptName [
	^	(super usageSynopsis: scriptName), ' [ --colors=<list-of-color-names> ]'
]
