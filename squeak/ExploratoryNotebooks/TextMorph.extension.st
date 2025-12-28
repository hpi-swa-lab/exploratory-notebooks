Extension { #name : #TextMorph }

{
	#category : #'*ExploratoryNotebooks-accessing',
	#'squeak_changestamp' : 'ct 12/28/2025 03:03'
}
TextMorph >> xnbFixUpEmbeddedMorphsAround: aBlock [

	| oldText embeddedMorphs oldSelection result |
	self flag: #workaround. "embedded morphs inserted via manual text modification (e.g. during print-its) are not added to the receiver by default"
	
	oldText := self text copy.
	
	result := aBlock value.
	
	oldText ifNotNil: [(embeddedMorphs := oldText embeddedMorphs)
			ifNotNil: 
				[self removeAllMorphsIn: embeddedMorphs.
				embeddedMorphs do: [:m | m delete]]].

	oldSelection := editor ifNotNil: [:ed | ed selectionInterval].
	
	"add all morphs off the visible region; they'll be moved into the right 
	place when they become visible. (this can make the scrollable area too 
	large, though)"
	text embeddedMorphs do: 
		[:m | 
		self addMorph: m.
		m position: -1000 @ 0].
	
	oldSelection ifNotNil: [:sel | self selectFrom: sel first to: sel last].
	
	^ result
]

{
	#category : #'*ExploratoryNotebooks-accessing',
	#'squeak_changestamp' : 'ct 12/28/2025 03:06'
}
TextMorph >> xnbFixUpEmbeddedMorphsFrom: oldText [

	| embeddedMorphs |
	self flag: #workaround. "embedded morphs inserted via manual text modification (e.g. during print-its) are not added to the receiver by default"
	
	oldText ifNotNil: [(embeddedMorphs := oldText embeddedMorphs)
			ifNotNil: 
				[self removeAllMorphsIn: embeddedMorphs.
				embeddedMorphs do: [:m | m delete]]].

	"add all morphs off the visible region; they'll be moved into the right 
	place when they become visible. (this can make the scrollable area too 
	large, though)"
	text embeddedMorphs do: 
		[:m | 
		self addMorph: m.
		m position: -1000 @ 0].
]
