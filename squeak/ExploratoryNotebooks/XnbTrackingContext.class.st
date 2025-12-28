Class {
	#name : #XnbTrackingContext,
	#superclass : #Object,
	#instVars : [
		'receiverContext'
	],
	#category : #'ExploratoryNotebooks-Tracking'
}

{
	#category : #'instance creation',
	#'squeak_changestamp' : 'ct 12/28/2025 02:39'
}
XnbTrackingContext class >> expression: aStringOrText [

	^ XnbExpressionTrackingContext expression: aStringOrText
]

{
	#category : #'instance creation',
	#'squeak_changestamp' : 'ct 12/28/2025 02:40'
}
XnbTrackingContext class >> message: aMessage [

	^ XnbMessageTrackingContext message: aMessage
]

{
	#category : #accessing,
	#'squeak_changestamp' : 'ct 12/1/2025 23:07'
}
XnbTrackingContext >> contextChain [

	self receiverContext ifNil: [^ {self}].
	^ self receiverContext contextChain copyWith: self
]

{
	#category : #accessing,
	#'squeak_changestamp' : 'ct 12/28/2025 02:41'
}
XnbTrackingContext >> expressionForReplay [

	^ self subclassResponsibility
]

{
	#category : #accessing,
	#'squeak_changestamp' : 'ct 12/1/2025 20:30'
}
XnbTrackingContext >> receiverContext [

	^ receiverContext
]

{
	#category : #accessing,
	#'squeak_changestamp' : 'ct 12/1/2025 20:30'
}
XnbTrackingContext >> receiverContext: aTrackingContext [

	receiverContext := aTrackingContext.
]
