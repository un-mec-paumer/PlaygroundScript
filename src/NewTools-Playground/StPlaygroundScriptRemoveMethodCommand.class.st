"
this command is to delete a method of the current class
"
Class {
	#name : 'StPlaygroundScriptRemoveMethodCommand',
	#superclass : 'StPlaygroundCommand',
	#category : 'NewTools-Playground-Command',
	#package : 'NewTools-Playground',
	#tag : 'Command'
}

{ #category : 'default' }
StPlaygroundScriptRemoveMethodCommand class >> defaultDescription [
	^ 'remove the selected method'
]

{ #category : 'default' }
StPlaygroundScriptRemoveMethodCommand class >> defaultIconName [
	^ #trash 
]

{ #category : 'default' }
StPlaygroundScriptRemoveMethodCommand class >> defaultName [
	^ 'Remove'
]

{ #category : 'accessing' }
StPlaygroundScriptRemoveMethodCommand class >> defaultShortcut [
	^ $x command mac 
		| $x control win 
		| $x control unix
]

{ #category : 'executing' }
StPlaygroundScriptRemoveMethodCommand >> execute [
	context removeMethod
]
