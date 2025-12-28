Extension { #name : #Context }

{
	#category : #'*ExploratoryNotebooks-testing',
	#'squeak_changestamp' : 'ct 11/25/2025 22:30'
}
Context >> xnbWillSend: selector [

	^ self willReallySend and:
		[((self method abstractBytecodeMessageAt: self pc) arguments at: 1) = selector]
]
