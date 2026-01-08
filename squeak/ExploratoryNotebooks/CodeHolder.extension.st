Extension { #name : #CodeHolder }

{
	#category : #'*ExploratoryNotebooks',
	#'squeak_changestamp' : 'ct 1/8/2026 04:33'
}
CodeHolder >> asXnbMorphFor: aToolFactory [

	| builder morph |
	builder := ToolBuilder default.
	morph := builder build: ((self buildCodePaneWith: builder) model: self).
	^ morph
]

{
	#category : #'*ExploratoryNotebooks-testing',
	#'squeak_changestamp' : 'ct 12/28/2025 01:58'
}
CodeHolder >> isStaticXnbTool [

	^ self class == thisContext method methodClass
]

{
	#category : #'*ExploratoryNotebooks',
	#'squeak_changestamp' : 'ct 11/25/2025 20:26'
}
CodeHolder >> xnbSpawn [

	^ ToolSet
		browse: self selectedClassOrMetaClass
		selector: self selectedMessageName
]

{
	#category : #'*ExploratoryNotebooks',
	#'squeak_changestamp' : 'ct 12/2/2025 01:35'
}
CodeHolder >> xnbTargetObject [

	^ self selectedMessageName ifNotNil:
			[ : selector |
			(self selectedClassOrMetaClass
				ifNil: [ selector asString ]
				ifNotNil: [ : cls | (cls >> selector)  ]) ]
]
