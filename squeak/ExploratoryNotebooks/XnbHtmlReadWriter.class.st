Class {
	#name : #XnbHtmlReadWriter,
	#superclass : #HtmlReadWriter,
	#instVars : [
		'workspace'
	],
	#category : #ExploratoryNotebooks
}

{
	#category : #mapping,
	#'squeak_changestamp' : 'ct 12/28/2025 00:40'
}
XnbHtmlReadWriter >> mapTagToAttribute: aTag [

	(self hasTag: aTag name: '<ExploratoryNotebook') ifTrue: [^ self mapXnbTag: aTag].
	
	^ super mapTagToAttribute: aTag
]

{
	#category : #mapping,
	#'squeak_changestamp' : 'ct 12/28/2025 01:11'
}
XnbHtmlReadWriter >> mapXnbTag: aTag [

	| dataString data container |
	dataString := (self searchTag: aTag forAttribute: 'xnb-data') ifNil: [^ super mapImgTag: aTag].
	data := dataString parseAsJson.
	
	container := XnbToolContainer forWorkspace: self workspace.
	container buildWidgets.
	container bePlaceholderWithData: data.
	^ {XnbTextAnchor new anchoredMorph: container}
]

{
	#category : #accessing,
	#'squeak_changestamp' : 'ct 12/27/2025 20:49'
}
XnbHtmlReadWriter >> nextNotebook [

	^ self nextWorkspace notebook
]

{
	#category : #accessing,
	#'squeak_changestamp' : 'ct 12/27/2025 21:14'
}
XnbHtmlReadWriter >> nextWorkspace [

	workspace := nil.
	^ self workspace
		textContents: self nextText;
		yourself
]

{
	#category : #mapping,
	#'squeak_changestamp' : 'ct 12/28/2025 01:16'
}
XnbHtmlReadWriter >> processEndTag: tagName eagerly: eagerly [

	| imgAnchor xnbAnchor |
	tagName = 'ExploratoryNotebook' asLowercase ifFalse: [^ super processEndTag: tagName eagerly: eagerly].
	
	xnbAnchor := runStack top first
		detect: [:attrib | attrib isKindOf: XnbTextAnchor]
		ifNone: [^ self].
	imgAnchor := runArray last
		detect: [:attrib | (attrib isKindOf: TextAnchor) and: [attrib ~~ xnbAnchor]]
		ifNone: [^ self].
	runArray atLast: 1 put: (runArray last copyWithout: imgAnchor).
	xnbAnchor anchoredMorph toolMorph firstSubmorph image:
		(imgAnchor anchoredMorph copy: (xnbAnchor anchoredMorph toolMorph removeProperty: #toolBounds)).
]

{
	#category : #private,
	#'squeak_changestamp' : 'ct 12/27/2025 21:13'
}
XnbHtmlReadWriter >> workspace [

	^ workspace ifNil:
		[workspace := XnbWorkspace new
			shouldStyle: true;
			yourself]
]
