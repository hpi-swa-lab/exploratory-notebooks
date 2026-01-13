Extension { #name : #Object }

{
	#category : #'*ExploratoryNotebooks',
	#'squeak_changestamp' : 'ct 11/25/2025 17:32'
}
Object >> asXnbMorphFor: aToolFactory [

	^ (aToolFactory explore: self)
		asXnbMorphFor: aToolFactory
]

{
	#category : #'*ExploratoryNotebooks-*Morphic-Explorer-override',
	#'squeak_changestamp' : 'ct 1/13/2026 20:36'
}
Object >> explorerContents [
	"Override that method to define which properties of the object should be shown in the
	object explorer. See for example the implementation in Integer>>#explorerContents."

	self flag: #hacked. "must not send special selector #class :/"
	^ ((self perform: #class) allInstVarNames asOrderedCollection withIndexCollect: [:each :index |
		ObjectExplorerWrapper
			with: (self instVarAt: index)
			name: each
			model: self]) ,
		((1 to: self basicSize) collect: [:index |
			ObjectExplorerWrapper
				with: (self  basicAt: index)
				name: index printString
				model: self ])
]

{
	#category : #'*ExploratoryNotebooks-tools',
	#'squeak_changestamp' : 'ct 12/1/2025 20:45'
}
Object >> xnbTrackingFieldsFor: anInspector on: aStream [
	<inspectorFields>

	anInspector xnbTrackingContext ifNotNil:
		[aStream nextPut:
			((anInspector newFieldForType: #xnbTrackingContext key: #xnbTrackingContext)
				name: '(tracking context)'; emphasizeName;
				valueGetter: [:obj | anInspector xnbTrackingContext];
				"printBlock: [:context | ];"
				yourself)].
]

{
	#category : #'*ExploratoryNotebooks-tracking',
	#'squeak_changestamp' : 'ct 1/12/2026 22:43'
}
Object >> xxxxnbResolveTrackingProxy [

	^ self
]

{
	#category : #'*ExploratoryNotebooks-tracking',
	#'squeak_changestamp' : 'ct 12/23/2025 01:35'
}
Object >> xxxxnbTrackingContext [

	^ nil
]
