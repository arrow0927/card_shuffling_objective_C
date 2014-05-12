//
//  main.m
//  coding_two
//
//  Created by AM on 2014-05-09.
//  Copyright (c) 2014 AM. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Deck.h"
#import "Analyzer.h"

int main(int argc, const char * argv[])
{

    @autoreleasepool
    {
        //algorithms = @"Algo:1Random", @"Algo:2Random";
        NSArray *deckSuits = @[@"Spade",@"Diamond",@"Club",@"Heart"];
        NSArray *deckValues = @[@"Ace", @"2", @"3", @"4", @"5", @"6", @"7", @"8", @"9", @"10", @"Jack", @"Queen", @"King"];
        Analyzer *analyzer = [[Analyzer alloc]init];
        int numberOfShuffles = 2;
        //Shuffle Number 0 is the state of cards at Deck initiation
        
        NSLog(@"Testing with Algorithm of 2 random number");
        Deck *myDeck = [[Deck alloc] initWithSuits:deckSuits
                                numberOfCardValues:deckValues];
        
        for(int shuffleNumber = 1; shuffleNumber <= numberOfShuffles; shuffleNumber++)
        {
            [myDeck printDeckForLastShuffle];
            [analyzer logStartTimeForAlgorithm:@"Algo:2Random"
                              forShuffleNumber:[NSString stringWithFormat:@"%d",shuffleNumber]];
            [myDeck shuffleDeckAlgorithmTwoRandomNumbers];
            [analyzer logEndTimeForAlgorithm:@"Algo:2Random" forShuffleNumber:[NSString stringWithFormat:@"%d",shuffleNumber]];
            [analyzer calculateDurationForAlgorithm:@"Algo:2Random" shuffle:[NSString stringWithFormat:@"%d",shuffleNumber]];
            [myDeck printGuidGraph];
        }
        [myDeck showPositionsOfEachGuidOverShuffles];
        [myDeck printRepeatedSequencesOverLastTwoshuffles];
        
        NSLog(@"Testing with Algorithm of 1 random number");
        Deck *myDeck2 = [[Deck alloc] initWithSuits:deckSuits
                                 numberOfCardValues:deckValues];
        for(int shuffleNumber = 1; shuffleNumber <= numberOfShuffles; shuffleNumber++)
        {
            [myDeck2 printDeckForLastShuffle];
            [analyzer logStartTimeForAlgorithm:@"Algo:1Random"
                              forShuffleNumber:[NSString stringWithFormat:@"%d",shuffleNumber]];
            [myDeck2 shuffleDeckAlgorithmOneRandomNumber];
            [analyzer logEndTimeForAlgorithm:@"Algo:1Random" forShuffleNumber:[NSString stringWithFormat:@"%d",shuffleNumber]];
            [analyzer calculateDurationForAlgorithm:@"Algo:1Random" shuffle:[NSString stringWithFormat:@"%d",shuffleNumber]];
            [myDeck2 printGuidGraph];
        }
        [myDeck2 showPositionsOfEachGuidOverShuffles];
        [myDeck2 printRepeatedSequencesOverLastTwoshuffles];
        
        
        [analyzer printAnalysis];

        
    }
    return 0;
}

