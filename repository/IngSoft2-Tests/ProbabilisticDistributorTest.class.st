Class {
	#name : #ProbabilisticDistributorTest,
	#superclass : #TestCase,
	#category : #'IngSoft2-Tests'
}

{ #category : #support }
ProbabilisticDistributorTest >> assert: aProbabilisticDistributor generates: aGroupGeneratedByTheProbabilisticDistributor withMaxDifferenceBetweenThemOf: aTolerance [
	| maxDifference realProportionsbyEvents events realProportionOfEvent realProportionOfAnotherEvent |
	maxDifference := 0.
	events := aProbabilisticDistributor events.
	realProportionsbyEvents := self
		proportionsByEventFrom: aGroupGeneratedByTheProbabilisticDistributor
		with: events.
	events
		allPairsDo: [ :anEvent :anotherEvent | 
			realProportionOfEvent := realProportionsbyEvents at: anEvent.
			realProportionOfAnotherEvent := realProportionsbyEvents
				at: anotherEvent.
			maxDifference := maxDifference
				max: ((realProportionOfEvent - realProportionOfAnotherEvent) * 100) abs ].
	self assert: maxDifference <= aTolerance
]

{ #category : #support }
ProbabilisticDistributorTest >> assert: aProbabilisticDistributor generates: aGroupGeneratedByTheProbabilisticDistributor withTolerance: aTolerance [
	| realProportionsByEvent tolerances |
	realProportionsByEvent := self
		proportionsByEventFrom: aGroupGeneratedByTheProbabilisticDistributor
		with: aProbabilisticDistributor events.
	tolerances := aProbabilisticDistributor events
		collect:
			[ :event | ((realProportionsByEvent at: event) - event probability) abs * 100 ].
	self
		assert: (tolerances allSatisfy: [ :tolerance | tolerance <= aTolerance ])
]

{ #category : #support }
ProbabilisticDistributorTest >> proportionsByEventFrom: groupGenerated with: events [
	| proportionsByEvent realProportion |
	proportionsByEvent := Dictionary new.
	events
		do: [ :event | 
			realProportion := (groupGenerated
				count: [ :item | item = event object ]) / groupGenerated size.
			proportionsByEvent at: event put: realProportion ].
	^ proportionsByEvent
]

{ #category : #'exception tests' }
ProbabilisticDistributorTest >> testAProbabilisticDistributorCannotBeCreatedWithEmptyEvents [
	self
		assert: [ ProbabilisticDistributor with: {} ]
		throws: ProbabilisticDistributor notValidGroupOfEventsMessage
]

{ #category : #tests }
ProbabilisticDistributorTest >> testAProbabilisticDistributorGenerateAGroupOfObjectsThatAreEquallyDistributed [
	| result events distributor |
	result := {3 . 3 . 3 . 3 . 3}.
	events := {(ProbabilisticEvent with: 1 for: 3)}.
	distributor := ProbabilisticDistributor with: events.
	self assert: (distributor generate: 5) equals: result
]

{ #category : #'exception tests' }
ProbabilisticDistributorTest >> testAProbabilisticEventCannotBeCreatedWithProbabilityGreaterThanOne [
	self
		assert: [ ProbabilisticEvent with: 1.1 for: Object ]
		throws: ProbabilisticEvent notValidProbabilityMessage
]

{ #category : #'exception tests' }
ProbabilisticDistributorTest >> testAProbabilisticEventCannotBeCreatedWithProbabilityLowerThanZero [
	self
		assert: [ ProbabilisticEvent with: -2 for: Object ]
		throws: ProbabilisticEvent notValidProbabilityMessage
]

{ #category : #'exception tests' }
ProbabilisticDistributorTest >> testAProbabilisticEventCouldHaveProbabilityOne [
	self
		assert: (ProbabilisticEvent with: 1 for: Object) probability
		equals: 1
]

{ #category : #'exception tests' }
ProbabilisticDistributorTest >> testAProbabilisticEventCouldHaveProbabilityZero [
	self
		assert: (ProbabilisticEvent with: 0 for: Object) probability
		equals: 0
]

{ #category : #'exception tests' }
ProbabilisticDistributorTest >> testAProbabiliticDistributorCannotHaveEventsWithAllEventsInOne [
	| events |
	events := {(ProbabilisticEvent with: 1 for: 6).
	(ProbabilisticEvent with: 1 for: 10)}.
	self
		assert: [ ProbabilisticDistributor with: events ]
		throws: ProbabilisticDistributor notValidGroupOfEventsMessage
]

{ #category : #'exception tests' }
ProbabilisticDistributorTest >> testAProbabiliticDistributorCannotHaveEventsWithAllEventsInZero [
	| events |
	events := {(ProbabilisticEvent with: 0 for: 6).
	(ProbabilisticEvent with: 0 for: 10)}.
	self
		assert: [ ProbabilisticDistributor with: events ]
		throws: ProbabilisticDistributor notValidGroupOfEventsMessage
]

{ #category : #'exception tests' }
ProbabilisticDistributorTest >> testAProbabiliticDistributorCannotHaveSumOfEventsProbabilitiesIsGreaterThanOne [
	| events |
	events := {(ProbabilisticEvent with: 0.9 for: 6).
	(ProbabilisticEvent with: 0.85 for: 10)}.
	self
		assert: [ ProbabilisticDistributor with: events ]
		throws: ProbabilisticDistributor notValidGroupOfEventsMessage
]

{ #category : #'exception tests' }
ProbabilisticDistributorTest >> testAProbabiliticDistributorCannotHaveSumOfEventsProbabilitiesNotEqualToOne [
	| events |
	events := {(ProbabilisticEvent with: 0.1 for: 6).
	(ProbabilisticEvent with: 0.4 for: 10)}.
	self
		assert: [ ProbabilisticDistributor with: events ]
		throws: ProbabilisticDistributor notValidGroupOfEventsMessage
]

{ #category : #tests }
ProbabilisticDistributorTest >> testAProbabiliticDistributorWithEventsGenerateWithCorrectSize [
	| aProbabilisticDistributor |
	aProbabilisticDistributor := ProbabilisticDistributor
		with:
			{(ProbabilisticEvent with: 1 for: 'anotherItem').
			(ProbabilisticEvent with: 0 for: 'someItem')}.
	self assert: (aProbabilisticDistributor generate: 23) size equals: 23
]

{ #category : #tests }
ProbabilisticDistributorTest >> testAProbabiliticDistributorWithFiveEventsGenerateAGroupWithToleranceOfFiveOrBelow [
	| aProbabilisticDistributor |
	aProbabilisticDistributor := ProbabilisticDistributor
		with:
			{(ProbabilisticEvent with: 0.5 for: 'firstItem').
			(ProbabilisticEvent with: 0.1 for: 'secondItem').
			(ProbabilisticEvent with: 0.1 for: 'thirdItem').
			(ProbabilisticEvent with: 0 for: 'fourthItem').
			(ProbabilisticEvent with: 0.3 for: 'fifthItem')}.
	self
		assert: aProbabilisticDistributor
		generates: (aProbabilisticDistributor generate: 1000)
		withTolerance: 10
]

{ #category : #tests }
ProbabilisticDistributorTest >> testAProbabiliticDistributorWithFiveEventsHasNoItemFromEventWithProbabilityZero [
	| aProbabilisticDistributor |
	aProbabilisticDistributor := ProbabilisticDistributor
		with:
			{(ProbabilisticEvent with: 0.5 for: 'firstItem').
			(ProbabilisticEvent with: 0.1 for: 'secondItem').
			(ProbabilisticEvent with: 0.1 for: 'thirdItem').
			(ProbabilisticEvent with: 0 for: 'fourthItem').
			(ProbabilisticEvent with: 0.3 for: 'fifthItem')}.
	self
		deny:
			((aProbabilisticDistributor generate: 1000) includes: 'fourthItem')
]

{ #category : #tests }
ProbabilisticDistributorTest >> testAProbabiliticDistributorWithOneEventGenerateAllEqualItems [
	| aProbabilisticDistributor |
	aProbabilisticDistributor := ProbabilisticDistributor
		with: {(ProbabilisticEvent with: 1 for: 'someItem')}.
	self
		assert:
			((aProbabilisticDistributor generate: 1000)
				allSatisfy: [ :item | 'someItem' = item ])
]

{ #category : #tests }
ProbabilisticDistributorTest >> testAProbabiliticDistributorWithOneEventGenerateWithToleranceZero [
	| aProbabilisticDistributor |
	aProbabilisticDistributor := ProbabilisticDistributor
		with: {(ProbabilisticEvent with: 1 for: 'someItem')}.
	self
		assert: aProbabilisticDistributor
		generates: (aProbabilisticDistributor generate: 30)
		withTolerance: 0
]

{ #category : #tests }
ProbabilisticDistributorTest >> testAProbabiliticDistributorWithOneEventPickThatEvent [
	| aProbabilisticDistributor anObject aProbabilisticEvent |
	anObject := 10.
	aProbabilisticEvent := ProbabilisticEvent with: 1 for: anObject.
	aProbabilisticDistributor := ProbabilisticDistributor
		with: {aProbabilisticEvent}.
	self assert: aProbabilisticDistributor pick equals: anObject
]

{ #category : #tests }
ProbabilisticDistributorTest >> testAProbabiliticDistributorWithOneItemWithEqualProbability [
	| aProbabilisticDistributor |
	aProbabilisticDistributor := ProbabilisticDistributor
		withEqualProbability: {1}.
	self
		assert: aProbabilisticDistributor
		generates: (aProbabilisticDistributor generate: 1000)
		withMaxDifferenceBetweenThemOf: 0
]

{ #category : #tests }
ProbabilisticDistributorTest >> testAProbabiliticDistributorWithThreeItemsWithEqualProbability [
	| aProbabilisticDistributor |
	aProbabilisticDistributor := ProbabilisticDistributor
		withEqualProbability: {1 . 5 . 9}.
	self
		assert: aProbabilisticDistributor
		generates: (aProbabilisticDistributor generate: 10000)
		withMaxDifferenceBetweenThemOf: 4
]

{ #category : #tests }
ProbabilisticDistributorTest >> testAProbabiliticDistributorWithTwoEventsGenerateAllEqualItemsThatAreNotOfTheEventWithProbabilityZero [
	| aProbabilisticDistributor |
	aProbabilisticDistributor := ProbabilisticDistributor
		with:
			{(ProbabilisticEvent with: 0 for: 'itemZero').
			(ProbabilisticEvent with: 1 for: 'anotherItem')}.
	self
		assert:
			((aProbabilisticDistributor generate: 10)
				allSatisfy: [ :item | 'anotherItem' = item ])
]

{ #category : #tests }
ProbabilisticDistributorTest >> testAProbabiliticDistributorWithTwoEventsThatOneHasProbabilityZeroPickTheOtherEvent [
	| aProbabilisticDistributor |
	aProbabilisticDistributor := ProbabilisticDistributor
		with:
			{(ProbabilisticEvent with: 1 for: 9).
			(ProbabilisticEvent with: 0 for: 1)}.
	self assert: aProbabilisticDistributor pick equals: 9
]

{ #category : #tests }
ProbabilisticDistributorTest >> testAProbabiliticDistributorWithTwoEventsWithZeroAndOneOfProbabilityAndGenerateWithToleranceZero [
	| aProbabilisticDistributor |
	aProbabilisticDistributor := ProbabilisticDistributor
		with:
			{(ProbabilisticEvent with: 1 for: 'anotherItem').
			(ProbabilisticEvent with: 0 for: 'someItem')}.
	self
		assert: aProbabilisticDistributor
		generates: (aProbabilisticDistributor generate: 89)
		withTolerance: 0
]

{ #category : #tests }
ProbabilisticDistributorTest >> testARealIntervalCannotBeCreatedWithMinorLimitGreaterThanMajorLimit [
	self
		assert: [ RealInterval from: 5 to: 2 ]
		throws: (RealInterval notValidLimitsErrorMessageFrom: 5 to: 2)
]
