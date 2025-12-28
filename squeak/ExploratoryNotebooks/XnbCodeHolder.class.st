"
I am a CodeHolder for browsing a method in a notebook.
"
Class {
	#name : #XnbCodeHolder,
	#superclass : #CodeHolder,
	#category : #'ExploratoryNotebooks-Tools',
	#'squeak_changestamp' : 'ct 12/28/2025 02:00'
}

{
	#category : #testing,
	#'squeak_changestamp' : 'ct 12/28/2025 01:58'
}
XnbCodeHolder >> isStaticXnbTool [

	^ true
]

{
	#category : #testing,
	#'squeak_changestamp' : 'ct 11/25/2025 21:16'
}
XnbCodeHolder >> wantsOptionalButtons [

	^ false
]
