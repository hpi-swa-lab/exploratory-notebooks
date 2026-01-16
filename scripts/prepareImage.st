| workspacePath oldArchivePath |
((Smalltalk globals at: #CIPrepareImageDirectory) directoryEntry / 'install.st') readStream fileIn.

"Remove default welcome contents"
(World submorphOfClass: PreferenceWizardMorph) ifNotNil: #delete.
TheWorldMainDockingBar instance closeAllWindows.
