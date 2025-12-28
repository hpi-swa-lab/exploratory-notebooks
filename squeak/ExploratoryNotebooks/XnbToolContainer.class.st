Class {
	#name : #XnbToolContainer,
	#superclass : #BorderedMorph,
	#instVars : [
		'workspace',
		'panelMorph',
		'labelMorph',
		'toolMorph',
		'executionHint',
		'runButton'
	],
	#category : #ExploratoryNotebooks
}

{
	#category : #'as yet unclassified',
	#'squeak_changestamp' : 'ct 11/28/2025 22:29'
}
XnbToolContainer class >> for: anObject [

	^ self new
		object: anObject;
		yourself
]

{
	#category : #'as yet unclassified',
	#'squeak_changestamp' : 'ct 11/29/2025 01:19'
}
XnbToolContainer class >> for: anObject workspace: aWorkspace [

	^ self new
		workspace: aWorkspace;
		object: anObject;
		yourself
]

{
	#category : #'as yet unclassified',
	#'squeak_changestamp' : 'ct 11/29/2025 01:19'
}
XnbToolContainer class >> forWorkspace: aWorkspace [

	^ self new
		workspace: aWorkspace;
		yourself
]

{
	#category : #'as yet unclassified',
	#'squeak_changestamp' : 'ct 11/25/2025 17:33'
}
XnbToolContainer class >> with: aMorph [

	^ self new
		toolMorph: aMorph;
		yourself
]

{
	#category : #'fileIn/out',
	#'squeak_changestamp' : 'ct 12/28/2025 01:11'
}
XnbToolContainer >> bePlaceholderWithData: data [

	| toolBounds |
	toolBounds := Rectangle readCarefullyFrom: data toolBounds.
	self toolMorph:
		(MorphicModel new
			changeTableLayout;
			vResizing: #shrinkWrap;
			borderWidth: 0;
			setProperty: #toolBounds toValue: toolBounds;
			addMorph: (Form extent: toolBounds extent) asMorph;
			on: #mouseEnter send: #show to: Cursor webLink;
			on: #mouseUp send: #value to: [Cursor normal show. self run];
			fullBounds;
			model:
				(XnbPlaceholderToolModel new
					labelString: data label;
					color: (Color fromString: data color);
					yourself)).
]

{
	#category : #initialization,
	#'squeak_changestamp' : 'ct 12/2/2025 02:13'
}
XnbToolContainer >> buildWidgets [

	panelMorph := Morph new
		color: self panelColor;
		layoutInset: ((2 px asPoint rect: 2 px asPoint) withTop: (2 px + SystemWindow boxExtent y));
		borderColor: Color gray;
		borderWidth: 1 px;
		"changeTableLayout"
		hResizing: #spaceFill;
		vResizing: #spaceFill;
		cellGap: 4 px;
		changeProportionalLayout;
		yourself.
	panelMorph addMorph: self newHeaderMorph fullFrame: (LayoutFrame fullFrame topOffset: (SystemWindow boxExtent y + 4 px) negated).
	
	self addMorph: panelMorph.
	panelMorph addMorphBack:
		(BottomGripMorph new target: self; position: self position).
	self addMorphBack: self newExecutionHint.
]

{
	#category : #commands,
	#'squeak_changestamp' : 'ct 11/25/2025 20:24'
}
XnbToolContainer >> closeButtonHit [

	self owningTextMorph xnbFixUpEmbeddedMorphsAround:
		[self owningPluggableTextMorph
			insertText: ''
			toReplace:
				(Text string: Character startOfHeader asString attribute: (XnbTextAnchor new anchoredMorph: self))
			invisibly: false].
]

{
	#category : #initialization,
	#'squeak_changestamp' : 'ct 11/25/2025 17:46'
}
XnbToolContainer >> defaultBorderColor [

	^ Color transparent
]

{
	#category : #initialization,
	#'squeak_changestamp' : 'ct 11/25/2025 17:46'
}
XnbToolContainer >> defaultBorderWidth [

	^ 2 px
]

{
	#category : #initialization,
	#'squeak_changestamp' : 'ct 11/25/2025 19:14'
}
XnbToolContainer >> defaultColor [

	^ Color transparent
]

{
	#category : #'event handling',
	#'squeak_changestamp' : 'ct 11/28/2025 21:41'
}
XnbToolContainer >> filterEvent: anEvent for: aMorph [

	(anEvent isMouse and: [anEvent isMouseMove]) ifFalse: [^ anEvent].
	
	[anEvent hand keyboardFocus ifNil:
		[self owningPluggableTextMorph mouseEnter: anEvent]] future value.
	
	^ anEvent
]

{
	#category : #'event handling',
	#'squeak_changestamp' : 'ct 11/28/2025 22:09'
}
XnbToolContainer >> handlesMouseMove: anEvent [

	^ true
]

{
	#category : #'event handling',
	#'squeak_changestamp' : 'ct 11/25/2025 17:41'
}
XnbToolContainer >> handlesMouseOver: anEvent [

	^ true
]

{
	#category : #initialization,
	#'squeak_changestamp' : 'ct 11/29/2025 01:16'
}
XnbToolContainer >> initialize [

	super initialize.
	
	self changeTableLayout.
	self textAnchorProperties verticalAlignment: #top.
	self addMouseCaptureFilter: self.
]

{
	#category : #initialization,
	#'squeak_changestamp' : 'ct 11/29/2025 01:16'
}
XnbToolContainer >> initializeWithWorkspace: aWorkspace [

	self workspace: aWorkspace.
	
	self buildWidgets.
]

{
	#category : #testing,
	#'squeak_changestamp' : 'ct 11/29/2025 02:07'
}
XnbToolContainer >> isLastExecuted [

	^ self workspace lastExecutedToolContainer = self
]

{
	#category : #testing,
	#'squeak_changestamp' : 'ct 12/28/2025 01:59'
}
XnbToolContainer >> isStaticTool [

	^ self toolModel isStaticXnbTool
]

{
	#category : #'fileIn/out',
	#'squeak_changestamp' : 'ct 12/27/2025 19:57'
}
XnbToolContainer >> jsonState [

	^ JsonObject new
		toolBounds: ((self toolMorph bounds translateBy: self position negated)) storeString;
		label: self labelMorph contents;
		color: self panelColor printHtmlString;
		yourself
]

{
	#category : #accessing,
	#'squeak_changestamp' : 'ct 11/28/2025 21:59'
}
XnbToolContainer >> labelMorph [

	^ labelMorph
]

{
	#category : #layout,
	#'squeak_changestamp' : 'ct 11/29/2025 01:44'
}
XnbToolContainer >> layoutChanged [

	super layoutChanged.
	
	self workspace ifNotNil: [:w | w toolContainerLayoutUpdated: self].
]

{
	#category : #'event handling',
	#'squeak_changestamp' : 'ct 11/28/2025 21:40'
}
XnbToolContainer >> mouseEnter: anEvent [

	Cursor normal show.
	self owningPluggableTextMorph mouseEnter: anEvent.
]

{
	#category : #initialization,
	#'squeak_changestamp' : 'ct 11/28/2025 22:02'
}
XnbToolContainer >> newButton [

	^ SystemWindowButton new
		beTransparent;
		target: self;
		useSquareCorners;
		borderWidth: 0;
		extent: SystemWindow boxExtent;
		yourself
]

{
	#category : #initialization,
	#'squeak_changestamp' : 'ct 12/19/2025 00:53'
}
XnbToolContainer >> newCloseButton [

	^ self newButton
		labelGraphic: SystemWindow closeBoxImage scaleIconToDisplay;
		balloonText: 'Delete this tool';
		actionSelector: #closeButtonHit;
		yourself
]

{
	#category : #initialization,
	#'squeak_changestamp' : 'ct 11/29/2025 01:22'
}
XnbToolContainer >> newExecutionHint [

	executionHint := Morph new
		beTransparent;
		changeTableLayout;
		listDirection: #leftToRight;
		hResizing: #spaceFill; vResizing: #shrinkWrap;
		layoutInset: (2 px @ 2 px corner: 2 px @ 0);
		addMorph: (Morph new color: Color gray; height: 1 px; hResizing: #spaceFill);
		addMorph:  (' executed until here ' asStringMorph color: Color gray);
		addMorph: (Morph new color: Color gray; height: 1 px; hResizing: #spaceFill);
		yourself.
	self updateExecutionHint.
	^ executionHint
]

{
	#category : #initialization,
	#'squeak_changestamp' : 'ct 11/29/2025 01:05'
}
XnbToolContainer >> newHeaderMorph [

	| header |
	header := (AlignmentMorph newSpacer: Color transparent)
		vResizing: #shrinkWrap;
		cellPositioning: #center;
		layoutInset: -1 px @ 2 px;
		yourself.
	header
		addMorphBack: self newCloseButton;
		addMorphBack: self newRunButton;
		addMorphBack: self newHeaderSpacer;
		addMorphBack: (labelMorph := self newLabelMorph);
		addMorphBack: self newHeaderSpacer;
		addMorphBack: self newSpawnButton.
	^ header
]

{
	#category : #initialization,
	#'squeak_changestamp' : 'ct 11/25/2025 20:32'
}
XnbToolContainer >> newHeaderSpacer [

	^ (Morph new extent: AbstractResizerMorph gripThickness @ 0)
]

{
	#category : #initialization,
	#'squeak_changestamp' : 'ct 11/28/2025 21:59'
}
XnbToolContainer >> newLabelMorph [

	^ self toolLabel asStringMorph
		hResizing: #spaceFill;
		yourself
]

{
	#category : #accessing,
	#'squeak_changestamp' : 'ct 12/27/2025 20:00'
}
XnbToolContainer >> newObject: anObject [

	| oldLabel |
	(self toolModel isKindOf: XnbPlaceholderToolModel) ifTrue: [self toolMorph delete].
	
	oldLabel := self toolLabel.
	self object: anObject.
	self toolLabel = oldLabel ifFalse:
		[self notify: 'Cell returned a different result'].
]

{
	#category : #initialization,
	#'squeak_changestamp' : 'ct 12/19/2025 00:53'
}
XnbToolContainer >> newRunButton [

	| image original |
	original := SystemWindow menuBoxImage.
	image := original rotateBy: -90.
	image := image copy: ((image width - original width // 2) @ (image height - original height / 2) ceiling extent: original extent).
	^ runButton := self newButton
		labelGraphic: image scaleIconToDisplay;
		balloonText: 'Rerun notebook until here';
		actionSelector: #run;
		yourself
]

{
	#category : #initialization,
	#'squeak_changestamp' : 'ct 12/19/2025 00:53'
}
XnbToolContainer >> newSpawnButton [

	"| image original |
	original := SystemWindow menuBoxImage.
	image := original rotateBy: -135.
	image := image copy: ((image extent - original extent) // 2 extent: original extent)."
	^ self newButton
		labelGraphic: "image"SystemWindow expandBoxImage scaleIconToDisplay;
		balloonText: 'Spawn another instance of this tool';
		actionSelector: #spawn;
		yourself
]

{
	#category : #accessing,
	#'squeak_changestamp' : 'ct 11/28/2025 22:29'
}
XnbToolContainer >> object: anObject [

	self toolMorph: (self toolMorphFor: anObject).
]

{
	#category : #layout,
	#'squeak_changestamp' : 'ct 11/28/2025 23:36'
}
XnbToolContainer >> ownerChanged [

	super ownerChanged.
	self width: (self owningTextMorph container width
		clampHigh: (World width max: Display width) "avoid huge morph that freezes the image when accidentally dragging out text from the workspace").
]

{
	#category : #accessing,
	#'squeak_changestamp' : 'ct 11/25/2025 19:45'
}
XnbToolContainer >> owningPluggableTextMorph [

	^ self owningTextMorph owner owner
]

{
	#category : #accessing,
	#'squeak_changestamp' : 'ct 11/25/2025 19:45'
}
XnbToolContainer >> owningTextMorph [

	^ self owner
]

{
	#category : #accessing,
	#'squeak_changestamp' : 'ct 11/28/2025 21:55'
}
XnbToolContainer >> panelColor [

	^ (self toolModel ifNil: [Model new]) windowColorToUse
]

{
	#category : #accessing,
	#'squeak_changestamp' : 'ct 11/28/2025 21:54'
}
XnbToolContainer >> panelMorph [

	^ panelMorph
]

{
	#category : #printing,
	#'squeak_changestamp' : 'ct 11/29/2025 01:58'
}
XnbToolContainer >> printOn: aStream [

	super printOn: aStream.
	aStream
		nextPut: $<;
		nextPutAll: self toolLabel;
		nextPut: $>.
]

{
	#category : #commands,
	#'squeak_changestamp' : 'ct 11/28/2025 22:53'
}
XnbToolContainer >> run [

	self workspace rerunUpTo: self.
]

{
	#category : #commands,
	#'squeak_changestamp' : 'ct 12/2/2025 01:56'
}
XnbToolContainer >> spawn [

	(self isStaticTool not ==> [self isLastExecuted]) ifFalse:
		[(Project uiManager
			chooseOptionFromLabeledValues:
				(OrderedDictionary new
					at: 'Rerun' put: [self run];
					at: 'Ignore' put: [];
					at: 'Cancel' put: nil;
					yourself)
			title: 'Artifact may have been changed by later cells. Rerun notebook until here?')
				ifNil: [^ self]
				ifNotNil: #value].
	self toolMorph model xnbSpawn.
]

{
	#category : #accessing,
	#'squeak_changestamp' : 'ct 11/29/2025 01:14'
}
XnbToolContainer >> toolFactory [

	^ self workspace toolFactory
]

{
	#category : #accessing,
	#'squeak_changestamp' : 'ct 11/28/2025 22:00'
}
XnbToolContainer >> toolLabel [

	^ (self toolModel ifNil: [^ '']) labelString
		ifNil: [self toolModel class name]
]

{
	#category : #accessing,
	#'squeak_changestamp' : 'ct 11/28/2025 21:51'
}
XnbToolContainer >> toolModel [

	^ self toolMorph ifNotNil: [:m | m model]
]

{
	#category : #accessing,
	#'squeak_changestamp' : 'ct 11/25/2025 19:28'
}
XnbToolContainer >> toolMorph [

	^ toolMorph
]

{
	#category : #accessing,
	#'squeak_changestamp' : 'ct 12/27/2025 20:09'
}
XnbToolContainer >> toolMorph: aMorph [

	toolMorph ifNotNil:
		[self removeMorph: toolMorph].
	
	toolMorph ifNil:
		[self height: (aMorph height clampLow: ((aMorph model isKindOf: XnbPlaceholderToolModel) ifTrue: [0 px] ifFalse: [100 px])) + (executionHint visible ifTrue: [executionHint height] ifFalse: [0]) + (self fullBounds height - panelMorph height + panelMorph layoutInset top + panelMorph layoutInset bottom + panelMorph cellGap "+ 4 px")].
	
	toolMorph := aMorph.
	
	self panelMorph color: self panelColor.
	self labelMorph contents: self toolLabel.
	"runButton visible: self isStaticTool not; disableLayout: self isStaticTool."
	self toolMorph hResizing: #spaceFill; vResizing: #spaceFill.
	self panelMorph addMorph: self toolMorph fullFrame: LayoutFrame fullFrame.
	self adoptPaneColor: self panelMorph color.
	
	"((self toolModel respondsTo: #where) and: [self toolModel isNotifier not]) ifTrue:
		[self toolModel future where]."
]

{
	#category : #private,
	#'squeak_changestamp' : 'ct 11/28/2025 22:32'
}
XnbToolContainer >> toolMorphFor: anObject [

	^ anObject copy asXnbMorphFor: self toolFactory
]

{
	#category : #updating,
	#'squeak_changestamp' : 'ct 11/29/2025 02:07'
}
XnbToolContainer >> updateExecutionHint [

	| isLast |
	isLast := self isLastExecuted.
	isLast = executionHint visible ifTrue: [^ self].
	isLast
		ifTrue: [executionHint show; disableLayout: false]
		ifFalse: [executionHint hide; disableLayout: true].
	self height: self height + (isLast ifTrue: [executionHint height] ifFalse: [executionHint height negated]).
]

{
	#category : #accessing,
	#'squeak_changestamp' : 'ct 11/29/2025 01:14'
}
XnbToolContainer >> workspace [

	^ workspace
]

{
	#category : #accessing,
	#'squeak_changestamp' : 'ct 11/29/2025 01:23'
}
XnbToolContainer >> workspace: aWorkspace [

	workspace := aWorkspace.
	self workspace when: #lastExecutedToolContainer send: #updateExecutionHint to: self.
]
