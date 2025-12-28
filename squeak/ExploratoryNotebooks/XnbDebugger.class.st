"
I track all steps during debugging.
"
Class {
	#name : #XnbDebugger,
	#superclass : #Debugger,
	#category : #'ExploratoryNotebooks-Tools',
	#'squeak_changestamp' : 'ct 12/28/2025 02:02'
}

{
	#category : #'as yet unclassified',
	#'squeak_changestamp' : 'ct 12/2/2025 00:34'
}
XnbDebugger class >> openOnCue: invocationCue xnbTrackingContext: aXnbTrackingContext [

	^ (self onProcess: invocationCue process context: invocationCue context)
		exception: invocationCue exception;
		xnbTrackingContext: aXnbTrackingContext;
		openWithLabel: invocationCue label
		contents: invocationCue contents
		fullView: invocationCue fullView;
		yourself
]

{
	#category : #'private - stepping',
	#'squeak_changestamp' : 'ct 12/2/2025 01:16'
}
XnbDebugger >> basicDoStep [

	| result |
	result := super basicDoStep.
	
	self xnbTrackingContext ifNotNil: [:trackingContext |
		self recordStep: #stepOver].
	
	^ result
]

{
	#category : #'private - stepping',
	#'squeak_changestamp' : 'ct 12/2/2025 01:16'
}
XnbDebugger >> basicSend [

	| result |
	result := super basicSend.
	
	self xnbTrackingContext ifNotNil: [:trackingContext |
		self recordStep: #stepInto].
	
	^ result
]

{
	#category : #'private - stepping',
	#'squeak_changestamp' : 'ct 12/2/2025 01:15'
}
XnbDebugger >> basicStepIntoBlock [

	| result |
	result := super basicStepIntoBlock.
	
	self xnbTrackingContext ifNotNil: [:trackingContext |
		self recordStep: #stepThrough].
	
	^ result
]

{
	#category : #private,
	#'squeak_changestamp' : 'ct 12/2/2025 00:45'
}
XnbDebugger >> contextStackIndex: anInteger oldContextWas: oldContext [

	super contextStackIndex: anInteger oldContextWas: oldContext .
	
	self updateInspectorTrackingContexts.
]

{
	#category : #'initialize-release',
	#'squeak_changestamp' : 'ct 12/2/2025 00:45'
}
XnbDebugger >> initializeFull [

	super initializeFull.
	
	self updateInspectorTrackingContexts.
]

{
	#category : #accessing,
	#'squeak_changestamp' : 'ct 11/28/2025 17:59'
}
XnbDebugger >> labelString [

	^ super labelString ifNil: ['Debugger']
]

{
	#category : #private,
	#'squeak_changestamp' : 'ct 12/2/2025 01:17'
}
XnbDebugger >> recordStep: step [

	self xnbTrackingContext:
		((XnbTrackingContext expression: 'self ' , step)
			receiverContext: self xnbTrackingContext;
			yourself).
]

{
	#category : #'stepping convenience',
	#'squeak_changestamp' : 'ct 11/25/2025 22:44'
}
XnbDebugger >> stepInto: selector [

	self stepThroughUntil: [:ctx | ctx xnbWillSend: selector]; stepInto.
]

{
	#category : #'stepping convenience',
	#'squeak_changestamp' : 'ct 11/25/2025 22:47'
}
XnbDebugger >> stepIntoUntil: aBlock [

	[aBlock value: self interruptedProcess suspendedContext] whileFalse: [self stepInto].
]

{
	#category : #'stepping convenience',
	#'squeak_changestamp' : 'ct 11/25/2025 22:42'
}
XnbDebugger >> stepThroughUntil: aBlock [

	[aBlock value: self interruptedProcess suspendedContext] whileFalse: [self stepThrough].
]

{
	#category : #private,
	#'squeak_changestamp' : 'ct 12/2/2025 01:08'
}
XnbDebugger >> updateInspectorTrackingContexts [

	| contextContext |
	self hasContextSelected ifFalse:
		[contextVariablesInspector xnbTrackingContext: self xnbTrackingContext.
		receiverInspector xnbTrackingContext: nil "self exception".
		^ self].
	
	contextContext := (XnbTrackingContext expression: ('(self interruptedContext stackOfSize: {1}) last' format: {self interruptedProcess suspendedContext contextStack indexOf: self selectedContext}))
		receiverContext: self xnbTrackingContext;
		yourself.
	contextVariablesInspector xnbTrackingContext: contextContext.
	receiverInspector xnbTrackingContext:
		((XnbTrackingContext expression: 'self receiver')
			receiverContext: contextContext;
			yourself).
]

{
	#category : #'self-updating',
	#'squeak_changestamp' : 'ct 12/2/2025 00:45'
}
XnbDebugger >> updateInspectors [

	super updateInspectors.
	
	self updateInspectorTrackingContexts.
]

{
	#category : #recording,
	#'squeak_changestamp' : 'ct 12/2/2025 00:57'
}
XnbDebugger >> xnbAddToNotebook [

	XnbTracker recordTool: self.
]

{
	#category : #recording,
	#'squeak_changestamp' : 'ct 12/2/2025 01:06'
}
XnbDebugger >> xnbToolCodeFor: variableName [

	^ variableName
]
