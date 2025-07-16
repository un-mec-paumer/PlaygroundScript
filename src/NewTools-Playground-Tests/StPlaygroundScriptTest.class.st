Class {
	#name : 'StPlaygroundScriptTest',
	#superclass : 'TestCase',
	#category : 'NewTools-Playground-Tests',
	#package : 'NewTools-Playground-Tests'
}

{ #category : 'instance creation' }
StPlaygroundScriptTest >> newScript [
	|work1 work2 text stPlayPresenter|
	
	work1 := WorkspaceVariable key: #test1 value: 1.
	work2 := WorkspaceVariable key: #text86 value: '86'.
	
	stPlayPresenter := StPlaygroundPagePresenter new.
	text := stPlayPresenter text.
	text interactionModel: StPlaygroundInteractionModel new.
	
	^ StPlaygroundScript init: { work1 . work2 } text: text.
	
]

{ #category : 'instance creation' }
StPlaygroundScriptTest >> removeClass: aSymbol [
	Smalltalk removeClassNamed: aSymbol.
]

{ #category : 'tests' }
StPlaygroundScriptTest >> testBasicInit [
	| script |
	script := self newScript.
	
	self should: [ script basicInit ] raise: Error.
	
	script currentClass: String.
	script basicInit.
	
	self assert: (script text interactionModel bindingOf: #this) value isString
]

{ #category : 'tests' }
StPlaygroundScriptTest >> testCreateGetSet [
	|script nameClass nameVar|
	
	script := self newScript.
	nameClass := #Test3.
	nameVar := #test86.
	
	script newClass: nameClass withVars: { nameVar }.
	
	self assert: (script currentClass canUnderstand: nameVar).
	self assert: (script currentClass canUnderstand: nameVar , ':').
	
	self removeClass: nameClass.
	
]

{ #category : 'tests' }
StPlaygroundScriptTest >> testNewClass [

	| script name |
	script := self newScript.
	name := #TestA.

	script newClass: #TestA.
	self assert: script currentClass name identicalTo: name.
	self assert: (Smalltalk hasClassNamed: name).
	
	self should: [ script newClass: #any ] raise: Error.

	self removeClass: name
]

{ #category : 'tests' }
StPlaygroundScriptTest >> testNewClasswithVars [

	| script name |
	script := self newScript.
	name := #TestA.

	script newClass: #TestA withVars: { #hello . #world } asCollectionElement.
	self assert: script currentClass name identicalTo: name.
	self assert: (Smalltalk hasClassNamed: name).
	self assert: (Smalltalk at: name) == script currentClass.
	
	self should: [ script newClass: #any ] raise: Error.

	self removeClass: name
]

{ #category : 'tests' }
StPlaygroundScriptTest >> testNewDefaultClass [
	| script |
	script := self newScript.
	
	self assert: script currentClass equals: nil.
	
	script newDefaultClass.
	
	self deny: script currentClass equals: nil.
	self assert: (script text interactionModel hasBindingOf: #this)
	
]

{ #category : 'tests' }
StPlaygroundScriptTest >> testNewMethod [
	|script nameClass nameMethod|
	script := self newScript.
	nameClass := #TestA.
	nameMethod := #test.
	
	self should: [ script newMethod: 'any ^ any' ] raise: Error.
	
	script newClass: nameClass.
	script newMethod: nameMethod, ' ', String crlf, String tab, '^ 86.'.	
	
	self assert: (script currentClass new perform: nameMethod) equals: 86.
	
	self removeClass: nameClass.
]

{ #category : 'tests' }
StPlaygroundScriptTest >> testNewVar [

	| script nameClass nameVar|
	script := self newScript.
	nameClass := #TestA.
	nameVar := #test86.

	self should: [ script newVar: #any ] raise: Error.

	script newClass: nameClass.
	script newVar: nameVar.
	
	self assert: (script currentClass hasSlotNamed: nameVar).
	self assert: (script currentClass canUnderstand: nameVar).	
	self assert: (script currentClass canUnderstand: nameVar , ':').	

	self removeClass: nameClass.
]

{ #category : 'tests' }
StPlaygroundScriptTest >> testNewVars [

	| script nameClass nameVar|
	script := self newScript.
	nameClass := #TestA.
	nameVar := {#test86 . #test42}.

	self should: [ script newVar: #any ] raise: Error.

	script newClass: nameClass.
	script newVars: nameVar.
	
	nameVar do: [ :var |  self assert: (script currentClass hasSlotNamed: var)].
	nameVar do: [ :var |  self assert: (script currentClass canUnderstand: var)].
	nameVar do: [ :var |  self assert: (script currentClass canUnderstand: var, ':')].

	self removeClass: nameClass.
]

{ #category : 'tests' }
StPlaygroundScriptTest >> testRemoveClass [
	|script name|
	script := self newScript.
	
	name := #Test3.
	script newClass: name.
	
	
	self assert: (Smalltalk hasClassNamed: name).
	self assert: script currentClass notNil.
	self assert: (script text interactionModel hasBindingOf: #this).
	
	script removeClass.
	
	self deny: (Smalltalk hasClassNamed: name).
	self deny: script currentClass notNil.
	self deny: (script text interactionModel hasBindingOf: #this)
	
	
	
]

{ #category : 'tests' }
StPlaygroundScriptTest >> testRemoveMethod [
	|script nameClass nameMethod|
	script := self newScript.
	nameClass := #TestA.
	nameMethod := #test.
	
	script newClass: nameClass.
	script newMethod: nameMethod, ' ', String crlf, String tab, '^ 86.'.	
	
	self assert: (script currentClass new perform: nameMethod) equals: 86.
	self assert: (script currentClass canUnderstand: nameMethod).
	script removeMethod: nameMethod.
	self should: [ script removeMethod: nameMethod ] raise: Error. 
	self deny: (script currentClass canUnderstand: nameMethod).
]

{ #category : 'tests' }
StPlaygroundScriptTest >> testRemoveVar [

	| script nameClass nameVar|
	script := self newScript.
	nameClass := #TestA.
	nameVar := #test86.
	
	self should: [ script removeVar: #any ] raise: Error.
	
	script newClass: nameClass.
	script newVar: nameVar.
	
	self assert: (script currentClass hasSlotNamed: nameVar).
	self assert: (script currentClass canUnderstand: nameVar).	
	self assert: (script currentClass canUnderstand: nameVar , ':').	
		
	script removeVar: nameVar.
	self should: [ script removeVar: #any ] raise: Error.
	
	self deny: (script currentClass hasSlotNamed: nameVar).
	self deny: (script currentClass canUnderstand: nameVar).	
	self deny: (script currentClass canUnderstand: nameVar , ':').
	

	self removeClass: nameClass.
]

{ #category : 'tests' }
StPlaygroundScriptTest >> testRemoveVars [

	| script nameClass nameVar|
	script := self newScript.
	nameClass := #TestA.
	nameVar := {#test86 . #test42}.

	script newClass: nameClass.
	script newVars: nameVar.
	
	nameVar do: [ :var |  self assert: (script currentClass hasSlotNamed: var)].
	nameVar do: [ :var |  self assert: (script currentClass canUnderstand: var)].
	nameVar do: [ :var |  self assert: (script currentClass canUnderstand: var, ':')].
	
	script removeVars: nameVar.
	
	nameVar do: [ :var |  self deny: (script currentClass hasSlotNamed: var)].
	nameVar do: [ :var |  self deny: (script currentClass canUnderstand: var)].
	nameVar do: [ :var |  self deny: (script currentClass canUnderstand: var, ':')].
	
	self removeClass: nameClass.
]

{ #category : 'tests' }
StPlaygroundScriptTest >> testSaveClassByText [
	|script name|
	
	script := self newScript.
	name := 'Test863'.
	
	script saveClassByText: 'Object << #Test863 
	slots: {};
	package: ''NewTools-Playground-Save'''.
	
	self assert: (Smalltalk hasClassNamed: name) .
	
	self removeClass: name.
]

{ #category : 'instance creation' }
StPlaygroundScriptTest >> testScriptInit [
	|script|
	
	script := self newScript.
	script envVar do: [ :var | self assert: (script text interactionModel hasBindingOf: var key) ]
	
]
