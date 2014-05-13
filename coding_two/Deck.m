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
@property (nonatomic, strong) NSMutableArray *guidArray; //TO DO-Remove before production

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
        int numOfSuits = (int)[suitsArray count];
        int numOfValues = (int)[cardValuesArray count];
        _guidArray = [NSMutableArray arrayWithCapacity:(numOfSuits * numOfValues)];
       
        NSMutableArray *tempArrayOfCardObjs  = [NSMutableArray arrayWithCapacity:(numOfSuits * numOfValues)];
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
                
                i++;
            }
        }
        NSString *currentShuffleNumber = @"0";
        [_cardPositionsWithinAShuffle setObject:tempArrayOfCardObjs forKey:currentShuffleNumber];
        
        _lastShuffleNumber = currentShuffleNumber;
        NSLog(@"Initialized Deck.");
        
    }
    return self;
}


# pragma mark - Algorithms

-(void)shuffleDeckAlgorithmTwoRandomNumbers
{
    
    NSMutableArray *cardPositionsForLastShuffleNumber = [self.cardPositionsWithinAShuffle valueForKeyPath:self.lastShuffleNumber];
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
    
    
}

-(void)shuffleDeckAlgorithmOneRandomNumber
{
    //NSLog(@"Began Shuffling deck using 1 Random Number algorithm ......");
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
}


# pragma mark - print Methods


-(void)printDeckForLastShuffle
{
    NSMutableArray *arrayOfCardsForLastShuffle = [self.cardPositionsWithinAShuffle valueForKeyPath:self.lastShuffleNumber];
    int totalCardNumber = (int)[arrayOfCardsForLastShuffle count];
    if([self.lastShuffleNumber  isEqual: @"0"] )
    {
        NSLog(@"\nCard positions after initializing a new Deck (before any shuffling) are as follows\n");
    }
    else
    {
        NSLog(@"\nCard positions after shuffle number %@ are as follows\n", self.lastShuffleNumber);
    }

    
    for (int i =0; i < totalCardNumber; i++)
    {
        NSLog(@"Deck[%d]=  %@",i,[[arrayOfCardsForLastShuffle objectAtIndex:i ] showCardWithoutGUID]);
    }
    NSLog(@" ");
}


-(void)printGuidGraph
{
    
    NSArray *keys = [self.predecessorSuccessorGraph allKeys];
    for (NSString* key in keys)
    {
        NSMutableDictionary *sequencesForShuffle = [self.predecessorSuccessorGraph objectForKey:key];
        NSLog(@"\nShowing Graph connections after shuffle number:%@", key);
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



# pragma mark - Helper Methods

-(NSString*)getNumberOfShuffles
{
    return [NSString stringWithFormat:@"%d",([self.lastShuffleNumber intValue])];
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
    for(NSString* predecessor in keys)
    {
        
        NSMutableArray *lastSuccessors = [lastShuffle objectForKey:predecessor];
        
        NSMutableArray *secondLastSuccessors = [secondLastShuffle objectForKey:predecessor];
        

        if(lastSuccessors !=nil && [lastSuccessors count] > 0 && secondLastSuccessors != nil && [secondLastSuccessors count] > 0)
        {
            NSString * lastSuccessorGuid = [lastSuccessors objectAtIndex:0];
            NSString * secondLastSuccessorGuid = [secondLastSuccessors objectAtIndex:0];
            if([lastSuccessorGuid isEqualToString:secondLastSuccessorGuid])
            {
                [matchingPairs addObject:[NSString stringWithFormat:@"[predecessor=%@, successor=%@]",predecessor, lastSuccessorGuid]];
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
