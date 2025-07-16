Class {
	#name : 'StPlaygroundScriptPresenterTest',
	#superclass : 'StPlaygroundBaseTest',
	#instVars : [
		'owner'
	],
	#category : 'NewTools-Playground-Tests',
	#package : 'NewTools-Playground-Tests'
}

{ #category : 'accessing' }
StPlaygroundScriptPresenterTest >> classToTest [

	^ StPlaygroundScriptPresenter.
]

{ #category : 'running' }
StPlaygroundScriptPresenterTest >> setUp [
	owner := StPlaygroundPagePresenter new.
	
	presenter := ((self classToTest) 
		newApplication: owner application 
		model: owner
		script: owner script
		)
]

{ #category : 'tests' }
StPlaygroundScriptPresenterTest >> testGetAClassBySelection [
	|class|
	presenter currentClass: (Object << #Test86
			                package: 'NewTools-Playground-Save';
			                install).
	
	class := presenter getAClassBySelection: 'Test86'.
	self assert: class equals: presenter currentClass.
	
	presenter currentClass removeFromSystem.
	
	
]

{ #category : 'tests' }
StPlaygroundScriptPresenterTest >> testGetAMethodeBySelection [
	|methode|
	presenter currentClass: Object newAnonymousSubclass.
	presenter currentClass compile: 'test86 ^ 86'.
	
	methode := presenter getAMethodeBySelection: 'a subclass of Object>>#test86'.
	self assert: methode methodClass equals: presenter currentClass.
	
	
	
]

{ #category : 'tests' }
StPlaygroundScriptPresenterTest >> testInitPage [
	self assert: presenter class equals: self classToTest.
]
