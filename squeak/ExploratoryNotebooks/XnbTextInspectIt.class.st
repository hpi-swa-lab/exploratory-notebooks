"
I track inspection context when clicking on a print-it result.
"
Class {
	#name : #XnbTextInspectIt,
	#superclass : #TextInspectIt,
	#instVars : [
		'trackingContext'
	],
	#category : #'ExploratoryNotebooks-Tools',
	#'squeak_changestamp' : 'ct 12/28/2025 02:03'
}

{
	#category : #'instance creation',
	#'squeak_changestamp' : 'ct 12/21/2025 05:03'
}
XnbTextInspectIt class >> on: anObject xnbTrackingContext: aXnbTrackingContext [ 

	^ (self on: anObject)
		xnbTrackingContext: aXnbTrackingContext;
		yourself
]

{
	#category : #'mouse events',
	#'squeak_changestamp' : 'ct 12/21/2025 05:03'
}
XnbTextInspectIt >> actOnClickFor: anObject [
	"Note: evalString gets evaluated IN THE CONTEXT OF anObject
	 -- meaning that self and all instVars are accessible"
	Project current addDeferredUIMessage: [
		ToolSet inspect: "do not send #inspect because the result might be a proxy"
			(self target
				ifNil: [(Compiler evaluate: evalString for: anObject)]
				ifNotNil: [:object | object])
			xnbTrackingContext: self xnbTrackingContext ].
	^ true 
]

{
	#category : #accessing,
	#'squeak_changestamp' : 'ct 12/21/2025 05:02'
}
XnbTextInspectIt >> xnbTrackingContext [

	^ trackingContext
]

{
	#category : #accessing,
	#'squeak_changestamp' : 'ct 12/21/2025 05:02'
}
XnbTextInspectIt >> xnbTrackingContext: aXnbTrackingContext [

	trackingContext := aXnbTrackingContext.
]
