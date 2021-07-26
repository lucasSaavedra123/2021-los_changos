Class {
	#name : #ReDoCard,
	#superclass : #Card,
	#category : #'IngSoft2-Model-Core'
}

{ #category : #action }
ReDoCard >> applyTo: aTarget in: aGame from: aPlayer [
	| lastCard |
	lastCard := aGame lastPlayableCardPlayed.
	aGame validate: aPlayer has: self.
	aGame apply: lastCard on: aTarget
]

{ #category : #action }
ReDoCard >> isNotReDo [
	^ false
]
