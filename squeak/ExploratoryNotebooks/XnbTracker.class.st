Class {
	#name : #XnbTracker,
	#superclass : #Object,
	#classVars : [
		'CurrentWorkspaces',
		'TrackingContexts'
	],
	#category : #ExploratoryNotebooks
}

{
	#category : #'accessing - workspaces',
	#'squeak_changestamp' : 'ct 12/2/2025 00:07'
}
XnbTracker class >> addCurrentWorkspace: aWorkspace [

	self basicCurrentWorkspaces at: aWorkspace put: true.
	self triggerEvent: #isTracking.
]

{
	#category : #'accessing - workspaces',
	#'squeak_changestamp' : 'ct 12/1/2025 21:20'
}
XnbTracker class >> basicCurrentWorkspaces [

	^ CurrentWorkspaces ifNil: [CurrentWorkspaces := EphemeronIdentityDictionary new]
]

{
	#category : #'accessing - workspaces',
	#'squeak_changestamp' : 'ct 12/1/2025 21:20'
}
XnbTracker class >> currentWorkspaces [

	^ self basicCurrentWorkspaces keys
]

{
	#category : #tracking,
	#'squeak_changestamp' : 'ct 12/2/2025 00:04'
}
XnbTracker class >> isTracking [

	^ self currentWorkspaces notEmpty
]

{
	#category : #recording,
	#'squeak_changestamp' : 'ct 12/2/2025 00:21'
}
XnbTracker class >> recordExpression: aStringOrText fromTool: aModel [

	^ self requestWorkspace recordExpression: aStringOrText fromTool: aModel
]

{
	#category : #recording,
	#'squeak_changestamp' : 'ct 12/2/2025 01:30'
}
XnbTracker class >> recordStaticTool: aModel [

	^ self requestWorkspace recordStaticTool: aModel
]

{
	#category : #recording,
	#'squeak_changestamp' : 'ct 12/1/2025 21:13'
}
XnbTracker class >> recordTool: aModel [

	^ self requestWorkspace recordTool: aModel
]

{
	#category : #'accessing - workspaces',
	#'squeak_changestamp' : 'ct 12/2/2025 01:45'
}
XnbTracker class >> removeCurrentWorkspace: aWorkspace [

	self basicCurrentWorkspaces removeKey: aWorkspace ifAbsent: [].
	self triggerEvent: #isTracking.
]

{
	#category : #recording,
	#'squeak_changestamp' : 'ct 12/1/2025 21:21'
}
XnbTracker class >> requestWorkspace [

	| workspaces |
	workspaces := self currentWorkspaces.
	workspaces size < 2 ifTrue: [^ workspaces ifNotEmpty: [workspaces anyOne]].
	^ Project uiManager
		chooseFromLabeledValues:
			(workspaces collect: [:workspace | workspace labelString -> workspace])
		title: 'Choose notebook'
]

{
	#category : #'accessing - tracking contexts',
	#'squeak_changestamp' : 'ct 12/1/2025 20:28'
}
XnbTracker class >> trackingContextFor: aModel [

	^ self trackingContexts at: aModel ifAbsent: [nil]
]

{
	#category : #'accessing - tracking contexts',
	#'squeak_changestamp' : 'ct 12/1/2025 20:26'
}
XnbTracker class >> trackingContextFor: aModel put: aTrackingContext [

	^ self trackingContexts at: aModel put: aTrackingContext
]

{
	#category : #'accessing - tracking contexts',
	#'squeak_changestamp' : 'ct 12/1/2025 20:27'
}
XnbTracker class >> trackingContexts [

	^ TrackingContexts ifNil: [TrackingContexts := EphemeronIdentityDictionary new]
]
