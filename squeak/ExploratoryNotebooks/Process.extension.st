Extension { #name : #Process }

{
	#category : #'*ExploratoryNotebooks',
	#'squeak_changestamp' : 'ct 11/28/2025 21:35'
}
Process >> asXnbMorphFor: aToolFactory [

	^ (aToolFactory debug: self)
		asXnbMorphFor: aToolFactory
]
