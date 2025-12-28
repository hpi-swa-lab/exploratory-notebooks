Extension { #name : #Browser }

{
	#category : #'*ExploratoryNotebooks',
	#'squeak_changestamp' : 'ct 12/2/2025 01:29'
}
Browser >> xnbAddToNotebook [

	XnbTracker recordStaticTool: self.
]

{
	#category : #'*ExploratoryNotebooks',
	#'squeak_changestamp' : 'ct 12/2/2025 01:46'
}
Browser >> xnbToolCode [

	^ self selectedMessageName ifNotNil:
			[ : selector | 
			(self selectedClassOrMetaClass
				ifNil: [ selector asString ]
				ifNotNil: [ : cls | (cls >> selector) reference ]) ]
]
