Extension { #name : #Debugger }

{
	#category : #'*ExploratoryNotebooks',
	#'squeak_changestamp' : 'ct 11/25/2025 21:59'
}
Debugger >> asXnbMorphFor: aToolFactory [

	| builder morph |
	builder := ToolBuilder default.
	morph := builder build:
		(self isNotifier
			ifTrue: [self buildStackListWith: builder]
			ifFalse: [self buildXnbFullPanelWith: builder]).
	^ morph
]

{
	#category : #'*ExploratoryNotebooks-toolbuilder-pseudo-override',
	#'squeak_changestamp' : 'ct 1/8/2026 03:42'
}
Debugger >> buildActualCodePaneWith: builder [

	self flag: #moveUpstream.
	^ builder pluggableCodePaneSpec new
		model: self;
		getText: #contents; 
		setText: #contents:notifying:; 
		selection: #contentsSelection; 
		menu: #codePaneMenu:shifted:;
		yourself
]

{
	#category : #'*ExploratoryNotebooks',
	#'squeak_changestamp' : 'ct 11/25/2025 21:57'
}
Debugger >> buildXnbFullPanelWith: builder [

	| listSpec panel textSpec |
	panel := builder pluggablePanelSpec new
		model: self;
		children: OrderedCollection new;
		wantsResizeHandles: true;
		yourself.
	
	listSpec := self buildStackListWith: builder.
	listSpec frame: (0@0 corner: 1@0.275).
	panel children add: listSpec.

	textSpec := self buildActualCodePaneWith: builder.
	textSpec frame: (0@0.275 corner: 1@1).
	panel children add: textSpec.
	
	^ panel
]

{
	#category : #'*ExploratoryNotebooks-tracking',
	#'squeak_changestamp' : 'ct 12/2/2025 01:40'
}
Debugger >> xnbNewTrackingContextForDebugging: expression [

	^ (super xnbNewTrackingContextForDebugging: expression)
		receiverContext: self xnbTrackingContext;
		yourself
]

{
	#category : #'*ExploratoryNotebooks-tracking',
	#'squeak_changestamp' : 'ct 12/2/2025 00:36'
}
Debugger >> xnbNewTrackingContextForEvaluating: expression [

	^ (super xnbNewTrackingContextForEvaluating: expression)
		receiverContext: self xnbTrackingContext;
		yourself
]

{
	#category : #'*ExploratoryNotebooks',
	#'squeak_changestamp' : 'ct 12/2/2025 02:00'
}
Debugger >> xnbSpawn [

	(self interruptedProcess environmentAt: #xnbDebugInvocation ifAbsent: [nil]) ifNotNil: [:block |
		^ block value].
	^ self interruptedProcess debug
]

{
	#category : #'*ExploratoryNotebooks',
	#'squeak_changestamp' : 'ct 12/2/2025 01:06'
}
Debugger >> xnbTargetObject [

	^ self
]

{
	#category : #'*ExploratoryNotebooks-tracking',
	#'squeak_changestamp' : 'ct 12/22/2025 21:20'
}
Debugger >> xnbTrackingContext [

	^ XnbTracker trackingContextFor: self
]

{
	#category : #'*ExploratoryNotebooks-tracking',
	#'squeak_changestamp' : 'ct 12/2/2025 00:34'
}
Debugger >> xnbTrackingContext: aXnbTrackingContext [

	XnbTracker trackingContextFor: self put: aXnbTrackingContext.
]
