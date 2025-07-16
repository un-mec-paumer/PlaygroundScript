"
is a class for construct customize object in the playground
"
Class {
	#name : 'StPlaygroundScript',
	#superclass : 'Object',
	#instVars : [
		'envVar',
		'text',
		'currentClass'
	],
	#category : 'NewTools-Playground-Model',
	#package : 'NewTools-Playground',
	#tag : 'Model'
}

{ #category : 'as yet unclassified' }
StPlaygroundScript class >> init: aCollection text: aText [
	|tmp|
	tmp := self new
	envVar: aCollection;
	text: aText;
	yourself.
	
	aText interactionModel addBinding: (WorkspaceVariable key: #thisPlaygroundScript value: tmp).
	aText interactionModel addBindings: aCollection.
	^ tmp.
]

{ #category : 'accessing' }
StPlaygroundScript >> addVar: aVar [
	text interactionModel addBinding: aVar.
]

{ #category : 'private' }
StPlaygroundScript >> basicInit [
	text interactionModel addBinding: (WorkspaceVariable key:#this value: currentClass basicNew).
]

{ #category : 'instance creation' }
StPlaygroundScript >> createGetSet [

	currentClass allInstVarNames ifNil: [ ^ self ].
	currentClass allInstVarNames do: [ :var |
		self newMethod: var , String crlf , String tab , '^ ' , var ].
	currentClass allInstVarNames do: [ :var |
		self newMethod:
			var , ': aObject' , String crlf , String tab , var , ' := aObject' ]
]

{ #category : 'accessing' }
StPlaygroundScript >> currentClass [ 
	^ currentClass 
]

{ #category : 'accessing' }
StPlaygroundScript >> currentClass: aNewClass [
	currentClass := aNewClass
]

{ #category : 'accessing' }
StPlaygroundScript >> envVar [ 
	^ envVar
]

{ #category : 'accessing' }
StPlaygroundScript >> envVar: aCollection [
	envVar := aCollection
]

{ #category : 'initialization' }
StPlaygroundScript >> initialize [ 
	super initialize.
]

{ #category : 'instance creation' }
StPlaygroundScript >> newClass: aSymbol [

	currentClass ifNotNil: [ self error: 'a class is allready define (can be change)' ] ifNil: [
		currentClass := (Object << aSymbol)
			                package: 'NewTools-Playground-Save';
			                install.
		self createGetSet.
		self basicInit.
		]
]

{ #category : 'instance creation' }
StPlaygroundScript >> newClass: aSymbol withVars: aCollection [
	currentClass ifNotNil: [ self error: 'a class is allready define (can be change)' ] ifNil: [
		currentClass := Object << aSymbol slots: aCollection ; package: 'NewTools-Playground-Save' ; install .
		self createGetSet.
		self basicInit.
	]
]

{ #category : 'instance creation' }
StPlaygroundScript >> newDefaultClass [
	currentClass := Object newAnonymousSubclass.
	self basicInit.
	
	
]

{ #category : 'instance creation' }
StPlaygroundScript >> newMethod: aCode [
	currentClass ifNil: [ self error:  'a class need to be created before'] ifNotNil: [ 
		currentClass compile: aCode 
	].
]

{ #category : 'instance creation' }
StPlaygroundScript >> newVar: aSymbol [
	currentClass ifNil: [ self error: 'A class need to be created before' ] ifNotNil: [ 
		currentClass addInstVarNamed: aSymbol.
		self createGetSet.
	]
]

{ #category : 'instance creation' }
StPlaygroundScript >> newVars: aCollection [
	aCollection do: [:var | self newVar: var asSymbol].
]

{ #category : 'removing' }
StPlaygroundScript >> removeClass [
	(text interactionModel hasBindingOf: #this) ifTrue: [ text interactionModel localBindings removeKey: #this ].
	
	currentClass removeFromSystem.
	
	currentClass := nil.
	
	
]

{ #category : 'accessing' }
StPlaygroundScript >> removeMethod: aSymbol [
	currentClass ifNil:[ self error: 'a class need to be created before'] ifNotNil: [
		(currentClass canUnderstand: aSymbol) ifFalse: [ self error: 'his class can''t undersant', aSymbol ] 
		ifTrue: [ (currentClass >> aSymbol) removeFromSystem. ]
	]

]

{ #category : 'instance creation' }
StPlaygroundScript >> removeVar: aSymbol [
	currentClass ifNil: [self error: 'a class need to be created before'] ifNotNil:[ 
		(currentClass hasInstVarNamed: aSymbol) ifFalse: [ self error: 'this class can''t undersant ', aSymbol ] ifTrue: [ 
		currentClass removeInstVarNamed: aSymbol.
	
		self removeMethod: aSymbol.
		self removeMethod: aSymbol, ':'. ]
	]
]

{ #category : 'instance creation' }
StPlaygroundScript >> removeVars: aCollection [
	aCollection do: [ :var | self removeVar: var asSymbol ].
]

{ #category : 'accessing' }
StPlaygroundScript >> saveClass [
	
	currentClass setName: 'SavePlayground'; package: ('NewTools-Playground-Save').
]

{ #category : 'accessing' }
StPlaygroundScript >> saveClass: aSymbol [
	(currentClass environment includesKey: aSymbol) ifTrue: [^ self error: aSymbol , ' already exists'].
	currentClass setName: aSymbol; package: ('NewTools-Playground-Save').
]

{ #category : 'instance creation' }
StPlaygroundScript >> saveClassByText: aString [
	currentClass := (ClyNavigationEnvironment currentImage) system compileANewClassFrom: aString notifying: nil startingFrom: currentClass.
	self createGetSet.
]

{ #category : 'accessing' }
StPlaygroundScript >> text [ 
	^ text
]

{ #category : 'accessing' }
StPlaygroundScript >> text: aText [ 
	text := aText 
]
