Extension { #name : #LudoMagicGameTest }

{ #category : #'*IngSoft2-Tests' }
LudoMagicGameTest >> do: numberOfTurnsToDo the: aGame [
	1 to: numberOfTurnsToDo do: [ :number | aGame turn ]
]
