//
//  main.m
//  coding_two
//
//  Created by AM on 2014-05-09.
//  Copyright (c) 2014 AM. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Deck.h"

int main(int argc, const char * argv[])
{

    @autoreleasepool
    {
        NSArray *deckSuits = @[@"Spade",@"Diamond",@"Club",@"Heart"];
        NSArray *deckValues = @[@"Ace", @"2", @"3", @"4", @"5", @"6", @"7", @"8", @"9", @"10", @"Jack", @"Queen", @"King"];
        
        Deck *myDeck = [[Deck alloc] initWithSuits:deckSuits
                                numberOfCardValues:deckValues];
        
       NSMutableDictionary * repeatedSequencesByAlgorithm = [[NSMutableDictionary alloc] init];
        
        //Test the output with shuffle algorithm of 2 random numbers
        NSMutableArray *repeatedSequences2Randoms = [[NSMutableArray alloc] init];
        for(int i = 0; i < 2; i++)
        {
            [myDeck printDeckForLastShuffle];
            [myDeck shuffleDeckAlgorithmTwoRandomNumbers];
            
            [myDeck showPositionsOfEachGuidOverShuffles];
            [myDeck printGuidGraph];
            NSMutableArray *repeatedSequences = [myDeck getAllRepeatedSequencesInLastTwoShuffles];
            NSLog(@"Repeated pairs in last 2 shuffles = ");
            for(NSString * repeatPair in repeatedSequences)
            {
                NSLog(@"%@", repeatPair);
                [repeatedSequences2Randoms addObject:repeatPair];
            }
        }
        [repeatedSequencesByAlgorithm setObject:repeatedSequences2Randoms
                                         forKey:@"2Random"];
        

        Deck *myDeck2 = [[Deck alloc] initWithSuits:deckSuits
                                numberOfCardValues:deckValues];

        //Test the output with shuffle algorithm of 1 random number
        NSMutableArray *repeatedSequences1Randoms = [[NSMutableArray alloc] init];
        for(int i = 0; i < 2; i++)
        {
            [myDeck2 printDeckForLastShuffle];
            [myDeck2 shuffleDeckAlgorithmOneRandomNumber];
            
            [myDeck2 showPositionsOfEachGuidOverShuffles];
            [myDeck2 printGuidGraph];
            NSMutableArray *repeatedSequences2 = [myDeck2 getAllRepeatedSequencesInLastTwoShuffles];
            NSLog(@" ");
            NSLog(@"Conclusion= The following pairs of sequences were detected as repeated pairs in last 2 shuffles = ");
            for(NSString * repeatPair in repeatedSequences2)
            {
                NSLog(@"%@", repeatPair);
                [repeatedSequences1Randoms addObject:repeatPair];
                
            }
        }
        [repeatedSequencesByAlgorithm setObject:repeatedSequences1Randoms
                                         forKey:@"1Random"];
        
        
        
    }
    return 0;
}

