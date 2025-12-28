Extension { #name : #ToolSet }

{
	#category : #'*ExploratoryNotebooks-inspecting',
	#'squeak_changestamp' : 'ct 12/21/2025 05:06'
}
ToolSet class >> basicInspect: anObject xnbTrackingContext: aXnbTrackingContext [

	(self default respondsTo: #basicInspect:xnbTrackingContext:) ifFalse:
		[^ self basicInspect: anObject].
	^self default basicInspect: anObject xnbTrackingContext: aXnbTrackingContext
]

{
	#category : #'*ExploratoryNotebooks-inspecting',
	#'squeak_changestamp' : 'ct 12/1/2025 23:29'
}
ToolSet class >> explore: anObject xnbTrackingContext: aXnbTrackingContext [

	(self default respondsTo: #explore:xnbTrackingContext:) ifFalse:
		[^ self explore: anObject].
	^self default explore: anObject xnbTrackingContext: aXnbTrackingContext
]

{
	#category : #'*ExploratoryNotebooks-inspecting',
	#'squeak_changestamp' : 'ct 12/1/2025 20:21'
}
ToolSet class >> inspect: anObject xnbTrackingContext: aXnbTrackingContext [

	(self default respondsTo: #inspect:xnbTrackingContext:) ifFalse:
		[^ self inspect: anObject].
	^self default inspect: anObject xnbTrackingContext: aXnbTrackingContext
]
