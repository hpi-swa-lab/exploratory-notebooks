Class {
	#name : #XnbWorkspace,
	#superclass : #Workspace,
	#instVars : [
		'notebook',
		'lastExecutedToolContainer',
		'trackedVariables'
	],
	#category : #ExploratoryNotebooks
}

{
	#category : #accessing,
	#'squeak_changestamp' : 'ct 1/13/2026 01:31'
}
XnbWorkspace class >> appInstanceName [

	^ 'Exploratory Notebook'
]

{
	#category : #accessing,
	#'squeak_changestamp' : 'ct 1/13/2026 01:29'
}
XnbWorkspace class >> appName [

	^ 'Exploratory Notebooks'
]

{
	#category : #accessing,
	#'squeak_changestamp' : 'ct 12/29/2025 04:00'
}
XnbWorkspace class >> githubRepositoryParams [

	^ {'hpi-swa-lab'. 'exploratory-notebooks'. 'squeak'}
]

{
	#category : #'initialize-release',
	#'squeak_changestamp' : 'ct 1/13/2026 01:30'
}
XnbWorkspace class >> initialize [

	self registerInWorldMenu.
]

{
	#category : #'instance creation',
	#'squeak_changestamp' : 'ct 11/25/2025 16:19'
}
XnbWorkspace class >> open [

	^ self new open
]

{
	#category : #'instance creation',
	#'squeak_changestamp' : 'ct 1/16/2026 19:17'
}
XnbWorkspace class >> openExample [

	^ XnbNotebook example openWithLabel: 'Welcome'
]

{
	#category : #'initialize-release',
	#'squeak_changestamp' : 'ct 1/13/2026 01:31'
}
XnbWorkspace class >> registerInWorldMenu [

	TheWorldMenu registerOpenCommand: {self appInstanceName. {self. #open}}.
]

{
	#category : #preferences,
	#'squeak_changestamp' : 'ct 1/13/2026 01:32'
}
XnbWorkspace class >> shouldStyle [

	^ true
]

{
	#category : #'initialize-release',
	#'squeak_changestamp' : 'ct 1/13/2026 01:30'
}
XnbWorkspace class >> unload [

	self unregisterFromWorldMenu.
]

{
	#category : #'initialize-release',
	#'squeak_changestamp' : 'ct 1/13/2026 01:31'
}
XnbWorkspace class >> unregisterFromWorldMenu [

	TheWorldMenu unregisterOpenCommand: self appInstanceName.
]

{
	#category : #toolbuilder,
	#'squeak_changestamp' : 'ct 12/29/2025 04:02'
}
XnbWorkspace >> addModelItemsToWindowMenu: menu [

	super addModelItemsToWindowMenu: menu.
	
	(self class respondsTo: #appMenu:) ifTrue:
		[menu addLine.
		self class appMenu: menu].
]

{
	#category : #toolbuilder,
	#'squeak_changestamp' : 'ct 12/27/2025 20:17'
}
XnbWorkspace >> buildButtonBarWith: builder [

	^ builder pluggablePanelSpec new
		layout: #horizontal;
		children:
			(OrderedCollection new
				add:
					(builder pluggableActionButtonSpec new
						label: 'Rerun all';
						model: self;
						action: #rerunAll;
						yourself);
				add:
					(builder pluggableActionButtonSpec new
						label: 'Export';
						model: self;
						action: #export;
						yourself);
				yourself);
		yourself
]

{
	#category : #toolbuilder,
	#'squeak_changestamp' : 'ct 11/25/2025 16:23'
}
XnbWorkspace >> buildCodePaneWith: builder [

	^ (super buildCodePaneWith: builder)
		editText: #textContents:;
		yourself
]

{
	#category : #toolbuilder,
	#'squeak_changestamp' : 'ct 12/1/2025 21:19'
}
XnbWorkspace >> buildWith: builder [

	| windowSpec window |
	windowSpec := self buildWindowWith: builder specs:
		{LayoutFrame new rightFraction: 1; bottomOffset: (self buttonBarHeightWith: builder); ->
			[self buildButtonBarWith: builder].
		LayoutFrame fullFrame topOffset: (self buttonBarHeightWith: builder); ->
			[self buildCodePaneWith: builder]}.
	window := builder build: windowSpec.
	XnbTracker addCurrentWorkspace: self.
	^ window
]

{
	#category : #toolbuilder,
	#'squeak_changestamp' : 'ct 11/28/2025 21:39'
}
XnbWorkspace >> buttonBarHeightWith: builder [

	^ builder buttonRowHeight
]

{
	#category : #accessing,
	#'squeak_changestamp' : 'ct 1/13/2026 01:35'
}
XnbWorkspace >> cleanFileNameForSave: aString [

	^ (aString includes: $.)
		ifFalse: [aString , '.xnb.html']
		ifTrue: [aString]
]

{
	#category : #accessing,
	#'squeak_changestamp' : 'ct 12/1/2025 23:20'
}
XnbWorkspace >> contents [

	^ self notebook text
]

{
	#category : #evaluation,
	#'squeak_changestamp' : 'ct 11/28/2025 22:30'
}
XnbWorkspace >> doItReceiver [

	^ self toolFactory
]

{
	#category : #evaluation,
	#'squeak_changestamp' : 'ct 12/1/2025 23:18'
}
XnbWorkspace >> evaluate: aText [

	^ self doItReceiver class evaluatorClass new
		evaluate: aText
		in: nil
		to: self doItReceiver
		environment: self environment
		notifying: self
		ifFail: [self halt. ^ nil]
		logged: true
]

{
	#category : #actions,
	#'squeak_changestamp' : 'ct 1/13/2026 01:36'
}
XnbWorkspace >> export [

	| fileName |
	fileName := Project uiManager
		saveFilenameRequest: 'Save exploratory notebook as...'
		initialAnswer: self suggestedFileNameForSave.
	fileName ifNil: [^ self].
	self notebook saveOnFileNamed: fileName.
]

{
	#category : #'initialize-release',
	#'squeak_changestamp' : 'ct 12/28/2025 02:44'
}
XnbWorkspace >> initialExtent [
	"Window aspect ratio is 5 sqrt::2"
	
	^ 447 @ 400
]

{
	#category : #'initialize-release',
	#'squeak_changestamp' : 'ct 11/25/2025 16:23'
}
XnbWorkspace >> initialize [

	super initialize.
	
	self notebook: XnbNotebook new.
]

{
	#category : #toolbuilder,
	#'squeak_changestamp' : 'ct 1/16/2026 19:17'
}
XnbWorkspace >> labelString [

	^ windowTitle ifNil: [self class appInstanceName , '(' , self identityHash , ')']
]

{
	#category : #accessing,
	#'squeak_changestamp' : 'ct 11/29/2025 01:17'
}
XnbWorkspace >> lastExecutedToolContainer [

	^ lastExecutedToolContainer
]

{
	#category : #binding,
	#'squeak_changestamp' : 'ct 12/28/2025 03:09'
}
XnbWorkspace >> newBindingNameFor: name [

	| bindingName |
	self flag: #moveUpstream.
	
	bindingName := (name isString and: [name isOctetString])
		ifTrue: [name asString withFirstCharacterDownshifted]
		ifFalse: ['a' , name].
	(self hasBindingOf: bindingName) ifTrue: [| num |
		self flag: #discuss. "mt: #identityHash or readable number?"
		num := 2.
		[self hasBindingOf: bindingName, num]
			whileTrue: [num := num + 1].
		bindingName := bindingName, num].
	^ bindingName
]

{
	#category : #accessing,
	#'squeak_changestamp' : 'ct 11/25/2025 16:23'
}
XnbWorkspace >> notebook [

	^ notebook
]

{
	#category : #accessing,
	#'squeak_changestamp' : 'ct 12/27/2025 20:54'
}
XnbWorkspace >> notebook: aNotebook [

	notebook := aNotebook.
	aNotebook noteWorkspace: self.
]

{
	#category : #toolbuilder,
	#'squeak_changestamp' : 'ct 11/25/2025 17:26'
}
XnbWorkspace >> open [

	^ ToolBuilder open: self label: self labelString
]

{
	#category : #evaluation,
	#'squeak_changestamp' : 'ct 12/29/2025 03:56'
}
XnbWorkspace >> printIt: aStringOrText result: anObject [
	"Like default printIt but eliminate spaces around the result."

	| editor index text |
	text := self printItTextFor: anObject.
	
	editor := self codeTextMorph textMorph editor.
	index := editor stopIndex.
	editor
		closeTypeIn;
		selectInvisiblyFrom: index to: index - 1;
		replace: editor selectionInterval with: text;
		closeTypeIn.
]

{
	#category : #evaluation,
	#'squeak_changestamp' : 'ct 12/2/2025 00:00'
}
XnbWorkspace >> printItTextFor: anObject [

	| container |
	container := XnbToolContainer forWorkspace: self.
	lastExecutedToolContainer := container.
	container buildWidgets; object: anObject.
	bindings associations
		detect: [:binding | binding value == container toolModel xnbTargetObject]
		ifFound: [:binding | container toolModel xnbTrackingContext: (XnbTrackingContext expression: binding key)].
	self triggerEvent: #lastExecutedToolContainer.
	^ Text streamContents: [:stream |
		stream
			cr;
			withAttribute: (XnbTextAnchor new anchoredMorph: container) do:
				[stream nextPut: Character startOfHeader];
			cr]
]

{
	#category : #recording,
	#'squeak_changestamp' : 'ct 12/27/2025 20:04'
}
XnbWorkspace >> recordContextChain: contextChain receiverName: receiverName tool: aModel doItExpression: doItExpression [

	| previousName |
	previousName := receiverName.
	contextChain do: [:context |
		| expression result name |
		expression := context expressionForReplay.
		previousName ifNotNil:
			[expression := expression
				copyReplaceAll: 'self' with: previousName].
		expression := expression copyReplaceAll: '%WORKSPACE%' with: 'self'.
		bindings
			at: expression
			ifPresent: [:value |
				result := value.
				name := expression]
			ifAbsent:
				[result := self evaluate: expression.
				name := self newBindingNameFor: result canonicalArgumentName.
				(self bindingOf: name) value: result.
				self notebook text: self notebook text , String cr ,
					('{1} := {2}.' format: {name. expression}).
				self changed: #contents].
		self trackedVariables at: context put: name.
		previousName := name].
	
	doItExpression
		ifNotNil:
			[self notebook text: self notebook text , String cr , doItExpression , '.'.
			self changed: #contents]
		ifNil:
			[| toolCode tool |
			toolCode := aModel xnbToolCodeFor: previousName.
			self notebook text: self notebook text , String cr , toolCode , '.' , (self printItTextFor: (self evaluate: toolCode)).
			tool := self notebook toolContainerAtIndex: self notebook numberOfToolContainers.
			(tool respondsTo: #xnbTrackingContext:) ifTrue:
				[tool xnbTrackingContext: contextChain last].
			self changed: #contents].
]

{
	#category : #recording,
	#'squeak_changestamp' : 'ct 12/2/2025 00:21'
}
XnbWorkspace >> recordExpression: aStringOrText fromTool: aModel [

	| contextChain |
	contextChain := aModel xnbTrackingContext contextChain.
	contextChain reverseDo: [:context |
		self trackedVariables at: context ifPresent: [:variable |
			^ self recordContextChain: (contextChain copyAfter: context) receiverName: variable tool: aModel doItExpression: aStringOrText]].
	^ self recordContextChain: contextChain receiverName: nil tool: aModel doItExpression: aStringOrText
]

{
	#category : #recording,
	#'squeak_changestamp' : 'ct 12/2/2025 01:29'
}
XnbWorkspace >> recordStaticTool: aModel [

	| toolCode tool |
	toolCode := aModel xnbToolCode.
	self notebook text: self notebook text , String cr , toolCode , '.' , (self printItTextFor: (self evaluate: toolCode)).
	tool := self notebook toolContainerAtIndex: self notebook numberOfToolContainers.
	self changed: #contents.
]

{
	#category : #recording,
	#'squeak_changestamp' : 'ct 12/28/2025 01:56'
}
XnbWorkspace >> recordTool: aModel [

	^ self recordExpression: nil fromTool: aModel
]

{
	#category : #actions,
	#'squeak_changestamp' : 'ct 11/29/2025 01:51'
}
XnbWorkspace >> rerunAll [

	lastExecutedToolContainer := nil.
	self triggerEvent: #lastExecutedToolContainer.
	^ self rerunUpTo: nil
]

{
	#category : #actions,
	#'squeak_changestamp' : 'ct 12/2/2025 01:54'
}
XnbWorkspace >> rerunUpTo: lastToolContainer [

	| oldSelection |
	(lastExecutedToolContainer notNil and: [lastToolContainer notNil] and: [(self notebook indexOfToolContainer: lastToolContainer) <= (self notebook indexOfToolContainer: lastExecutedToolContainer)])
		ifTrue:
			[lastExecutedToolContainer := nil.
			self triggerEvent: #lastExecutedToolContainer].
	
	oldSelection := self codeTextMorph selectionInterval.
	Cursor wait showWhile:
		[self codeTextMorph handleEdit:
			[| editor |
			editor := self codeTextMorph textMorph editor.
			self notebook cellRangesAfter: lastExecutedToolContainer to: lastToolContainer do: [:codeStart :codeStop :toolContainer |
				| oldParagraphSelection |
				oldParagraphSelection := editor paragraph selectionRects.
				editor selectInvisiblyFrom: codeStart to: codeStop; storeSelectionInParagraph.
				editor morph selectionChanged: oldParagraphSelection , editor paragraph selectionRects.
				self currentWorld displayWorld.
				toolContainer
					ifNotNil:
						[(editor evaluateSelectionAndDo: [:result |
							toolContainer newObject: result.
							(toolContainer toolModel respondsTo: #xnbTrackingContext:) ifTrue:
								 [toolContainer toolModel xnbTrackingContext: nil].
							bindings associations
								detect: [:binding | binding value == toolContainer toolModel xnbTargetObject]
								ifFound: [:binding | toolContainer toolModel xnbTrackingContext: (XnbTrackingContext expression: binding key)].
							lastExecutedToolContainer := toolContainer.
							self triggerEvent: #lastExecutedToolContainer])
								ifNil:
									["cancelled"
									^ false]]
					ifNil:
						[editor printIt.
						self textContents: self codeTextMorph text.
						oldSelection := nil]]]].
	
	oldSelection ifNotNil:
		[self codeTextMorph selectionInterval: oldSelection].
]

{
	#category : #accessing,
	#'squeak_changestamp' : 'ct 12/27/2025 19:16'
}
XnbWorkspace >> textContents: aTextOrString [

	| oldText unstyledText textMorph |
	oldText := self notebook text.
	
	unstyledText := (self codeTextMorph respondsTo: #styler)
		ifTrue: [self codeTextMorph styler unstyledTextFrom: aTextOrString]
		ifFalse: [aTextOrString asText copy].
	self notebook text: unstyledText.
	
	textMorph := self codeTextMorph ifNil: [^ self].
	textMorph textMorph xnbFixUpEmbeddedMorphsFrom: oldText.
	(self currentHand future: 1) newKeyboardFocus: textMorph.
]

{
	#category : #updating,
	#'squeak_changestamp' : 'ct 12/27/2025 19:11'
}
XnbWorkspace >> toolContainerLayoutUpdated: aToolContainer [

	| textMorph index |
	textMorph := self codeTextMorph ifNil: [^ self].
	
	index := self notebook indexOfToolContainer: aToolContainer.
	textMorph textMorph paragraph recomposeFrom: index to: index delta: 0.
	textMorph changed.
]

{
	#category : #accessing,
	#'squeak_changestamp' : 'ct 11/28/2025 22:30'
}
XnbWorkspace >> toolFactory [

	^ XnbToolFactory new
]

{
	#category : #evaluation,
	#'squeak_changestamp' : 'ct 11/28/2025 22:20'
}
XnbWorkspace >> toolMorphFor: anObject [

	^ anObject copy asXnbMorphFor: self doItReceiver
]

{
	#category : #accessing,
	#'squeak_changestamp' : 'ct 12/1/2025 23:39'
}
XnbWorkspace >> trackedVariables [

	^ trackedVariables ifNil: [trackedVariables := WeakIdentityKeyDictionary new]
]

{
	#category : #evaluation,
	#'squeak_changestamp' : 'ct 12/1/2025 23:19'
}
XnbWorkspace >> wantsInteractiveErrorCorrection [

	^ false
]

{
	#category : #toolbuilder,
	#'squeak_changestamp' : 'ct 12/1/2025 21:17'
}
XnbWorkspace >> windowIsClosing [

	super windowIsClosing.
	
	[self containingWindow ifNil:
		[XnbTracker removeCurrentWorkspace: self]] future value.
]

{
	#category : #accessing,
	#'squeak_changestamp' : 'ct 12/28/2025 03:08'
}
XnbWorkspace >> windowTitle [

	self flag: #moveUpstream.
	^ windowTitle ifNil: [self class name]
]
