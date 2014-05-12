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
        
        
        [myDeck printDeck];
        [myDeck shuffleDeck];
        [myDeck printDeck];
        [myDeck shuffleDeck];
        [myDeck printDeck];
        [myDeck shuffleDeck];
        [myDeck printDeck];
        [myDeck shuffleDeck];
        [myDeck printDeck];
        
        [myDeck showPositionsOfEachGuidOverShuffles];
        [myDeck printGuidGraph];
        NSMutableArray *repeatedSequences = [myDeck getAllRepeatedSequencesInLastTwoShuffles];
        NSLog(@"Repeated pairs in last 2 shuffles = ");
        for(NSString * repeatPair in repeatedSequences)
        {
            NSLog(@"%@", repeatPair);
        }
        
        
    }
    return 0;
}

