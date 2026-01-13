Extension { #name : #Model }

{
	#category : #'*ExploratoryNotebooks-user interface-pseudo-override',
	#'squeak_changestamp' : 'ct 12/1/2025 21:10'
}
Model >> addModelItemsToWindowMenu: menu [

	super addModelItemsToWindowMenu: menu.
	
	XnbTracker isTracking ifTrue:
		[menu
			addLine;
			add: 'add to notebook'
				target: self
				selector: #xnbAddToNotebook].
]

{
	#category : #'*ExploratoryNotebooks-evaluation-pseudo-override',
	#'squeak_changestamp' : 'ct 1/12/2026 22:41'
}
Model >> debugIt: expression process: aProcess [

	XnbTracker isTracking ifFalse: [^ aProcess debugWithTitle: 'Debug it' translated].
	
	^ XnbDebugger
		openOnCue:
			(DebuggerInvocationCue new
				process: aProcess;
				context: aProcess suspendedContext;
				label: 'Debug it';
				contents: nil;
				fullView: true;
				yourself)
		xnbTrackingContext: (self xnbNewTrackingContextForDebugging: expression)
]

{
	#category : #'*ExploratoryNotebooks-evaluation-pseudo-override',
	#'squeak_changestamp' : 'ct 1/13/2026 01:08'
}
Model >> exploreIt: expression result: anObject [

	XnbTracker isTracking ifFalse: [^ ToolSet explore: anObject].
	
	^ ToolSet
		explore: anObject
		xnbTrackingContext: (self xnbNewTrackingContextForEvaluating: expression)
]

{
	#category : #'*ExploratoryNotebooks-evaluation-pseudo-override',
	#'squeak_changestamp' : 'ct 1/12/2026 22:41'
}
Model >> inspectIt: expression result: anObject [

	XnbTracker isTracking ifFalse: [^ ToolSet inspect: anObject].
	
	^ ToolSet
		inspect: anObject
		xnbTrackingContext: (self xnbNewTrackingContextForEvaluating: expression)
]

{
	#category : #'*ExploratoryNotebooks-testing',
	#'squeak_changestamp' : 'ct 12/28/2025 01:59'
}
Model >> isStaticXnbTool [

	^ false
]

{
	#category : #'*ExploratoryNotebooks-evaluation-pseudo-override',
	#'squeak_changestamp' : 'ct 1/13/2026 01:12'
}
Model >> printItTextFor: expression result: anObject requestor: requestor [

	| text |
	thisContext sender method == thisContext method ifTrue: [^ #xnbPrintItTextFor:result:requestor:].
	text := true
		caseOf:
			{[(text := self printItTextFor: expression result: anObject requestor: requestor) ~= #xnbPrintItTextFor:result:requestor:] -> [text]. "honor direct subclass implementations"
			[self respondsTo: #printItTextFor:result:] -> [self printItTextFor: expression result: anObject].
			[self respondsTo: #printItTextFor:] -> [self printItTextFor: anObject]}
		otherwise:
			[requestor basicPrintItTextFor: anObject].
	XnbTracker isTracking ifFalse: [^ text].
	
	text isText ifTrue:
		[text
			replaceAttributesThat: [:attr | attr isKindOf: TextInspectIt]
			by: [:attr | XnbTextInspectIt on: attr target xnbTrackingContext: (self xnbNewTrackingContextForEvaluating: expression)]].
	^ text
]

{
	#category : #'*ExploratoryNotebooks-tracking',
	#'squeak_changestamp' : 'ct 12/2/2025 00:56'
}
Model >> xnbNewTrackingContextForDebugging: expression [

	^ XnbDebuggingTrackingContext expression: expression
]

{
	#category : #'*ExploratoryNotebooks-tracking',
	#'squeak_changestamp' : 'ct 12/1/2025 20:32'
}
Model >> xnbNewTrackingContextForEvaluating: expression [

	^ XnbTrackingContext expression: expression
]
