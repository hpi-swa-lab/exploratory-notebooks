| path regex blobId blob content |
Smalltalk removeFromStartUpList: AutoStart.

path := Smalltalk documentPath
	ifNil: [^ XnbNotebook openExample].

"webviewer"
regex := '^js-blob\:(.+)$' asRegex.
self assert: (regex matches: path).
blobId := regex subexpression: 2.
blob := JS Reflect get: JS blobs key: blobId.
content := (JS await: blob text) asString.

"JSObjectProxy unloadAndDestroyBridge."
[Smalltalk unloadModule: 'JavaScriptPlugin'.
JS squeakJsDestroyBridge call.
self assert: [[JS globalThis. false] on: Error do: [:ex | true]]] value.

(XnbNotebook fromHtmlStream: content readStream) open.
