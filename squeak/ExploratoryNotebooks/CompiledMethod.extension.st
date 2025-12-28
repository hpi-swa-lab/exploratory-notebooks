Extension { #name : #CompiledMethod }

{
	#category : #'*ExploratoryNotebooks',
	#'squeak_changestamp' : 'ct 11/25/2025 22:13'
}
CompiledMethod >> asXnbMorphFor: aToolFactory [

	^ (aToolFactory browse: self)
		asXnbMorphFor: aToolFactory
]
