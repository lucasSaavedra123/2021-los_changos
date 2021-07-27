Class {
	#name : #SpeedCard,
	#superclass : #Card,
	#category : #'IngSoft2-Model-Core'
}

{ #category : #action }
SpeedCard >> applyTo: aTarget in: aGame [
	aGame addEffectOf: self to: aTarget
]

{ #category : #action }
SpeedCard >> applyTo: aTarget in: aGame from: aPlayer [
	aGame validateThrowOfAPermanent: self from: aPlayer.
	self applyTo: aTarget in: aGame
]

{ #category : #accessing }
SpeedCard >> effect [
	^ 1
]
