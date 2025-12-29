Class {
	#name : #BaselineOfExploratoryNotebooks,
	#superclass : #BaselineOf,
	#category : #BaselineOfExploratoryNotebooks
}

{
	#category : #baseline,
	#'squeak_changestamp' : 'ct 12/29/2025 04:03'
}
BaselineOfExploratoryNotebooks >> baseline: spec [
	<baseline>

	spec for: #common do: [
		"dependencies"
		spec
			baseline: 'CtAppFramework' with:
				[spec repository: 'github://LinqLover/squeak-appframework:main'].
		
		"packages"
		spec package: 'ExploratoryNotebooks'.
		
		"groups"
		spec
			group: #minimal with: #('ExploratoryNotebooks');
			group: #recommended with: #('CtAppFramework');
			group: #default with: #(minimal recommended)].
]

{
	#category : #accessing,
	#'squeak_changestamp' : 'ct 5/26/2021 15:29'
}
BaselineOfExploratoryNotebooks >> projectClass [

	^ (self environment classNamed: #MetacelloCypressBaselineProject) ifNil: [super projectClass]
]
