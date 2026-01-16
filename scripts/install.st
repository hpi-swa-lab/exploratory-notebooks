"Install ExploratoryNotebooks"
workspacePath := [| dir |
	dir := (Smalltalk globals at: #CIPrepareImageDirectory) directoryEntry.
	[(dir / '.project') exists] whileFalse: [
		dir = (dir := dir containingDirectory) ifTrue: [
			self error: 'repository not found']].
	dir fullName] value.
Transcript showln: ('Installing ExploratoryNotebooks from {1}... ' format: {workspacePath}).
Metacello new
	baseline: 'ExploratoryNotebooks';
	repository: 'filetree://' , workspacePath , '/packages';
	load.
Transcript showln: 'ExploratoryNotebooks was installed'.
