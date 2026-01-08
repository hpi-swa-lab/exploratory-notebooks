Extension { #name : #StandardToolSet }

{
	#category : #'*ExploratoryNotebooks-inspecting',
	#'squeak_changestamp' : 'ct 12/21/2025 05:07'
}
StandardToolSet class >> basicInspect: anObject xnbTrackingContext: aXnbTrackingContext [

	^ BasicInspector openOn: anObject xnbTrackingContext: aXnbTrackingContext
]

{
	#category : #'*ExploratoryNotebooks-inspecting',
	#'squeak_changestamp' : 'ct 12/23/2025 00:18'
}
StandardToolSet class >> explore: anObject xnbTrackingContext: aXnbTrackingContext [

	^ XnbObjectExplorer openOn: anObject xnbTrackingContext: aXnbTrackingContext
]

{
	#category : #'*ExploratoryNotebooks-debugging - handlers-override',
	#'squeak_changestamp' : 'ct 11/25/2025 21:55'
}
StandardToolSet class >> handleError: anError [
	"Double dispatch. Let the processor take care of that error, which usually calls back here to #debugProcess:..."

	self flag: #todoDebugger. "mt: Pass exception-specific parameters to the invocation cue such as for BlockCannotReturn. See discussions here: 
- http://lists.squeakfoundation.org/archives/list/squeak-dev@lists.squeakfoundation.org/thread/3KBIDO6EUEL7ITTH6TCLAU2PSPSOZBHL/
- http://lists.squeakfoundation.org/archives/list/squeak-dev@lists.squeakfoundation.org/thread/FAPYVA4R2V42KTNJTTW5EKUUESR6V34G/
"
	
	(Processor activeProcess environmentAt: #xnbErrorHandler ifAbsent: [nil]) ifNotNil: [:block |
		^ block value: anError].
	
	^ Processor debugWithCue: (DebuggerInvocationCue new
		context: anError signalerContext;
		exception: anError;
		label: anError description;
		fullView: false;
		"contents: nil;"
		yourself)
]

{
	#category : #'*ExploratoryNotebooks-inspecting',
	#'squeak_changestamp' : 'ct 12/1/2025 20:22'
}
StandardToolSet class >> inspect: anObject xnbTrackingContext: aXnbTrackingContext [

	| class |
	class := anObject inspectorClass.
	class isProxy ifTrue: [class := (Smalltalk classNamed: class name) ifNil: [Inspector]].
	(class respondsTo: #openOn:xnbTrackingContext:)
		ifFalse: [^ class openOn: anObject].
	^ class openOn: anObject xnbTrackingContext: aXnbTrackingContext
]
