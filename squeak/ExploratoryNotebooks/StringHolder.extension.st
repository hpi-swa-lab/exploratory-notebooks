Extension { #name : #StringHolder }

{
	#category : #'*ExploratoryNotebooks',
	#'squeak_changestamp' : 'ct 12/2/2025 00:27'
}
StringHolder >> xnbAddExpressionToNotebookFrom: aTextMorph [

	| expression |
	aTextMorph editor lineSelectAndEmptyCheck: [^ self changed: #flash].
	expression := aTextMorph editor selection.
	XnbTracker recordExpression: expression fromTool: self.
]

{
	#category : #'*ExploratoryNotebooks',
	#'squeak_changestamp' : 'ct 12/28/2025 22:24'
}
StringHolder >> xnbCodePaneMenu: aMenu [
	<codePaneMenuShifted: false>

	XnbTracker isTracking ifTrue:
		[aMenu
			addLine;
			add: 'add to notebook'
				target: self
				selector: #xnbAddExpressionToNotebookFrom:
				argument: self currentHand keyboardFocus].
	^ aMenu
]
