Extension { #name : #TextEditor }

{
	#category : #'*ExploratoryNotebooks-do-its-pseudo-override',
	#'squeak_changestamp' : 'ct 12/28/2025 02:58'
}
TextEditor >> basicPrintItTextFor: anObject [

	| string |
	self flag: #todo. "mt: Maybe reserve highlights for non-primitive structures only? Maybe skip ByteString, ByteSymbol, Number, Boolean, UndefinedObject? See discussion here: http://forum.world.st/The-Inbox-Morphic-ct-1586-mcz-tp5106774p5129065.html"
	
	self flag: #doNotCommit. "revert to older version!"
	(self debuggerPrintStringForObject: anObject) ifNotNil: [:stringOrText |
		stringOrText isText ifTrue: [^ stringOrText].
		string := stringOrText].
	string ifNil:
		[string := anObject isInteger
			ifTrue: [anObject storeStringBase: self defaultIntegerBase]
			ifFalse: [anObject printString]].
	^ self class interactivePrintIt
		ifFalse: [string]
		ifTrue: [Text string: string attribute: (TextInspectIt on: anObject)]
]

{
	#category : #'*ExploratoryNotebooks-do-its-override',
	#'squeak_changestamp' : 'ct 12/28/2025 02:58'
}
TextEditor >> printItTextFor: anObject [

	self flag: #moveUpstream.
	
	(model respondsTo: #printItTextFor:result:requestor:) ifTrue: [
		^ model perform: #printItTextFor:result:requestor: with: self selection with: anObject with: self].
	(model respondsTo: #printItTextFor:result:) ifTrue: [
		^ model perform: #printItTextFor:result: with: self selection with: anObject].
	(model respondsTo: #printItTextFor:) ifTrue: [
		^ model perform: #printItTextFor: with: self selection].
	
	^ self basicPrintItTextFor: anObject
]
