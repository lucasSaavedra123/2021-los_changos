Extension { #name : #TestCase }

{ #category : #'*IngSoft2-Tests' }
TestCase >> assert: aProbabilisticDistributor generates: aGroupGeneratedByTheProbabilisticDistributor withMaxDifferenceBetweenThemOf: aTolerance [
	
 | maxDifference realProportionsbyEvents events realProportionOfEvent realProportionOfAnotherEvent |
	maxDifference := 0.
	events := aProbabilisticDistributor events.
	
	realProportionsbyEvents := self getProportionsByEventFrom: aGroupGeneratedByTheProbabilisticDistributor with: events.
	
	
	events do: [ 
				:event | events do: [ 
				:anotherEvent |        
					realProportionOfEvent := realProportionsbyEvents at: event.
					realProportionOfAnotherEvent := realProportionsbyEvents at: anotherEvent.
					maxDifference := (maxDifference max: ((realProportionOfEvent-realProportionOfAnotherEvent) * 100) abs).
				].    
				
				
				].	

		self assert: (maxDifference <= aTolerance)
	
	
	

]

{ #category : #'*IngSoft2-Tests' }
TestCase >> assert: aProbabilisticDistributor generates: aGroupGeneratedByTheProbabilisticDistributor withTolerance: aTolerance [
			
	| realProportionsByEvent tolerances  |
	realProportionsByEvent := self getProportionsByEventFrom: aGroupGeneratedByTheProbabilisticDistributor with: aProbabilisticDistributor events.
	tolerances := aProbabilisticDistributor events collect: [ 
				:event | ((realProportionsByEvent at: event ) - ((event probability ) )) abs * 100 ].
	self assert: ( tolerances allSatisfy: [:tolerance | (tolerance <= aTolerance) ])
	
	
	
	


]

{ #category : #'*IngSoft2-Tests' }
TestCase >> assert: aBlockClosure throws: aMessage [
	self
		should: aBlockClosure
		raise: Error
		withExceptionDo: [ :error | 
			self
				assert: error messageText
				equals: aMessage ]
]

{ #category : #'*IngSoft2-Tests' }
TestCase >> do: numberOfTurnsToDo theGame: aGame [ 
	1 to: (numberOfTurnsToDo) do: [ :number | aGame turn ]
]

{ #category : #'*IngSoft2-Tests' }
TestCase >> getProportionsByEventFrom: groupGenerated with: events [
	| proportionsByEvent realProportion |
	proportionsByEvent := Dictionary new.
	
	events do: [ :event | 
		realProportion :=  ((groupGenerated count: [ :item | item = event object ])/(groupGenerated size)).
		proportionsByEvent at: event put: realProportion   .      ].
	
	^proportionsByEvent .
]
