//
//  Deck.m
//  coding_two
//
//  Created by AM on 2014-05-09.
//  Copyright (c) 2014 AM. All rights reserved.
//

#import "Deck.h"

@interface Deck ()


@property (nonatomic, strong) NSMutableDictionary *cardPositionsWithinAShuffle;
@property (nonatomic, strong) NSString *lastShuffleNumber;
@property (nonatomic, assign) int numOfSuits; // TO DO-Remove before production
@property (nonatomic, assign) int numOfValues; //TO DO-Remove before production
@property (nonatomic, strong) NSMutableArray *guidArray; //TO DO-Remove before production
@property (nonatomic, strong) NSMutableDictionary *guidMovementTrackerOverShuffles; //TO DO-Remove before production
@property (nonatomic, strong) NSMutableDictionary *predecessorSuccessorGraph;
@property (nonatomic, assign) int sizeOfSequence;

@end


@implementation Deck

# pragma mark -Initializer

-(id)initWithSuits:(NSArray*)suitsArray numberOfCardValues:(NSArray*)cardValuesArray
{
    
    if(self = [super init])
    {
        _cardPositionsWithinAShuffle = [[NSMutableDictionary alloc] initWithCapacity:1];
        _numOfSuits = (int)[suitsArray count];
        _numOfValues = (int)[cardValuesArray count];
        _guidArray = [NSMutableArray arrayWithCapacity:(_numOfSuits * _numOfValues)];
        _guidMovementTrackerOverShuffles = [NSMutableDictionary dictionaryWithCapacity:[_guidArray count]];
        NSMutableArray *tempArrayOfCardObjs  = [NSMutableArray arrayWithCapacity:(_numOfSuits * _numOfValues)];
        _predecessorSuccessorGraph = [[NSMutableDictionary alloc] init];
        _sizeOfSequence = 1;
        int i = 0;
        for (id suit in suitsArray)
        {
            for (id val in cardValuesArray)
            {
                Card *tempCard = [[Card alloc ]initWithSuit:suit
                                                      value:val];
                [tempArrayOfCardObjs addObject:tempCard];
                [_guidArray insertObject:[tempCard guid] atIndex:i];
                NSMutableArray *variousPositionsOverShufflesForThisGuid = [[NSMutableArray alloc] init];
                [variousPositionsOverShufflesForThisGuid addObject:[NSNumber numberWithInt:i]];
                [_guidMovementTrackerOverShuffles setObject:variousPositionsOverShufflesForThisGuid forKey:[tempCard guid]];
                i++;
            }
        }
        NSString *currentShuffleNumber = @"0";
        [_cardPositionsWithinAShuffle setObject:tempArrayOfCardObjs forKey:currentShuffleNumber];
        [self setUpPredecessorSuccessorGraphForShuffleNumber:currentShuffleNumber];
        _lastShuffleNumber = currentShuffleNumber;
        NSLog(@"Initialized Deck.");
        
    }
    return self;
}


# pragma mark - Algorithms

-(void)shuffleDeckAlgorithmTwoRandomNumbers
{
    double startTime = [self getCurrentTimeInMilliseconds];
    NSLog(@"Algorithm Start Time: %f", startTime);
    
    NSMutableArray *cardPositionsForLastShuffleNumber = [self.cardPositionsWithinAShuffle valueForKeyPath:self.lastShuffleNumber];
    NSLog(@"Began Shuffling deck with 2 Random Number Algorithm......");
    NSMutableArray *deepCopyArrayCardPositionsForLastShuffleNumber = [[NSMutableArray alloc] initWithArray:cardPositionsForLastShuffleNumber
                                                                                                 copyItems:YES];
    NSMutableArray *cardPositionsArrayAfterShuffle;
    
    int numberOfCards = (int)[deepCopyArrayCardPositionsForLastShuffleNumber count];
    if(numberOfCards >= 1)
    {
        
        cardPositionsArrayAfterShuffle = [[NSMutableArray alloc] initWithCapacity:numberOfCards];
        for (int i = 0; i < numberOfCards; i++)
        {
            [cardPositionsArrayAfterShuffle addObject:[NSNull null]];
        }
        NSUInteger sourceRandomIndex;
        NSUInteger destinationRandomIndex;
        while((int)[deepCopyArrayCardPositionsForLastShuffleNumber count] > 0 )
        {
            sourceRandomIndex = arc4random_uniform((int)[deepCopyArrayCardPositionsForLastShuffleNumber count]);
            destinationRandomIndex = arc4random_uniform(numberOfCards);
            Card *swapCard = [deepCopyArrayCardPositionsForLastShuffleNumber objectAtIndex:sourceRandomIndex];
            
            if([[cardPositionsArrayAfterShuffle objectAtIndex:destinationRandomIndex] isKindOfClass:[NSNull class]])
            {
                [cardPositionsArrayAfterShuffle replaceObjectAtIndex:destinationRandomIndex withObject:swapCard];
                NSMutableArray *arrayOfGuidPositions = [self.guidMovementTrackerOverShuffles objectForKey:[swapCard guid]];
                NSLog(@"Moving Card from index:%d to index:%d", (int)sourceRandomIndex, (int)destinationRandomIndex);
                [arrayOfGuidPositions addObject:[NSNumber numberWithInt:(int)destinationRandomIndex]];
                [self.guidMovementTrackerOverShuffles setObject:arrayOfGuidPositions forKey:[swapCard guid]];
                [deepCopyArrayCardPositionsForLastShuffleNumber removeObjectAtIndex:sourceRandomIndex];
            }
            else
            {
                continue;
            }
        }
        NSLog(@"Finished Shuffling deck......\n");
        self.lastShuffleNumber = [self incrementLastShuffleNumber];
        [self.cardPositionsWithinAShuffle setObject:cardPositionsArrayAfterShuffle forKey:self.lastShuffleNumber];
        [self setUpPredecessorSuccessorGraphForShuffleNumber:self.lastShuffleNumber];
        
        
    }
    else
    {
        NSLog(@"ERROR! This Deck has no cards");
    }
    double endTime = [self getCurrentTimeInMilliseconds];
    NSLog(@"Algorithm End Time: %f", endTime);
    NSLog(@"Algorithm Run Time: %f", (endTime - startTime));
    
}

-(void)shuffleDeckAlgorithmOneRandomNumber
{
    NSLog(@"Began Shuffling deck using 1 Random Number algorithm ......");
    double startTime = [self getCurrentTimeInMilliseconds];
    NSLog(@"Algorithm Start Time: %f", startTime);
    NSMutableArray *cardPositionsForLastShuffleNumber = [self.cardPositionsWithinAShuffle valueForKeyPath:self.lastShuffleNumber];
    NSMutableArray *deepCopyArrayCardPositionsForLastShuffleNumber = [[NSMutableArray alloc] initWithArray:cardPositionsForLastShuffleNumber
                                                                                                 copyItems:YES];
    NSMutableArray *cardPositionsArrayAfterShuffle = [[NSMutableArray alloc] init];
    
    int numberOfCards = (int)[deepCopyArrayCardPositionsForLastShuffleNumber count];
    if(numberOfCards >= 1)
    {
        NSUInteger sourceRandomIndex;
        while((int)[deepCopyArrayCardPositionsForLastShuffleNumber count] > 0 )
        {
            sourceRandomIndex = arc4random_uniform((int)[deepCopyArrayCardPositionsForLastShuffleNumber count]);
            Card *swapCard = [deepCopyArrayCardPositionsForLastShuffleNumber objectAtIndex:sourceRandomIndex];
            [cardPositionsArrayAfterShuffle addObject:swapCard];
            NSMutableArray *arrayOfGuidPositions = [self.guidMovementTrackerOverShuffles objectForKey:[swapCard guid]];
            NSLog(@"Moving Card from index:%d to index:%d", (int)sourceRandomIndex, (int)[cardPositionsArrayAfterShuffle indexOfObject:swapCard]);
            [arrayOfGuidPositions addObject:[NSNumber numberWithInt:(int)[cardPositionsArrayAfterShuffle indexOfObject:swapCard]]];
            [self.guidMovementTrackerOverShuffles setObject:arrayOfGuidPositions forKey:[swapCard guid]];
            [deepCopyArrayCardPositionsForLastShuffleNumber removeObjectAtIndex:sourceRandomIndex];
        }
        NSLog(@"Finished Shuffling deck......\n");
        self.lastShuffleNumber = [self incrementLastShuffleNumber];
        [self.cardPositionsWithinAShuffle setObject:cardPositionsArrayAfterShuffle forKey:self.lastShuffleNumber];
        [self setUpPredecessorSuccessorGraphForShuffleNumber:self.lastShuffleNumber];
    }
    else
    {
        NSLog(@"ERROR! This Deck has no cards");
    }
    double endTime = [self getCurrentTimeInMilliseconds];
    NSLog(@"Algorithm End Time: %f", endTime);
    NSLog(@"Algorithm Run Time: %f", (endTime - startTime));
}


# pragma mark - print Methods


-(void)printDeckForLastShuffle
{
    NSMutableArray *arrayOfCardsForLastShuffle = [self.cardPositionsWithinAShuffle valueForKeyPath:self.lastShuffleNumber];
    int totalCardNumber = (int)[arrayOfCardsForLastShuffle count];
    NSLog(@"\nDeck for shuffle number %@ has %d cards\n", self.lastShuffleNumber ,totalCardNumber);
    
    
    for (int i =0; i < totalCardNumber; i++)
    {
        NSLog(@"Card[%d]=  %@",i,[[arrayOfCardsForLastShuffle objectAtIndex:i ] description]);
    }
    NSLog(@" ");
}


-(void)printGuidGraph
{
    
    NSArray *keys = [self.predecessorSuccessorGraph allKeys];
    for (NSString* key in keys)
    {
        NSMutableDictionary *sequencesForShuffle = [self.predecessorSuccessorGraph objectForKey:key];
        NSLog(@"Showing Graph connections after shuffle number:%@", key);
        NSArray *allPredecessors = [sequencesForShuffle allKeys];
        for (NSString * predecessor in allPredecessors)
        {
            NSLog(@"(predecessor) %@ ->", predecessor);
            NSMutableArray *successors = [sequencesForShuffle objectForKey:predecessor];
            if(successors != nil && [successors count] > 0)
            {
                for (NSString* successor in successors)
                {
                    NSLog(@"%@ ", successor);
                }
            }
            else
            {
                NSLog(@" XXXXX ");
            }
        }
        
    }
    
}

-(void)showPositionsOfEachGuidOverShuffles
{
    NSLog(@"Showing index positions of Card GUID numbers starting with Deck initialization upto the last shuffle.");
    NSArray *guidNumbers = [self.guidMovementTrackerOverShuffles allKeys];
    int i = 0;
    for (NSString * guidNumber in guidNumbers)
    {
        NSLog(@"<%@> was shuffled over these indices from one shuffle to the next=[%@]",guidNumber, [self.guidMovementTrackerOverShuffles objectForKey:guidNumber]);
        i++;
    }
    
}



# pragma mark - Helper Methods

-(double)getCurrentTimeInMilliseconds
{
    NSTimeInterval seconds = [NSDate timeIntervalSinceReferenceDate];
    
    return seconds * 1000;
}



-(NSString*)incrementLastShuffleNumber
{
    return [NSString stringWithFormat:@"%d",([self.lastShuffleNumber intValue] + 1)];
}


-(void)setUpPredecessorSuccessorGraphForShuffleNumber:(NSString*)shuffle
{
    NSMutableDictionary *graph = [[NSMutableDictionary alloc] init];
    NSMutableArray *cardsInLastShuffle = [self.cardPositionsWithinAShuffle objectForKey:shuffle];

    for(Card *cd  in cardsInLastShuffle)
    {
        int index = (int)[cardsInLastShuffle indexOfObject:cd];
        NSMutableArray *successors = [self getNumberOf:self.sizeOfSequence SuccessorsForIndexValue:index forShuffle:shuffle];
        [graph setObject:successors forKey:[cd guid]];
    }
    [self.predecessorSuccessorGraph setObject:graph forKey:shuffle];
}

-(NSMutableArray*)getNumberOf:(int)successorNumbers SuccessorsForIndexValue:(int)indexOfPredecessor forShuffle:(NSString*)shuffle
{
    NSMutableArray *successors = [[NSMutableArray alloc]init];
    NSMutableArray *cardsInLastShuffle = [self.cardPositionsWithinAShuffle objectForKey:shuffle];
   
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



-(NSMutableArray *)getAllRepeatedSequencesInLastTwoShuffles
{
    NSMutableDictionary *lastShuffle = [self.predecessorSuccessorGraph objectForKey:self.lastShuffleNumber];
    NSMutableDictionary *secondLastShuffle = [self.predecessorSuccessorGraph objectForKey: [NSString stringWithFormat:@"%d",([self.lastShuffleNumber intValue] - 1)]];
    NSMutableArray *matchingPairs = [[NSMutableArray alloc] init];
    
    NSArray *keys = [lastShuffle allKeys];
    NSLog(@"Comparing the successors of a predecesor over the last 2 shuffles to detect repeated sequences");
    for(NSString* predecessor in keys)
    {
        NSLog(@" ");
        NSLog(@"predecessor = %@", predecessor);
        NSMutableArray *lastSuccessors = [lastShuffle objectForKey:predecessor];
        NSLog(@"successor(last shuffle):");
        for (id obj in lastSuccessors)
        {
            NSLog(@"%@", [obj description]);
        }
        NSMutableArray *secondLastSuccessors = [secondLastShuffle objectForKey:predecessor];
        NSLog(@"successor(second from last shuffle):");
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
                NSLog(@"ATTENTION! Duplicate Sequence Found !");
                [matchingPairs addObject:[NSString stringWithFormat:@"[predecessor=%@,successor=%@]",predecessor, lastSuccessorGuid]];
            }
        }
    }
    
    return matchingPairs;
}






-(int)getRandomIndexValue:(int) n
{
    return arc4random_uniform((uint32_t)(n + 1) );
}

@end
