Class {
	#name : #XnbPlaceholderToolModel,
	#superclass : #Model,
	#instVars : [
		'labelString',
		'color'
	],
	#category : #ExploratoryNotebooks
}

{
	#category : #accessing,
	#'squeak_changestamp' : 'ct 12/27/2025 19:09'
}
XnbPlaceholderToolModel >> color [

	^ color
]

{
	#category : #accessing,
	#'squeak_changestamp' : 'ct 12/27/2025 19:09'
}
XnbPlaceholderToolModel >> color: aColor [

	color := aColor.
]

{
	#category : #accessing,
	#'squeak_changestamp' : 'ct 12/27/2025 19:08'
}
XnbPlaceholderToolModel >> labelString [

	^ labelString
]

{
	#category : #accessing,
	#'squeak_changestamp' : 'ct 12/27/2025 19:09'
}
XnbPlaceholderToolModel >> labelString: aString [

	labelString := aString.
]

{
	#category : #toolbuilder,
	#'squeak_changestamp' : 'ct 12/27/2025 19:09'
}
XnbPlaceholderToolModel >> windowColorToUse [

	^ self color
]
