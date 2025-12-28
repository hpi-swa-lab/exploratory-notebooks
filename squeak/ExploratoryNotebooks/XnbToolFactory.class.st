Class {
	#name : #XnbToolFactory,
	#superclass : #Object,
	#category : #ExploratoryNotebooks
}

{
	#category : #tools,
	#'squeak_changestamp' : 'ct 11/25/2025 21:16'
}
XnbToolFactory >> browse: anObject [

	^ XnbCodeHolder new
		setClass: anObject methodClass
		selector: anObject selector
]

{
	#category : #tools,
	#'squeak_changestamp' : 'ct 11/25/2025 22:26'
}
XnbToolFactory >> debug: aBlockOrProcess [

	aBlockOrProcess isBlock ifTrue:
		[^ self debug: (Process forBlock: aBlockOrProcess)].
	^ (XnbDebugger onProcess: aBlockOrProcess context: aBlockOrProcess suspendedContext)
		initializeFull
]

{
	#category : #tools,
	#'squeak_changestamp' : 'ct 11/28/2025 18:00'
}
XnbToolFactory >> debugErrorWhile: aBlockOrProcess [

	| promise |
	aBlockOrProcess isBlock ifTrue:
		[^ self debugErrorWhile: (Process forBlock: aBlockOrProcess)].
	promise := Promise new.
	aBlockOrProcess environmentAt: #xnbErrorHandler put: [:error |
		promise fulfillWith: [(XnbDebugger onProcess: aBlockOrProcess context: error signalerContext) labelString: error description; expandNotifierStack]].
	(aBlockOrProcess calleeOf: aBlockOrProcess suspendedContext bottomContext) insertSender:
		[promise reject] asContext.
	aBlockOrProcess resume.
	^ promise wait
]

{
	#category : #tools,
	#'squeak_changestamp' : 'ct 12/2/2025 02:05'
}
XnbToolFactory >> debugErrorWhile: aBlockOrProcess in: aProcess [

	| promise |
	aBlockOrProcess isBlock ifTrue:
		[^ self debugErrorWhile: (Process forBlock: aBlockOrProcess) in: aProcess].
	promise := Promise new.
	aProcess environmentAt: #xnbErrorHandler put: [:error |
		promise fulfillWith: [(XnbDebugger onProcess: aProcess context: error signalerContext) labelString: error description; expandNotifierStack].
		Processor activeProcess environmentAt: #xnbDebugInvocation put: [ToolSet debugWithCue: (DebuggerInvocationCue new process: aProcess; context: error signalerContext; label: error description; fullView: false; contents: nil; yourself)].
		Processor activeProcess suspend].
	"(aProcess calleeOf: aProcess suspendedContext bottomContext) insertSender:
		[10 seconds wait. promise reject] asContext."
	aBlockOrProcess resume.
	^ promise wait
]

{
	#category : #tools,
	#'squeak_changestamp' : 'ct 11/25/2025 16:43'
}
XnbToolFactory >> explore: anObject [

	^ ObjectExplorer explore: anObject
]

{
	#category : #tools,
	#'squeak_changestamp' : 'ct 11/25/2025 22:22'
}
XnbToolFactory >> inspect: anObject [

	^ Inspector inspect: anObject
]
