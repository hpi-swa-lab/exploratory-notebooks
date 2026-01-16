Class {
	#name : #BaselineOfExploratoryNotebooks,
	#superclass : #BaselineOf,
	#category : #BaselineOfExploratoryNotebooks
}

{
	#category : #baseline,
	#'squeak_changestamp' : 'ct 1/13/2026 01:16'
}
BaselineOfExploratoryNotebooks >> baseline: spec [
	<baseline>

	spec for: #common do: [
		"dependencies"
		spec
			baseline: 'CtAppFramework' with:
				[spec repository: 'github://LinqLover/squeak-appframework:main'].
		
		"packages"
		spec
			package: 'ExploratoryNotebooks';
			package: 'ExploratoryNotebooksProxies' with:
				[spec preLoadDoIt: #installProxyPreviewDependencies].
		
		"groups"
		spec
			group: #minimal with: #('ExploratoryNotebooks');
			group: #recommended with: #('CtAppFramework');
			group: #proxies with: #('ExploratoryNotebooksProxies');
			group: #default with: #(minimal recommended);
			group: #experimental with: #(default proxies)].
]

{
	#category : #scripts,
	#'squeak_changestamp' : 'ct 3/22/2021 21:34'
}
BaselineOfExploratoryNotebooks >> depChangeset: urlString [

	| url response |
	url := Url absoluteFromText: urlString.
	response := WebClient httpGet: url downloadUrl.
	response isSuccess ifFalse: [
		self error: ('Cannot load changeset from {1}: {2}'
			format: {urlString. response status})].
	^ url fileName -> [
		| contents |
		contents := response content.
		contents readStream fileIn]
]

{
	#category : #scripts,
	#'squeak_changestamp' : 'ct 1/16/2026 19:55'
}
BaselineOfExploratoryNotebooks >> installProxyPreviewDependencies [

	| dependencies |
	self
		flag: #workaround; "As soon as the versions listed here get merged, this should be removed"
		flag: #duplication. "See BaselineOfTelegramBot>>#installPreviewDependencies"
	
	dependencies := {
		"#resolveProxy for primitives"
		self depChangeset: 'https://lists.squeakfoundation.org/archives/list/squeak-dev@lists.squeakfoundation.org/message/XWYSCEVPE3UZCAFXGALMAECNJ3QFPM3G/attachment/4/resolveProxy.41.cs'.
	}.
	
	dependencies
		do: [:dep | dep value value]
		displayingProgress: [:dep | 'Installing preview dependencies... ({1})' format: {dep key}].
]

{
	#category : #accessing,
	#'squeak_changestamp' : 'ct 5/26/2021 15:29'
}
BaselineOfExploratoryNotebooks >> projectClass [

	^ (self environment classNamed: #MetacelloCypressBaselineProject) ifNil: [super projectClass]
]
