"Install ExploratoryNotebooks"
workspacePath := [| dir |
	dir := (Smalltalk globals at: #CIPrepareImageDirectory) directoryEntry.
	[(dir / '.project') exists] whileFalse: [
		dir = (dir := dir containingDirectory) ifTrue: [
			self error: 'repository not found']].
	dir fullName] value.

Transcript showln: 'Installing Metacello...'.
Installer ensureRecentMetacello.
Transcript showln: 'Metacello was installed.'.

Transcript showln: 'Installing Tonel...'.
[(Smalltalk classNamed: #MCTonelMissing) signal] valueSupplyingAnswer: true.
Transcript showln: 'Tonel was installed.'.

Transcript showln: ('Installing ExploratoryNotebooks from {1}... ' format: {workspacePath}).
Metacello new
	baseline: 'ExploratoryNotebooks';
	repository: 'tonel://' , workspacePath , '/squeak';
	load.
Transcript showln: 'ExploratoryNotebooks was installed'.
