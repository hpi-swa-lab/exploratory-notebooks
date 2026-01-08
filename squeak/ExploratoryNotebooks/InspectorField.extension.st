Extension { #name : #InspectorField }

{
	#category : #'*ExploratoryNotebooks-accessing - code-pseudo-override',
	#'squeak_changestamp' : 'ct 1/8/2026 03:49'
}
InspectorField >> basicValueGetterExpression [

	self flag: #moveUpstream.
	^ valueGetterExpression
]
