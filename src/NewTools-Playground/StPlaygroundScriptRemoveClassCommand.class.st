"
this command is to delete a class of the script
"
Class {
	#name : 'StPlaygroundScriptRemoveClassCommand',
	#superclass : 'StPlaygroundCommand',
	#category : 'NewTools-Playground-Command',
	#package : 'NewTools-Playground',
	#tag : 'Command'
}

{ #category : 'default' }
StPlaygroundScriptRemoveClassCommand class >> defaultDescription [ 
	^ 'remove the selected class'
]

{ #category : 'default' }
StPlaygroundScriptRemoveClassCommand class >> defaultIconName [ 
	^ #trash
]

{ #category : 'default' }
StPlaygroundScriptRemoveClassCommand class >> defaultName [ 
	^ 'remove'
]

{ #category : 'accessing' }
StPlaygroundScriptRemoveClassCommand class >> defaultShortcut [
	^ $x command mac 
		| $x control win 
		| $x control unix
]

{ #category : 'executing' }
StPlaygroundScriptRemoveClassCommand >> execute [
	context removeClass
]
