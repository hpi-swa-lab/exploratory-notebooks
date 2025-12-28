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
