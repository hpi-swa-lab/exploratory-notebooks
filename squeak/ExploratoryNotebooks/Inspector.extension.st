Extension { #name : #Inspector }

{
	#category : #'*ExploratoryNotebooks',
	#'squeak_changestamp' : 'ct 11/25/2025 22:20'
}
Inspector >> asXnbMorphFor: aToolFactory [

	| builder morph |
	builder := ToolBuilder default.
	morph := builder build: (self buildXnbPanelWith: builder).
	self changed: #expandRootsRequested.
	^ morph
]

{
	#category : #'*ExploratoryNotebooks',
	#'squeak_changestamp' : 'ct 11/25/2025 22:21'
}
Inspector >> buildXnbPanelWith: builder [

	| panelSpec |
	panelSpec := builder pluggablePanelSpec new
		model: self;
		children: OrderedCollection new;
		wantsResizeHandles: true;
		yourself.
	^ self buildWindow: panelSpec with: builder specs: {
		(0@0 corner: 0.3@1)
			-> [self buildMultiSelectFieldListWith: builder].
		(0.3@0.0 corner: 1@1)
			-> [self buildValuePaneWith: builder].	}
]

{
	#category : #'*ExploratoryNotebooks-menu - commands-override',
	#'squeak_changestamp' : 'ct 12/28/2025 22:23'
}
Inspector >> exploreSelection [

	| xnbContext |
	self hasSelection ifFalse: [^ self changed: #flash].
	
	XnbTracker isTracking ifFalse:
		[^ ToolSet explore: self selectionOrObject].
	
	xnbContext := self typeOfSelection = #ellipsis
		ifTrue: [self xnbTrackingContext]
		ifFalse: [self xnbNewTrackingContextForEvaluating: (self xnbExpressionFor: self selectedField)].
	^ ToolSet
		explore: self selectionOrObject
		xnbTrackingContext: xnbContext
]

{
	#category : #'*ExploratoryNotebooks-menu - commands-override',
	#'squeak_changestamp' : 'ct 12/2/2025 01:21'
}
Inspector >> inspectSelection [
	"Create and schedule an Inspector on the receiver's model's currently selected object."

	| xnbContext |
	self hasSelection ifFalse: [^ self changed: #flash].
	
	XnbTracker isTracking ifFalse:
		[^ ToolSet inspect: self selectionOrObject].
	
	xnbContext := self typeOfSelection = #ellipsis
		ifTrue: [self xnbTrackingContext]
		ifFalse: [self xnbNewTrackingContextForEvaluating: (self xnbExpressionFor: self selectedField)].
	^ ToolSet
		inspect: self selectionOrObject
		xnbTrackingContext: xnbContext
]

{
	#category : #'*ExploratoryNotebooks-menu - commands-override',
	#'squeak_changestamp' : 'ct 12/21/2025 05:06'
}
Inspector >> inspectSelectionBasic [
	"Bring up an inspector that focuses on the very basics of an object."

	| xnbContext |
	self hasSelection ifFalse: [^ self changed: #flash].
	
	XnbTracker isTracking ifFalse:
		[^ ToolSet basicInspect: self selectionOrObject].
	
	xnbContext := self typeOfSelection = #ellipsis
		ifTrue: [self xnbTrackingContext]
		ifFalse: [self xnbNewTrackingContextForEvaluating: (self xnbExpressionFor: self selectedField)].
	^ ToolSet
		basicInspect: self selectionOrObject
		xnbTrackingContext: xnbContext
]

{
	#category : #'*ExploratoryNotebooks-instance creation',
	#'squeak_changestamp' : 'ct 12/1/2025 20:31'
}
Inspector class >> on: anObject xnbTrackingContext: aXnbTrackingContext [

	^ (self on: anObject)
		xnbTrackingContext: aXnbTrackingContext;
		yourself
]

{
	#category : #'*ExploratoryNotebooks-instance creation',
	#'squeak_changestamp' : 'ct 12/1/2025 20:23'
}
Inspector class >> openOn: anObject xnbTrackingContext: aXnbTrackingContext [

	^ ToolBuilder open:
		(self on: anObject xnbTrackingContext: aXnbTrackingContext)
]

{
	#category : #'*ExploratoryNotebooks',
	#'squeak_changestamp' : 'ct 12/1/2025 21:13'
}
Inspector >> xnbAddToNotebook [

	XnbTracker recordTool: self.
]

{
	#category : #'*ExploratoryNotebooks-menu - commands',
	#'squeak_changestamp' : 'ct 12/2/2025 01:24'
}
Inspector >> xnbExpressionFor: field [

	^ self selectedField expressionWithReceiverName: #self
]

{
	#category : #'*ExploratoryNotebooks-tracking',
	#'squeak_changestamp' : 'ct 12/2/2025 01:40'
}
Inspector >> xnbNewTrackingContextForDebugging: expression [

	^ (super xnbNewTrackingContextForDebugging: expression)
		receiverContext: self xnbTrackingContext;
		yourself
]

{
	#category : #'*ExploratoryNotebooks-tracking',
	#'squeak_changestamp' : 'ct 12/1/2025 20:29'
}
Inspector >> xnbNewTrackingContextForEvaluating: expression [

	^ (super xnbNewTrackingContextForEvaluating: expression)
		receiverContext: self xnbTrackingContext;
		yourself
]

{
	#category : #'*ExploratoryNotebooks',
	#'squeak_changestamp' : 'ct 12/1/2025 23:46'
}
Inspector >> xnbSpawn [

	^ ToolSet
		inspect: self object
		xnbTrackingContext: self xnbTrackingContext
]

{
	#category : #'*ExploratoryNotebooks',
	#'squeak_changestamp' : 'ct 12/1/2025 23:59'
}
Inspector >> xnbTargetObject [

	^ self object
]

{
	#category : #'*ExploratoryNotebooks',
	#'squeak_changestamp' : 'ct 12/1/2025 23:26'
}
Inspector >> xnbToolCodeFor: variableName [

	^ 'self inspect: ' , variableName
]

{
	#category : #'*ExploratoryNotebooks-tracking',
	#'squeak_changestamp' : 'ct 12/1/2025 20:27'
}
Inspector >> xnbTrackingContext [

	^ XnbTracker trackingContextFor: self
]

{
	#category : #'*ExploratoryNotebooks-tracking',
	#'squeak_changestamp' : 'ct 12/1/2025 20:26'
}
Inspector >> xnbTrackingContext: aXnbTrackingContext [

	XnbTracker trackingContextFor: self put: aXnbTrackingContext.
]
