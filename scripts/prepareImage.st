| workspacePath oldArchivePath |
((Smalltalk globals at: #CIPrepareImageDirectory) directoryEntry / 'install.st') readStream fileIn.

"Install SqueakJS Bridge"
Transcript showln: 'Installing SqueakJS Bridge...'.
Metacello new
	baseline: 'SqueakJS';
	repository: 'github://codefrau/SqueakJS:main/utils';
	load: 'JSBridge-Core'.
Transcript showln: 'SqueakJS Bridge was installed.'.

"Prevent default AutoStart"
Smalltalk removeFromStartUpList: AutoStart.

"Remove default welcome contents"
(World submorphOfClass: PreferenceWizardMorph) ifNotNil: #delete.
TheWorldMainDockingBar instance closeAllWindows.
