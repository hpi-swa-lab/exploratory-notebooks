Extension { #name : #TextEditor }

{
	#category : #'*ExploratoryNotebooks-do-its-pseudo-override',
	#'squeak_changestamp' : 'ct 1/8/2026 04:33'
}
TextEditor >> basicPrintItTextFor: anObject [

	self flag: #todo. "mt: Maybe reserve highlights for non-primitive structures only? Maybe skip ByteString, ByteSymbol, Number, Boolean, UndefinedObject? See discussion here: http://forum.world.st/The-Inbox-Morphic-ct-1586-mcz-tp5106774p5129065.html"
	
	^ self class interactivePrintIt
		ifFalse: [anObject printString]
		ifTrue: [Text string: anObject printString attribute: (TextInspectIt on: anObject)]
]

{
	#category : #'*ExploratoryNotebooks-do-its-override',
	#'squeak_changestamp' : 'ct 1/13/2026 19:36'
}
TextEditor >> debugIt [

	| receiver context helperProcess |
	self lineSelectAndEmptyCheck: [^self].
	
	(model respondsTo: #debugExpression:requestor:)
		ifTrue: [^ model perform: #debugExpression:requestor: with: self selection with: self].
	(model respondsTo: #debugExpression:)
		ifTrue: [^ model perform: #debugExpression: with: self selection].
	
	receiver := (model respondsTo: #doItReceiver) 
		ifTrue: [model doItReceiver]
		ifFalse: [nil].
		
	context := (model respondsTo: #doItContext) 
		ifTrue: [model doItContext]
		ifFalse: [nil].

	(self compileSelectionFor: receiver in: context) ifNotNil: [:doItMethod |
		helperProcess := context
			ifNil: [self assert: doItMethod selector = #DoIt.
				Process forMethod: doItMethod receiver: receiver]
			ifNotNil: [self assert: doItMethod selector = #DoItIn:.
				Process forMethod: doItMethod receiver: receiver arguments: {context}].
		self flag: #moveUpstream.
		(model respondsTo: #debugIt:process:requestor:)
			ifTrue: [^ model debugIt: self selection process: helperProcess requestor: self].
		(model respondsTo: #debugIt:process:)
			ifTrue: [^ model debugIt: self selection process: helperProcess].
		helperProcess debugWithTitle: 'Debug it' translated].
]

{
	#category : #'*ExploratoryNotebooks-do-its-override',
	#'squeak_changestamp' : 'ct 1/13/2026 19:28'
}
TextEditor >> printItTextFor: anObject [

	self flag: #moveUpstream.
	
	(model respondsTo: #printItTextFor:expression:requestor:) ifTrue: [
		^ model perform: #printItTextFor:expression:requestor: with: anObject with: self selection with: self].
	(model respondsTo: #printItTextFor:expression:) ifTrue: [
		^ model perform: #printItTextFor:expression: with: anObject with: self selection].
	(model respondsTo: #printItTextFor:) ifTrue: [
		^ model perform: #printItTextFor: with: anObject].
	
	^ self basicPrintItTextFor: anObject
]
