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
	#'squeak_changestamp' : 'ct 12/22/2025 21:51'
}
Object >> xxxxnbResolveProxy [

	^ self
]

{
	#category : #'*ExploratoryNotebooks-tracking',
	#'squeak_changestamp' : 'ct 12/23/2025 01:35'
}
Object >> xxxxnbTrackingContext [

	^ nil
]
