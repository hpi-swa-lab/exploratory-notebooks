Class {
	#name : #XnbDebuggingTrackingContext,
	#superclass : #XnbExpressionTrackingContext,
	#instVars : [
		'steps'
	],
	#category : #'ExploratoryNotebooks-Tracking'
}

{
	#category : #accessing,
	#'squeak_changestamp' : 'ct 12/2/2025 01:04'
}
XnbDebuggingTrackingContext >> expressionForReplay [

	| code |
	code := '%WORKSPACE% debug: ' , ('(Process forBlock: [{1}])' format: {self expression}).
	self steps ifNotEmpty: [:steps |
		code := String streamContents: [:stream |
			stream
				nextPut: $(;
				nextPutAll: code;
				nextPut: $).
			steps
				do: [:step |
					stream
						space;
						nextPutAll: step]
				separatedBy:
					[stream nextPut: $;]]].
	^ code
]

{
	#category : #'initialize-release',
	#'squeak_changestamp' : 'ct 12/2/2025 00:55'
}
XnbDebuggingTrackingContext >> initialize [

	super initialize.
	
	self steps: OrderedCollection new.
]

{
	#category : #accessing,
	#'squeak_changestamp' : 'ct 12/2/2025 00:55'
}
XnbDebuggingTrackingContext >> steps [

	^ steps
]

{
	#category : #accessing,
	#'squeak_changestamp' : 'ct 12/2/2025 00:55'
}
XnbDebuggingTrackingContext >> steps: aSequenceableCollection [

	steps := aSequenceableCollection.
]
