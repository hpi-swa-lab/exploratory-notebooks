Extension { #name : #SystemWindow }

{
	#category : #'*ExploratoryNotebooks-custom boxes-initialization(-pseudo)-override',
	#'squeak_changestamp' : 'ct 12/28/2025 03:22'
}
SystemWindow >> addCustomBoxes [

	self flag: #moveUpstream.
	
	labelArea ifNil: [^ self]. "No menu if no label area"
	
	(self removeProperty: #customBoxes) ifNotNil: [:boxes |
		boxes removeAllSuchThat: [:box | box delete. true]].
	
	self customBoxSelectors
		do: [:selector |
			| box |
			box := self perform: selector.
			box layoutFrame: self class menuBoxFrame.
			labelArea addMorphBack: box.
			self assureCustomBoxes addLast: box];
		ifNotEmpty:
			[| separator |
			separator := Morph new extent: self class borderWidth * 2 @ 0.
			labelArea addMorphBack: separator].
]

{
	#category : #'*ExploratoryNotebooks-custom boxes-initialization(-pseudo)-override',
	#'squeak_changestamp' : 'ct 12/28/2025 03:18'
}
SystemWindow >> assureCustomBoxes [

	^ self valueOfProperty: #customBoxes ifAbsentPut: [OrderedCollection new]
]

{
	#category : #'*ExploratoryNotebooks-custom boxes-initialization(-pseudo)-override',
	#'squeak_changestamp' : 'ct 12/28/2025 03:17'
}
SystemWindow >> customBoxSelectors [

	| pragmas |
	pragmas := Pragma allNamed: #customBox from: self class to: thisContext methodClass sortedUsing: #halt.
	^ pragmas collect: [:pragma | pragma selector]
]

{
	#category : #'*ExploratoryNotebooks-custom boxes-initialization(-pseudo)-override',
	#'squeak_changestamp' : 'ct 12/28/2025 03:19'
}
SystemWindow >> customBoxes [

	^ self valueOfProperty: #customBoxes ifAbsent: [#()]
]

{
	#category : #'*ExploratoryNotebooks-custom boxes-top window-override',
	#'squeak_changestamp' : 'ct 12/28/2025 03:19'
}
SystemWindow >> dimWindowButtons [
	{closeBox. collapseBox. menuBox. expandBox} , self customBoxes
		do: [:b | b ifNotNil: [b dim]]
]

{
	#category : #'*ExploratoryNotebooks-custom boxes-initialization(-pseudo)-override',
	#'squeak_changestamp' : 'ct 12/28/2025 03:11'
}
SystemWindow >> initializeLabelArea [
	"Initialize the label area (titlebar) for the window."
	
	labelString ifNil: [labelString := 'Untitled Window'].
	label := StringMorph new
				contents: labelString;
				font: (self userInterfaceTheme titleFont ifNil: [TextStyle defaultFont]);
				yourself.
			"Add collapse box so #labelHeight will work"
			collapseBox := self createCollapseBox.
			stripes := Array
						with: (RectangleMorph newBounds: bounds)
						with: (RectangleMorph newBounds: bounds).
			"see extent:"
			self addLabelArea.
			self setLabelWidgetAllowance.
			self addCloseBox.
			self class moveMenuButtonRight 
				ifTrue: [self addLabel. self addCustomBoxes. self addMenuControl]
				ifFalse: [self addMenuControl. self addLabel. self addCustomBoxes].
			self addExpandBox.
			labelArea addMorphBack: collapseBox.
			self setFramesForLabelArea.
			Preferences noviceMode
				ifTrue: [closeBox
						ifNotNil: [closeBox setBalloonText: 'close window'].
					menuBox
						ifNotNil: [menuBox setBalloonText: 'window menu'].
					collapseBox
						ifNotNil: [collapseBox setBalloonText: 'collapse/expand window']].

]

{
	#category : #'*ExploratoryNotebooks-custom boxes-initialization(-pseudo)-override',
	#'squeak_changestamp' : 'ct 12/28/2025 03:15'
}
SystemWindow >> model: anObject [

	super model: anObject.
	self paneColor: nil.
	self triggerEvent: #modelChanged.
]

{
	#category : #'*ExploratoryNotebooks-custom boxes-top window-override',
	#'squeak_changestamp' : 'ct 12/28/2025 03:19'
}
SystemWindow >> undimWindowButtons [
	{closeBox. collapseBox. menuBox. expandBox} , self customBoxes
		do: [:b | b ifNotNil: [b undim]]
]

{
	#category : #'*ExploratoryNotebooks',
	#'squeak_changestamp' : 'ct 12/28/2025 03:15'
}
SystemWindow >> xnbCreateRecordBox [
	<customBox>

	| box |
	box := (self createBox: MenuIcons smallCopyIcon)
		actionSelector: #xnbRecord;
		balloonText: 'add to notebook' translated;
		yourself.
	self setProperty: #xnbRecordBox toValue: box.
	self xnbUpdateRecordBox.
	XnbTracker when: #isTracking send: #xnbUpdateRecordBox to: self.
	self when: #modelChanged send: #xnbUpdateRecordBox to: self.
	^ box
]

{
	#category : #'*ExploratoryNotebooks',
	#'squeak_changestamp' : 'ct 12/1/2025 21:08'
}
SystemWindow >> xnbRecord [

	^ self model xnbAddToNotebook
]

{
	#category : #'*ExploratoryNotebooks',
	#'squeak_changestamp' : 'ct 12/2/2025 01:32'
}
SystemWindow >> xnbUpdateRecordBox [

	| box enabled |
	box := self valueOfProperty: #xnbRecordBox.
	enabled := XnbTracker isTracking and: [self model respondsTo: #xnbAddToNotebook].
	box
		visible: enabled;
		disableLayout: enabled not.
]
