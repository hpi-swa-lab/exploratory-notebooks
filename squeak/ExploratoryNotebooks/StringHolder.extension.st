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
	#'squeak_changestamp' : 'ct 1/13/2026 20:37'
}
StringHolder >> xnbCodePaneMenu: aMenu [
	<codePaneMenuShifted: false>
	<menuPriority: 400> "'more...' at the very bottom is crucial for muscle memory"

	XnbTracker isTracking ifTrue:
		[aMenu
			addLine;
			add: 'add to notebook'
				target: self
				selector: #xnbAddExpressionToNotebookFrom:
				argument: self currentHand keyboardFocus].
	^ aMenu
]
