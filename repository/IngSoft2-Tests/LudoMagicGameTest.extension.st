Extension { #name : #LudoMagicGameTest }

{ #category : #'*IngSoft2-Tests' }
LudoMagicGameTest >> do: numberOfTurnsToDo theGame: aGame [
	1 to: numberOfTurnsToDo do: [ :number | aGame turn ]
]
