Extension { #name : #Character }

{
	#category : #'*ExploratoryNotebooks-converting-override',
	#'squeak_changestamp' : 'ct 1/8/2026 04:40'
}
Character >> escapeEntities [
	self flag: #moveUpstream.
	#($< '&lt;' $> '&gt;' $& '&amp;' $" '&quot;' "needed inside attributes") pairsDo:
		[:k :v |
		self = k ifTrue: [^ v]].
	^ String with: self
]
