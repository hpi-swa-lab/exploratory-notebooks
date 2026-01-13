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
