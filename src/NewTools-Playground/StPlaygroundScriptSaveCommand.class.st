"
this command save the work of the text in the sytem
"
Class {
	#name : 'StPlaygroundScriptSaveCommand',
	#superclass : 'StPlaygroundCommand',
	#category : 'NewTools-Playground-Command',
	#package : 'NewTools-Playground',
	#tag : 'Command'
}

{ #category : 'default' }
StPlaygroundScriptSaveCommand class >> defaultDescription [
	^ 'save the current text in the system'
]

{ #category : 'accessing' }
StPlaygroundScriptSaveCommand class >> defaultIconName [
	^ #save 
]

{ #category : 'accessing' }
StPlaygroundScriptSaveCommand class >> defaultName [
	^ 'Save' 
]

{ #category : 'accessing' }
StPlaygroundScriptSaveCommand class >> defaultShortcut [
	^ $s command mac 
		| $s control win 
		| $s control unix
]

{ #category : 'executing' }
StPlaygroundScriptSaveCommand >> execute [
	context actionSave
]
