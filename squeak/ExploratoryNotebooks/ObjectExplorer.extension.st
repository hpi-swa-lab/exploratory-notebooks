Extension { #name : #ObjectExplorer }

{
	#category : #'*ExploratoryNotebooks',
	#'squeak_changestamp' : 'ct 11/25/2025 17:32'
}
ObjectExplorer >> asXnbMorphFor: aToolFactory [

	| builder morph |
	builder := ToolBuilder default.
	morph := builder build: (self buildTreeWith: builder).
	self changed: #expandRootsRequested.
	^ morph
]

{
	#category : #'*ExploratoryNotebooks',
	#'squeak_changestamp' : 'ct 12/1/2025 23:31'
}
ObjectExplorer >> xnbAddToNotebook [

	XnbTracker recordTool: self.
]

{
	#category : #'*ExploratoryNotebooks-tracking',
	#'squeak_changestamp' : 'ct 12/2/2025 01:40'
}
ObjectExplorer >> xnbNewTrackingContextForDebugging: expression [

	^ (super xnbNewTrackingContextForDebugging: expression)
		receiverContext: self xnbTrackingContext;
		yourself
]

{
	#category : #'*ExploratoryNotebooks-tracking',
	#'squeak_changestamp' : 'ct 12/1/2025 23:31'
}
ObjectExplorer >> xnbNewTrackingContextForEvaluating: expression [

	^ (super xnbNewTrackingContextForEvaluating: expression)
		receiverContext: self xnbTrackingContext;
		yourself
]

{
	#category : #'*ExploratoryNotebooks',
	#'squeak_changestamp' : 'ct 12/2/2025 00:01'
}
ObjectExplorer >> xnbSpawn [

	^ ToolSet
		explore: self rootObject
		xnbTrackingContext: self xnbTrackingContext
]

{
	#category : #'*ExploratoryNotebooks',
	#'squeak_changestamp' : 'ct 12/2/2025 00:00'
}
ObjectExplorer >> xnbTargetObject [

	^ self rootObject
]

{
	#category : #'*ExploratoryNotebooks',
	#'squeak_changestamp' : 'ct 12/1/2025 23:27'
}
ObjectExplorer >> xnbToolCodeFor: variableName [

	^ variableName
]

{
	#category : #'*ExploratoryNotebooks-tracking',
	#'squeak_changestamp' : 'ct 12/1/2025 23:31'
}
ObjectExplorer >> xnbTrackingContext [

	^ XnbTracker trackingContextFor: self
]

{
	#category : #'*ExploratoryNotebooks-tracking',
	#'squeak_changestamp' : 'ct 12/1/2025 23:31'
}
ObjectExplorer >> xnbTrackingContext: aXnbTrackingContext [

	XnbTracker trackingContextFor: self put: aXnbTrackingContext.
]
