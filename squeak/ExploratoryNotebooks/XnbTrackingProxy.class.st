"
I am a transparent proxy that tracks all messages sent to the underlying object and their results etc.
"
Class {
	#name : #XnbTrackingProxy,
	#superclass : #ProtoObject,
	#instVars : [
		'object',
		'context'
	],
	#category : #'ExploratoryNotebooks-Tracking',
	#'squeak_changestamp' : 'ct 12/28/2025 02:34'
}

{
	#category : #'instance creation',
	#'squeak_changestamp' : 'ct 1/13/2026 20:38'
}
XnbTrackingProxy class >> basicFor: anObject [

	anObject ifNil: [^ anObject].
	(ProtoObject canUnderstand: #resolveProxy) ifFalse:
		[self flag: #requirement. "Optional dependency of #resolveProxy changeset."
		(anObject isString or: [anObject isNumber] or: [anObject isBoolean] or: [anObject isForm]) ifTrue: [^ nil]].
	
	^ self newOn: anObject
]

{
	#category : #'instance creation',
	#'squeak_changestamp' : 'ct 1/13/2026 20:38'
}
XnbTrackingProxy class >> for: anObject [

	^ (self basicFor: anObject) ifNil: [anObject]
]

{
	#category : #'instance creation',
	#'squeak_changestamp' : 'ct 12/22/2025 21:58'
}
XnbTrackingProxy class >> newOn: anObject [

	^ self new xxxxnbTrackedObject: anObject
]

{
	#category : #'system primitives',
	#'squeak_changestamp' : 'ct 1/13/2026 20:38'
}
XnbTrackingProxy >> doesNotUnderstand: aMessage [

	| lookupClass selector arguments method result |
	lookupClass := thisContext objectClass: self xxxxnbTrackedObject.
	selector := aMessage selector.
	method := (lookupClass lookupSelector: selector)
		ifNil:
			[arguments := {aMessage}.
			lookupClass lookupSelector: #doesNotUnderstand:].
	
	nil flag: #todo. "intercept super sends (e.g. #printOn:), either by executing methods that send super directly to the object or by modifying bytecode/last literal?"
	method methodClass ifNotNil: [:methodClass |
		"Cog VM inlines special sends to the receiver such as #<=, so tell the VM the receiver is no longer a SmallInteger"
		(methodClass includesBehavior: SmallInteger) ifTrue:
			[method := method copy
				literalAt: method numLiterals put: LargePositiveInteger binding; "so it has the same superclass"
				yourself]].
	
	result := method
		valueWithReceiver:
			((method primitive ~= 0 or: [method hasInstVarRef] or: [method sendsSelector: #class])
				ifTrue: [self xxxxnbTrackedObject] "without bytecode, rewriting we need to skip those methods"
				ifFalse: [self])
		arguments: (arguments ifNil: [aMessage arguments]).
	
	^ (XnbTrackingProxy basicFor: result xxxxnbResolveTrackingProxy)
		ifNil: [result xxxxnbResolveTrackingProxy]
		ifNotNil: [:proxy |
			proxy xxxxnbTrackingContext:
				((XnbTrackingContext message: aMessage)
					receiverContext: self xxxxnbTrackingContext)]
]

{
	#category : #proxy,
	#'squeak_changestamp' : 'ct 12/22/2025 21:36'
}
XnbTrackingProxy >> isProxy [

	^ true
]

{
	#category : #'system primitives',
	#'squeak_changestamp' : 'ct 1/12/2026 22:44'
}
XnbTrackingProxy >> mustBeBoolean [
	"Overwritten to preserve original sender context.
	
	This is required to support conditional jumps (ifTrue:/ifFalse:) based on traced booleans, e.g.:
		(ObjectTracer on: false) ifTrue: [1] ifFalse: [2]."

	^ (self mustBeBooleanIn: thisContext sender) xxxxnbResolveTrackingProxy
]

{
	#category : #proxy,
	#'squeak_changestamp' : 'ct 1/12/2026 22:44'
}
XnbTrackingProxy >> resolveProxy [

	^ self xxxxnbResolveTrackingProxy
]

{
	#category : #accessing,
	#'squeak_changestamp' : 'ct 1/12/2026 22:44'
}
XnbTrackingProxy >> xxxxnbResolveTrackingProxy [

	^ self xxxxnbTrackedObject xxxxnbResolveTrackingProxy
]

{
	#category : #accessing,
	#'squeak_changestamp' : 'ct 12/22/2025 21:12'
}
XnbTrackingProxy >> xxxxnbTrackedObject [

	^ object
]

{
	#category : #accessing,
	#'squeak_changestamp' : 'ct 12/22/2025 21:12'
}
XnbTrackingProxy >> xxxxnbTrackedObject: anObject [

	object := anObject.
]

{
	#category : #accessing,
	#'squeak_changestamp' : 'ct 12/22/2025 21:12'
}
XnbTrackingProxy >> xxxxnbTrackingContext [

	^ context
]

{
	#category : #accessing,
	#'squeak_changestamp' : 'ct 12/22/2025 21:12'
}
XnbTrackingProxy >> xxxxnbTrackingContext: aContext [

	context := aContext.
]
