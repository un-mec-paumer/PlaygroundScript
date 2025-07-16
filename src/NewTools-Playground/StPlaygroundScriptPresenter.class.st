"
this is to manage a class in the playground
"
Class {
	#name : 'StPlaygroundScriptPresenter',
	#superclass : 'StPresenter',
	#instVars : [
		'bt3',
		'bt4',
		'bt5',
		'parent',
		'currentClass',
		'listClass',
		'text',
		'listMethode',
		'script'
	],
	#category : 'NewTools-Playground-View',
	#package : 'NewTools-Playground',
	#tag : 'View'
}

{ #category : 'instance creation' }
StPlaygroundScriptPresenter class >> newApplication: anApplication model: anModelPresenter script: aPlaygroundScript [

	^ self basicNew
		application: anApplication;
		setModelBeforeInitialization: anModelPresenter;
		script: aPlaygroundScript;
		initialize;
		yourself
]

{ #category : 'action' }
StPlaygroundScriptPresenter >> actionChangeClassInPlayground [
		parent script currentClass: currentClass.
		parent script basicInit.
		self delete
]

{ #category : 'action' }
StPlaygroundScriptPresenter >> actionCreateNewPlaygroundButton [
	| stPlay |
		stPlay := StPlaygroundPresenter openContents: 'this'.
		stPlay presenter firstPage script currentClass: currentClass.
		stPlay presenter firstPage interactionModel removeBindingNamed: 'this'.
		stPlay presenter firstPage script basicInit.
		self delete
]

{ #category : 'action' }
StPlaygroundScriptPresenter >> actionNewClass [
	text text: 'Object << #newnameheeere
	slots: {};
	package: ''NewTools-Playground-Save'''
]

{ #category : 'action' }
StPlaygroundScriptPresenter >> actionSave [
	self textIsClass ifFalse: [ self actionSaveMethod ] ifTrue: [ self actionSaveClass ]
]

{ #category : 'action' }
StPlaygroundScriptPresenter >> actionSaveClass [
	script saveClassByText: text text. 
	self updateClassList.
]

{ #category : 'action' }
StPlaygroundScriptPresenter >> actionSaveMethod [

	script
		currentClass: currentClass;
		newMethod: text text.
	self updateMethodList
]

{ #category : 'accessing' }
StPlaygroundScriptPresenter >> contextMenuActionsListClass [
	^ CmCommandGroup forSpec beRoot 
	register: (StPlaygroundScriptRemoveClassCommand forSpecContext: self);
	yourself.

	

	
]

{ #category : 'accessing' }
StPlaygroundScriptPresenter >> contextMenuActionsListMethod [
	^ CmCommandGroup forSpec beRoot 
	register: (StPlaygroundScriptRemoveMethodCommand forSpecContext: self);
	yourself.

	

	
]

{ #category : 'accessing' }
StPlaygroundScriptPresenter >> contextMenuActionsText [
	|commands|	
	commands := CmCommandGroup forSpec beRoot yourself.
	SpTextEditionCommand allOrdered 
		do: [ :commandClass | commands register: (commandClass forSpecContext: text) ].
	commands register: (StPlaygroundScriptSaveCommand forSpecContext: self) .
	
	^ commands
	
]

{ #category : 'accessing' }
StPlaygroundScriptPresenter >> currentClass [
	^ currentClass
]

{ #category : 'accessing' }
StPlaygroundScriptPresenter >> currentClass: aClass [
	currentClass := aClass
]

{ #category : 'layout' }
StPlaygroundScriptPresenter >> defaultLayout [ 
	^ SpBoxLayout newTopToBottom 
	add: (SpPanedLayout newLeftToRight
		positionOfSlider: 60 percent;
		add: text;
		add: (SpBoxLayout newTopToBottom 
				add: (SpBoxLayout newLeftToRight 
						add: listClass;
						add: listMethode;
						yourself) withConstraints: [:c | c height: 400 ];
				add: (SpGridLayout new
							add: bt3 atPoint: 1@1;
							add: bt4 atPoint: 1@2;
							add: bt5 atPoint: 1@3;
							yourself);
				yourself)
		yourself);
	yourself
]

{ #category : 'accessing' }
StPlaygroundScriptPresenter >> getAClassBySelection: aSelection [
	|tmp|
	tmp := (((PackageOrganizer default packageNamed: 'NewTools-Playground-Save') definedClasses asArray) select: 
			[ :aMethode | aMethode asString literalEqual: aSelection asString ]).
	
	^ tmp first
]

{ #category : 'accessing' }
StPlaygroundScriptPresenter >> getAMethodeBySelection: aSelection [
	^ (currentClass allMethods select: 
			[ :aMethode | aMethode name literalEqual: aSelection asString ]) first
]

{ #category : 'initialization' }
StPlaygroundScriptPresenter >> initialize [
	super initialize.
]

{ #category : 'initialization' }
StPlaygroundScriptPresenter >> initializeButtons [
	bt3 := self newButton.
	bt4 := self newButton.
	bt5 := self newButton.

	bt3 label: 'open current class in Play'.
	bt4 label: 'change current class your playground'.
	bt5 label: 'new class'.

	bt3 action: [
		self actionCreateNewPlaygroundButton.
	].
	bt4 action: [
		self actionChangeClassInPlayground.
	].
	bt5 action: [ 
		self actionNewClass.	
	]
]

{ #category : 'initialization' }
StPlaygroundScriptPresenter >> initializeClassesList [
	listClass := self newColumnView.
	
	listClass addColumnTitle: 'class from playground save' 
			setup: [ :aPresenter | aPresenter newLabel ] 
			bind: [ :aPresenter :aClass | aPresenter label: aClass asString ];
			actions: self contextMenuActionsListClass;
			whenSelectedDo: [ :selection | 
				currentClass := (self getAClassBySelection: selection).
				text text: currentClass definitionString.
				text interactionModel:(SpCodeBehaviorInteractionModel on: currentClass).
				self updateMethodList
			].
	self updateClassList. 
	
	
		
		

]

{ #category : 'initialization' }
StPlaygroundScriptPresenter >> initializeMethodList [ 
	listMethode := self newColumnView.
	
	listMethode 
		addColumnTitle: 'instace methode'
		setup: [ :aPresenter | aPresenter newLabel ]
		bind: [ :aPresenter :aClass | aPresenter label: (aClass copyReplaceAll: (currentClass name , '>>#') with: '') ];
		actions: self contextMenuActionsListMethod;
		whenSelectedDo: [ :selection |
				text text: (self getAMethodeBySelection: selection) sourceCode.
				text interactionModel:(SpCodeMethodInteractionModel on: (self getAMethodeBySelection: selection)).
		].
		self updateMethodList
]

{ #category : 'initialization' }
StPlaygroundScriptPresenter >> initializePresenters [
	
	text := self newCode.
	text overridingContextMenu.
	text actions: self contextMenuActionsText.
	"text action: self."

	currentClass := script currentClass.
	self initializeClassesList.
	currentClass ifNil: [ currentClass := listClass items first ].
	self initializeMethodList.
	self initializeButtons.

	text text: currentClass definitionString.
	
]

{ #category : 'initialization' }
StPlaygroundScriptPresenter >> initializeWindow: aWindowPresenter [
	aWindowPresenter initialExtent: 950@550;
	title: self windowTitle.
]

{ #category : 'removing' }
StPlaygroundScriptPresenter >> removeClass [
	script removeClass.
	currentClass := nil.
	self updateClassList.
	listMethode items: #().
]

{ #category : 'removing' }
StPlaygroundScriptPresenter >> removeMethod [
	script removeMethod: ((listMethode selectedItem splitOn: '>>#') second asSymbol).
	self updateMethodList
]

{ #category : 'accessing' }
StPlaygroundScriptPresenter >> script: aPlaygroundScript [
	script := aPlaygroundScript
]

{ #category : 'accessing' }
StPlaygroundScriptPresenter >> setModelBeforeInitialization: aModel [
	parent := aModel.
]

{ #category : 'verification' }
StPlaygroundScriptPresenter >> textIsClass [
	^ text text includesSubstring: '<<'.
]

{ #category : 'update' }
StPlaygroundScriptPresenter >> updateClassList [
	listClass items: (PackageOrganizer default packageNamed: 'NewTools-Playground-Save') definedClasses asArray
]

{ #category : 'update' }
StPlaygroundScriptPresenter >> updateMethodList [
	listMethode items: ((currentClass allMethods collect: [ :aMethode | aMethode name ])
		select: [ :aMethode | aMethode beginsWith: currentClass name ]).
]

{ #category : 'accessing' }
StPlaygroundScriptPresenter >> windowTitle [ 
	^ 'Page Script'
]
