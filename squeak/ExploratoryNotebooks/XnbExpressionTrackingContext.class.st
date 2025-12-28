Class {
	#name : #XnbExpressionTrackingContext,
	#superclass : #XnbTrackingContext,
	#instVars : [
		'expression'
	],
	#category : #'ExploratoryNotebooks-Tracking'
}

{
	#category : #'instance creation',
	#'squeak_changestamp' : 'ct 12/1/2025 20:30'
}
XnbExpressionTrackingContext class >> expression: aStringOrText [

	^ self new
		expression: aStringOrText;
		yourself
]

{
	#category : #accessing,
	#'squeak_changestamp' : 'ct 12/1/2025 20:30'
}
XnbExpressionTrackingContext >> expression [

	^ expression
]

{
	#category : #accessing,
	#'squeak_changestamp' : 'ct 12/1/2025 20:30'
}
XnbExpressionTrackingContext >> expression: aStringOrText [

	expression := aStringOrText.
]

{
	#category : #accessing,
	#'squeak_changestamp' : 'ct 12/28/2025 02:41'
}
XnbExpressionTrackingContext >> expressionForReplay [

	^ self expression
]

{
	#category : #printing,
	#'squeak_changestamp' : 'ct 12/1/2025 20:48'
}
XnbExpressionTrackingContext >> printOn: aStream [

	aStream
		print: self species;
		space;
		nextPutAll: #expression:;
		space;
		print: (self expression ifNotNil: [:exp | exp asString]).
	self receiverContext ifNotNil: [:receiver |
		aStream
			space;
			nextPutAll: #receiver:;
			space;
			nextPut: $(;
			print: receiver;
			nextPut: $)].
]
