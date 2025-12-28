Extension { #name : #ContextVariablesInspector }

{
	#category : #'*ExploratoryNotebooks-menu - commands',
	#'squeak_changestamp' : 'ct 12/2/2025 01:26'
}
ContextVariablesInspector >> xnbExpressionFor: field [

	field basicValueGetterExpression ifNil: [^ self selectedField expressionWithReceiverName: #self].
	
	field type = #tempVar ifTrue: [^ 'self tempNamed: {1}' format: {field name}].
	
	^ (super xnbExpressionFor: field)
		copyReplaceAll: 'ThisContext' with: 'self'
]
