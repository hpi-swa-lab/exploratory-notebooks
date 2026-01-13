"
I tracks all messages sent while navigating through the object tree.
"
Class {
	#name : #XnbObjectExplorer,
	#superclass : #ObjectExplorer,
	#category : #'ExploratoryNotebooks-Tools',
	#'squeak_changestamp' : 'ct 12/28/2025 02:02'
}

{
	#category : #'instance creation',
	#'squeak_changestamp' : 'ct 12/23/2025 00:19'
}
XnbObjectExplorer class >> explore: anObject xnbTrackingContext: aXnbTrackingContext [

	^ self new
		xnbTrackingContext: aXnbTrackingContext;
		explore: anObject
]

{
	#category : #'instance creation',
	#'squeak_changestamp' : 'ct 12/23/2025 00:48'
}
XnbObjectExplorer class >> openOn: anObject xnbTrackingContext: aXnbTrackingContext [

	^ ToolBuilder open:
		(self explore: anObject xnbTrackingContext: aXnbTrackingContext)
]

{
	#category : #'menus - actions',
	#'squeak_changestamp' : 'ct 12/23/2025 00:44'
}
XnbObjectExplorer >> exploreSelection [

	XnbTracker isTracking ifFalse:
		[^ ToolSet explore: self object].
	
	^ ToolSet
		explore: self object
		xnbTrackingContext: self selectedXnbTrackingContext
]

{
	#category : #'menus - actions',
	#'squeak_changestamp' : 'ct 12/23/2025 00:45'
}
XnbObjectExplorer >> inspectBasic [

	XnbTracker isTracking ifFalse:
		[^ ToolSet basicInspect: self object].
	
	^ ToolSet
		basicInspect: self object
		xnbTrackingContext: self selectedXnbTrackingContext
]

{
	#category : #'menus - actions',
	#'squeak_changestamp' : 'ct 12/23/2025 00:29'
}
XnbObjectExplorer >> inspectSelection [

	XnbTracker isTracking ifFalse:
		[^ ToolSet inspect: self object].
	
	^ ToolSet
		inspect: self object
		xnbTrackingContext: self selectedXnbTrackingContext
]

{
	#category : #'accessing - objects',
	#'squeak_changestamp' : 'ct 1/12/2026 22:43'
}
XnbObjectExplorer >> object [

	^ super object xxxxnbResolveTrackingProxy
]

{
	#category : #'accessing - objects',
	#'squeak_changestamp' : 'ct 1/13/2026 20:37'
}
XnbObjectExplorer >> rootObject: anObject [

	^ super rootObject:
		((XnbTrackingProxy basicFor: anObject)
			ifNil: [anObject]
			ifNotNil: [:proxy | proxy xxxxnbTrackingContext: self xnbTrackingContext])
]

{
	#category : #accessing,
	#'squeak_changestamp' : 'ct 1/12/2026 22:43'
}
XnbObjectExplorer >> selectedXnbTrackingContext [

	^ self currentSelection xxxxnbResolveTrackingProxy value xxxxnbTrackingContext
]

{
	#category : #tracking,
	#'squeak_changestamp' : 'ct 12/23/2025 00:30'
}
XnbObjectExplorer >> xnbNewTrackingContextForDebugging: expression [

	^ (super xnbNewTrackingContextForDebugging: expression)
		receiverContext: self selectedXnbTrackingContext;
		yourself
]

{
	#category : #tracking,
	#'squeak_changestamp' : 'ct 12/23/2025 00:30'
}
XnbObjectExplorer >> xnbNewTrackingContextForEvaluating: expression [

	^ (super xnbNewTrackingContextForEvaluating: expression)
		receiverContext: self selectedXnbTrackingContext;
		yourself
]
