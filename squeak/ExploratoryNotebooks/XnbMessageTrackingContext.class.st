Class {
	#name : #XnbMessageTrackingContext,
	#superclass : #XnbTrackingContext,
	#instVars : [
		'message'
	],
	#category : #'ExploratoryNotebooks-Tracking'
}

{
	#category : #'instance creation',
	#'squeak_changestamp' : 'ct 12/28/2025 02:40'
}
XnbMessageTrackingContext class >> message: aMessage [

	^ self new
		message: aMessage;
		yourself
]

{
	#category : #accessing,
	#'squeak_changestamp' : 'ct 1/13/2026 20:37'
}
XnbMessageTrackingContext >> expressionForReplay [

	^ 'self ' , self message
]

{
	#category : #accessing,
	#'squeak_changestamp' : 'ct 12/28/2025 02:38'
}
XnbMessageTrackingContext >> message [

	^ message
]

{
	#category : #accessing,
	#'squeak_changestamp' : 'ct 12/28/2025 02:38'
}
XnbMessageTrackingContext >> message: aMessage [

	message := aMessage.
]

{
	#category : #printing,
	#'squeak_changestamp' : 'ct 12/28/2025 02:39'
}
XnbMessageTrackingContext >> printOn: aStream [

	aStream
		print: self species;
		space;
		nextPutAll: #message:;
		space;
		print: self message.
	self receiverContext ifNotNil: [:receiver |
		aStream
			space;
			nextPutAll: #receiver:;
			space;
			nextPut: $(;
			print: receiver;
			nextPut: $)].
]
