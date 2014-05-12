//
//  Deck.m
//  coding_two
//
//  Created by AM on 2014-05-09.
//  Copyright (c) 2014 AM. All rights reserved.
//

#import "Deck.h"

@interface Deck ()


@property (nonatomic, strong) NSMutableDictionary *cardStatesAfterShuffle;
@property (nonatomic, strong) NSString *lastShuffleIndex;
@property (nonatomic, assign) int numOfSuits;
@property (nonatomic, assign) int numOfValues;
@property (nonatomic, strong) NSMutableArray *guidArray;
@property (nonatomic, strong) NSMutableDictionary *guidMovements; //remove
@property (nonatomic, strong) NSMutableDictionary *guidGraph;
@property (nonatomic, assign) int successorNumber;

@end


@implementation Deck


-(id)initWithSuits:(NSArray*)suitsArray numberOfCardValues:(NSArray*)cardValues
{
    
    if(self = [super init])
    {
        _cardStatesAfterShuffle = [[NSMutableDictionary alloc] initWithCapacity:1];
        _numOfSuits = (int)[suitsArray count];
        _numOfValues = (int)[cardValues count];
        _guidArray = [NSMutableArray arrayWithCapacity:(_numOfSuits * _numOfValues)];
        _guidMovements = [NSMutableDictionary dictionaryWithCapacity:[_guidArray count]];
        NSMutableArray *tempArray  = [NSMutableArray arrayWithCapacity:(_numOfSuits * _numOfValues)];
        _guidGraph = [[NSMutableDictionary alloc] init];
        _successorNumber = 1;
        int i = 0;
        for (id suit in suitsArray)
        {
            for (id val in cardValues)
            {
                Card *tempCard = [[Card alloc ]initWithSuit:suit
                                                      value:val];
                [tempArray addObject:tempCard];
                [_guidArray insertObject:[tempCard guid] atIndex:i];
                NSMutableArray *guidPositions = [[NSMutableArray alloc] init];
                [guidPositions addObject:[NSNumber numberWithInt:i]];
                [_guidMovements setObject:guidPositions forKey:[tempCard guid]];
                i++;
            }
        }
        [_cardStatesAfterShuffle setObject:tempArray forKey:@"0"];
        [self setUpGuidGraphForShuffle:@"0"];
        _lastShuffleIndex = @"0";
        
    }
    return self;
}





-(void)printDeck
{
    NSMutableArray *arrayOfCardsForLastShuffle = [self.cardStatesAfterShuffle valueForKeyPath:self.lastShuffleIndex];
    int totalCardNumber = (int)[arrayOfCardsForLastShuffle count];
    NSLog(@"Deck has %d cards\n", totalCardNumber);
    
    
    for (int i =0; i < totalCardNumber; i++)
    {
        NSLog(@"Card[%d]=  %@",i,[[arrayOfCardsForLastShuffle objectAtIndex:i ] description]);
    }

}

-(void)shuffleDeck
{
    NSMutableArray *arrayOfCardsForLastShuffle = [self.cardStatesAfterShuffle valueForKeyPath:self.lastShuffleIndex];
    NSLog(@"Shuffling deck......");
    NSMutableArray *cardsBeforeShuffle = [[NSMutableArray alloc] initWithArray:arrayOfCardsForLastShuffle
                                                                     copyItems:YES];
    NSMutableArray *cardsAfterShuffle;
    int numberOfCards = (int)[cardsBeforeShuffle count];
    if(numberOfCards >= 1)
    {
        
        cardsAfterShuffle = [[NSMutableArray alloc] initWithCapacity:numberOfCards];
        for (int i = 0; i < numberOfCards; i++)
        {
            [cardsAfterShuffle addObject:[NSNull null]];
        }
        NSUInteger sourceRandomIndex;
        NSUInteger destinationRandomIndex;
        while((int)[cardsBeforeShuffle count] > 0 )
        {
            sourceRandomIndex = arc4random_uniform((int)[cardsBeforeShuffle count]);
            destinationRandomIndex = arc4random_uniform(numberOfCards);
            Card *swapCard = [cardsBeforeShuffle objectAtIndex:sourceRandomIndex];
            
            if([[cardsAfterShuffle objectAtIndex:destinationRandomIndex] isKindOfClass:[NSNull class]])
            {
                [cardsAfterShuffle replaceObjectAtIndex:destinationRandomIndex withObject:swapCard];
                NSMutableArray *arrayOfGuidPositions = [self.guidMovements objectForKey:[swapCard guid]];
                NSLog(@"Moving Card from index:%d to index:%d", (int)sourceRandomIndex, (int)destinationRandomIndex);
                [arrayOfGuidPositions addObject:[NSNumber numberWithInt:(int)destinationRandomIndex]];
                [self.guidMovements setObject:arrayOfGuidPositions forKey:[swapCard guid]];
                [cardsBeforeShuffle removeObjectAtIndex:sourceRandomIndex];
            }
            else
            {
                continue;
            }
        }
        
        self.lastShuffleIndex = [NSString stringWithFormat:@"%d",([self.lastShuffleIndex intValue] + 1)];
        [self.cardStatesAfterShuffle setObject:cardsAfterShuffle forKey:self.lastShuffleIndex];
        [self setUpGuidGraphForShuffle:self.lastShuffleIndex];
        
        
    }
    else
    {
        NSLog(@"Deck has 1 or less than 1 cards. Not enough to shuffle");
    }
}



-(void)setUpGuidGraphForShuffle:(NSString*)shuffle
{
    NSMutableDictionary *graph = [[NSMutableDictionary alloc] init];
    NSMutableArray *cardsInLastShuffle = [self.cardStatesAfterShuffle objectForKey:shuffle];

    for(Card *cd  in cardsInLastShuffle)
    {
        int index = (int)[cardsInLastShuffle indexOfObject:cd];
        NSMutableArray *successors = [self getNumberOf:self.successorNumber SuccessorsForIndexValue:index forShuffle:shuffle];
        [graph setObject:successors forKey:[cd guid]];
    }
    [self.guidGraph setObject:graph forKey:shuffle];
}

-(NSMutableArray*)getNumberOf:(int)successorNumbers SuccessorsForIndexValue:(int)indexOfPredecessor forShuffle:(NSString*)shuffle
{
    NSMutableArray *successors = [[NSMutableArray alloc]init];
    NSMutableArray *cardsInLastShuffle = [self.cardStatesAfterShuffle objectForKey:shuffle];
   
    for(int i = indexOfPredecessor; i < (indexOfPredecessor + successorNumbers); i++)
    {
        if(i >= [cardsInLastShuffle count] - successorNumbers)
        {
            break;
        }
        [successors addObject:[[cardsInLastShuffle objectAtIndex:i + 1] guid]];
    }
    return successors;
    
}

-(void)printGuidGraph
{

    NSArray *keys = [self.guidGraph allKeys];
    for (NSString* key in keys)
    {
        NSMutableDictionary *sequencesForShuffle = [self.guidGraph objectForKey:key];
        NSLog(@"Graph connections for shuffle %@", key);
        NSArray *allPredecessors = [sequencesForShuffle allKeys];
        for (NSString * predecessor in allPredecessors)
        {
            NSLog(@"Guid=%@", predecessor);
            NSMutableArray *successors = [sequencesForShuffle objectForKey:predecessor];
            if(successors != nil && [successors count] > 0)
            {
                for (NSString* successor in successors)
                {
                    NSLog(@"%@", successor);
                }
            }
            else
            {
                NSLog(@"No Successors for this Guid");
            }
        }
        
    }
    
}

-(NSMutableArray *)getAllRepeatedSequencesInLastTwoShuffles
{
    NSMutableDictionary *lastShuffle = [self.guidGraph objectForKey:self.lastShuffleIndex];
    NSMutableDictionary *secondLastShuffle = [self.guidGraph objectForKey: [NSString stringWithFormat:@"%d",([self.lastShuffleIndex intValue] - 1)]];
    NSMutableArray *matchingPairs = [[NSMutableArray alloc] init];
    
    NSArray *keys = [lastShuffle allKeys];
    
    for(NSString* predecessor in keys)
    {
        NSMutableArray *lastSuccessors = [lastShuffle objectForKey:predecessor];
        NSMutableArray *secondLastSuccessors = [secondLastShuffle objectForKey:predecessor];
        NSLog(@" ");
        NSLog(@"lastSuccessors contents = ");
        for (id obj in lastSuccessors)
        {
            NSLog(@"%@", [obj description]);
        }

        NSLog(@"secondLastSuccessors contents = ");
        for (id obj in secondLastSuccessors)
        {
            NSLog(@"%@", [obj description]);
        }

        if(lastSuccessors !=nil && [lastSuccessors count] > 0 && secondLastSuccessors != nil && [secondLastSuccessors count] > 0)
        {
            NSString * lastSuccessorGuid = [lastSuccessors objectAtIndex:0];
            NSString * secondLastSuccessorGuid = [secondLastSuccessors objectAtIndex:0];
            if([lastSuccessorGuid isEqualToString:secondLastSuccessorGuid])
            {
                NSLog(@" ");
                [matchingPairs addObject:[NSString stringWithFormat:@"%@, %@", lastSuccessorGuid, secondLastSuccessorGuid]];
            }
        }
    }
    
    return matchingPairs;
}


-(void)showPositionsOfEachGuidOverShuffles
{
    NSArray *guidNumbers = [self.guidMovements allKeys];
    int i = 0;
    for (NSString * guidNumber in guidNumbers)
    {
        NSLog(@"%d > %@ = [%@]", i,guidNumber, [self.guidMovements objectForKey:guidNumber]);
        i++;
    }

}


-(int)getRandomIndexValue:(int) n
{
    return arc4random_uniform((uint32_t)(n + 1) );
}

@end
