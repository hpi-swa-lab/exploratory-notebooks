Class {
	#name : #XnbNotebook,
	#superclass : #Object,
	#instVars : [
		'text'
	],
	#category : #ExploratoryNotebooks
}

{
	#category : #'file services',
	#'squeak_changestamp' : 'ct 12/27/2025 20:46'
}
XnbNotebook class >> fileReaderServicesForFile: fullName suffix: suffix [

	^ (fullName endsWith: '.xnb.html')
		ifTrue: [self services]
		ifFalse: [#()]
]

{
	#category : #loading,
	#'squeak_changestamp' : 'ct 12/28/2025 01:16'
}
XnbNotebook class >> fromFileNamed: fileName [

	^ FileStream readOnlyFileNamed: fileName do: [:stream |
		| notebook |
		notebook := self fromHtmlStream: stream.
		self assert: stream atEnd.
		notebook]
]

{
	#category : #loading,
	#'squeak_changestamp' : 'ct 12/28/2025 01:13'
}
XnbNotebook class >> fromHtmlStream: aStream [

	^ (XnbHtmlReadWriter on: aStream)
		nextNotebook
]

{
	#category : #'class initialization',
	#'squeak_changestamp' : 'ct 12/27/2025 20:48'
}
XnbNotebook class >> initialize [

	FileServices registerFileReader: self.
]

{
	#category : #loading,
	#'squeak_changestamp' : 'ct 12/27/2025 20:46'
}
XnbNotebook class >> openFromFileNamed: fileName [

	^ (self fromFileNamed: fileName) open
]

{
	#category : #'file services',
	#'squeak_changestamp' : 'ct 12/27/2025 20:46'
}
XnbNotebook class >> serviceOpen [

	^ SimpleServiceEntry
		provider: self
		label: 'open' translated
		selector: #openFromFileNamed:
		description: 'open exploratory notebook' translated
		buttonLabel: 'open' translated
]

{
	#category : #'file services',
	#'squeak_changestamp' : 'ct 12/27/2025 20:46'
}
XnbNotebook class >> services [

	^ {self serviceOpen}
]

{
	#category : #'class initialization',
	#'squeak_changestamp' : 'ct 12/27/2025 20:48'
}
XnbNotebook class >> unload [

	FileServices unregisterFileReader: self.
]

{
	#category : #accessing,
	#'squeak_changestamp' : 'ct 11/29/2025 02:01'
}
XnbNotebook >> cellRangesAfter: startToolContainer to: stopToolContainer do: startStopContainerBlock [
 
	^ self
		cellRangesFrom: startToolContainer
		to: stopToolContainer
		do: [:start :stop :toolContainer |
			toolContainer = startToolContainer ifFalse:
				[startStopContainerBlock value: start value: stop value: toolContainer]]
]

{
	#category : #accessing,
	#'squeak_changestamp' : 'ct 11/28/2025 22:52'
}
XnbNotebook >> cellRangesDo: startStopContainerBlock [
 
	^ self
		cellRangesUpTo: nil
		do: startStopContainerBlock
]

{
	#category : #accessing,
	#'squeak_changestamp' : 'ct 11/29/2025 01:54'
}
XnbNotebook >> cellRangesFrom: startToolContainer to: stopToolContainer do: startStopContainerBlock [
 
	| started start containerIndex stop |
	start := 1.
	started := startToolContainer isNil.
	[(containerIndex := self text indexOf: Character startOfHeader startingAt: start) > 0] whileTrue:
		[| toolContainer |
		stop := containerIndex - 1.
		(stop > start and: [(self text at: stop) = Character cr]) ifTrue:
			[stop := stop - 1].
		toolContainer := ((self text attributesAt: containerIndex) detect: [:attr | attr isKindOf: XnbTextAnchor])
			anchoredMorph.
		(started not and: [toolContainer = startToolContainer]) ifTrue: [started := true].
		started ifTrue:
			[startStopContainerBlock
				value: start
				value: stop
				value: toolContainer].
		toolContainer = stopToolContainer ifTrue: [^ self].
		start := containerIndex + 1.
		(self text at: start) = Character cr ifTrue:
			[start := start + 1]].
	
	started ifFalse: [^ (KeyNotFound key: startToolContainer) signal].
	stopToolContainer ifNotNil: [^ (KeyNotFound key: stopToolContainer) signal].
	
	start <= self text size ifTrue:
		[stop := self text size.
		startStopContainerBlock
			value: start
			value: stop
			value: nil].
]

{
	#category : #accessing,
	#'squeak_changestamp' : 'ct 11/28/2025 22:55'
}
XnbNotebook >> cellRangesUpTo: lastToolContainer do: startStopContainerBlock [
 
	| containerIndex start stop |
	start := 1.
	[(containerIndex := self text indexOf: Character startOfHeader startingAt: start) > 0] whileTrue:
		[| toolContainer |
		stop := containerIndex - 1.
		(stop > start and: [(self text at: stop) = Character cr]) ifTrue:
			[stop := stop - 1].
		toolContainer := ((self text attributesAt: containerIndex) detect: [:attr | attr isKindOf: XnbTextAnchor])
			anchoredMorph.
		startStopContainerBlock
			value: start
			value: stop
			value: toolContainer.
		toolContainer = lastToolContainer ifTrue: [^ self].
		start := containerIndex + 1.
		(self text at: start) = Character cr ifTrue:
			[start := start + 1]].
	
	lastToolContainer ifNotNil: [^ (KeyNotFound key: lastToolContainer) signal].
	
	start <= self text size ifTrue:
		[stop := self text size.
		startStopContainerBlock
			value: start
			value: stop
			value: nil].
]

{
	#category : #accessing,
	#'squeak_changestamp' : 'ct 11/29/2025 01:40'
}
XnbNotebook >> indexOfToolContainer: aToolContainer [

	self cellRangesDo: [:start :stop :toolContainer |
		toolContainer = aToolContainer ifTrue: [^ stop + 2]].
	^ 0
]

{
	#category : #'initialize-release',
	#'squeak_changestamp' : 'ct 11/25/2025 16:24'
}
XnbNotebook >> initialize [

	super initialize.
	
	self text: Text new.
]

{
	#category : #opening,
	#'squeak_changestamp' : 'ct 12/27/2025 20:54'
}
XnbNotebook >> noteWorkspace: aWorkspace [

	self toolContainers do: [:toolContainer |
		toolContainer workspace: aWorkspace].
]

{
	#category : #accessing,
	#'squeak_changestamp' : 'ct 12/1/2025 23:49'
}
XnbNotebook >> numberOfCellRanges [

	| count |
	count := 0.
	self cellRangesDo: [:start :stop :toolContainer |
		count := count + 1].
	^ count
]

{
	#category : #accessing,
	#'squeak_changestamp' : 'ct 12/1/2025 23:50'
}
XnbNotebook >> numberOfToolContainers [

	| count |
	count := 0.
	self cellRangesDo: [:start :stop :toolContainer |
		toolContainer ifNotNil:
			[count := count + 1]].
	^ count
]

{
	#category : #opening,
	#'squeak_changestamp' : 'ct 12/27/2025 20:50'
}
XnbNotebook >> open [

	^ XnbWorkspace new
		notebook: self;
		open
]

{
	#category : #saving,
	#'squeak_changestamp' : 'ct 1/13/2026 20:37'
}
XnbNotebook >> saveOnFileNamed: fileName [

	FileStream newFileNamed: fileName do: [:stream |
		(XnbHtmlReadWriter on: stream)
			breakLines: true;
			nextPutText: self styledText].
]

{
	#category : #accessing,
	#'squeak_changestamp' : 'ct 12/28/2025 01:46'
}
XnbNotebook >> styledText [

	self textStyler ifNotNil: [:styler |
		^ styler styledTextFor: self text].
	^ self text
]

{
	#category : #accessing,
	#'squeak_changestamp' : 'ct 11/25/2025 16:24'
}
XnbNotebook >> text [

	^ text
]

{
	#category : #accessing,
	#'squeak_changestamp' : 'ct 11/25/2025 16:24'
}
XnbNotebook >> text: aText [

	text := aText.
]

{
	#category : #private,
	#'squeak_changestamp' : 'ct 12/28/2025 01:47'
}
XnbNotebook >> textStyler [

	| styler stylerClass |
	stylerClass := (TextStyler for: #Smalltalk) ifNil: [^ nil].
	styler := stylerClass new.
	self toolContainers detect: [:ea | ea workspace notNil] ifFound: [:ea |
		ea workspace aboutToStyle: styler].
	^ styler
]

{
	#category : #accessing,
	#'squeak_changestamp' : 'ct 12/1/2025 23:48'
}
XnbNotebook >> toolContainerAtIndex: anInteger [

	| index |
	index := 0.
	self cellRangesDo: [:start :stop :toolContainer |
		(index := index + 1) = anInteger ifTrue: [^ toolContainer]].
	^ self error
]

{
	#category : #accessing,
	#'squeak_changestamp' : 'ct 12/27/2025 20:53'
}
XnbNotebook >> toolContainers [

	^ Array streamContents: [:stream |
		self cellRangesDo: [:start :stop :toolContainer |
			toolContainer ifNotNil:
				[stream nextPut: toolContainer]]]
]
