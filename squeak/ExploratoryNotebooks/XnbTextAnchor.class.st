Class {
	#name : #XnbTextAnchor,
	#superclass : #TextAnchor,
	#category : #ExploratoryNotebooks
}

{
	#category : #html,
	#'squeak_changestamp' : 'ct 1/16/2026 20:36'
}
XnbTextAnchor >> closeHtmlOn: aHtmlReadWriter [ 

	aHtmlReadWriter nextPutAll: '</ExploratoryNotebook>'.
]

{
	#category : #html,
	#'squeak_changestamp' : 'ct 12/28/2025 00:39'
}
XnbTextAnchor >> openHtmlOn: aHtmlReadWriter [ 

	| imageData |
	imageData := (ByteArray streamContents: [:stream |
		PNGReadWriter putForm: self anchoredMorph imageForm onStream: stream])
			base64Encoded.
	
	aHtmlReadWriter nextPutAll:
		('<ExploratoryNotebook xnb-data="{1}"><img src="data:image/png;base64,{2}" />' format:
			{self anchoredMorph jsonState asJsonString escapeEntities.
			imageData}).
]
