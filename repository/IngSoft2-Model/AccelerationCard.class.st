Class {
	#name : #AccelerationCard,
	#superclass : #Card,
	#category : #'IngSoft2-Model-Core'
}

{ #category : #action }
AccelerationCard >> applyTo: aTarget in: aGame [
	aGame addToAllEffectOf: self
]

{ #category : #action }
AccelerationCard >> applyTo: aTarget in: aGame from: aPlayer [
	aGame validateThrowOfAPermanent: self from: aPlayer.
	self applyTo: aTarget in: aGame
]

{ #category : #accesing }
AccelerationCard >> effect [
	^ 1
]
