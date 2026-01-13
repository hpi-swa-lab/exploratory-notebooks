Extension { #name : #PluggableTreeMorph }

{
	#category : #'*ExploratoryNotebooks-selection-override',
	#'squeak_changestamp' : 'ct 1/13/2026 20:36'
}
PluggableTreeMorph >> currentSelectionItem: itemOrNil [
	"Variation of #selection: to ensure identity check for model data. See #updateSelection."
		
	| i |
	itemOrNil ifNil: [^ self selectionIndex: 0].
	i := self items findFirst: [:m | m complexContents item xxxxnbResolveTrackingProxy == itemOrNil xxxxnbResolveTrackingProxy].
	self selectionIndex: i
]
