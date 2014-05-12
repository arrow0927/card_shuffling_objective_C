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
        
        NSArray *deckSuits = @[@"Spade",@"Diamond",@"Club",@"Heart"];
        NSArray *deckValues = @[@"Ace", @"2", @"3", @"4", @"5", @"6", @"7", @"8", @"9", @"10", @"Jack", @"Queen", @"King"];
        Analyzer *analyzer = [[Analyzer alloc]init];
        int numberOfShuffles = 2;
        //Shuffle Number 0 is the state of cards at Deck initiation
        
        
        
        //algorithm = @"Algo:1Random"
        Deck *myDeck = [[Deck alloc] initWithSuits:deckSuits
                                numberOfCardValues:deckValues];
        [myDeck printDeckForLastShuffle];
        for(int shuffleNumber = 1; shuffleNumber <= numberOfShuffles; shuffleNumber++)
        {
            NSLog(@"\t\tAlgorithm of 2 random numbers, Shuffle Number= %d",shuffleNumber);
            [analyzer logStartTimeForAlgorithm:@"Algo:2Random"
                              forShuffleNumber:[NSString stringWithFormat:@"%d",shuffleNumber]];
            [myDeck shuffleDeckAlgorithmTwoRandomNumbers];
            [analyzer logEndTimeForAlgorithm:@"Algo:2Random" forShuffleNumber:[NSString stringWithFormat:@"%d",shuffleNumber]];
            [analyzer calculateDurationForAlgorithm:@"Algo:2Random" shuffle:[NSString stringWithFormat:@"%d",shuffleNumber]];
            [myDeck printDeckForLastShuffle];
            
        }
        [myDeck printGuidGraph];
        [myDeck showPositionsOfEachGuidOverShuffles];
        [myDeck printRepeatedSequencesOverLastTwoshuffles];
        int repeatSequenceCountAlgo2 = (int)[[myDeck getAllRepeatedSequencesInLastTwoShuffles] count];
        
        
        
        //algorithm = @"Algo:2Random"
        Deck *myDeck2 = [[Deck alloc] initWithSuits:deckSuits
                                 numberOfCardValues:deckValues];
        [myDeck2 printDeckForLastShuffle];
        for(int shuffleNumber = 1; shuffleNumber <= numberOfShuffles; shuffleNumber++)
        {
            NSLog(@"\t\tAlgorithm of 1 random number, Shuffle Number= %d",shuffleNumber);
            
            [analyzer logStartTimeForAlgorithm:@"Algo:1Random"
                              forShuffleNumber:[NSString stringWithFormat:@"%d",shuffleNumber]];
            [myDeck2 shuffleDeckAlgorithmOneRandomNumber];
            [analyzer logEndTimeForAlgorithm:@"Algo:1Random" forShuffleNumber:[NSString stringWithFormat:@"%d",shuffleNumber]];
            [analyzer calculateDurationForAlgorithm:@"Algo:1Random" shuffle:[NSString stringWithFormat:@"%d",shuffleNumber]];
            [myDeck2 printDeckForLastShuffle];
            
        }
        [myDeck2 printGuidGraph];
        [myDeck2 showPositionsOfEachGuidOverShuffles];
        [myDeck2 printRepeatedSequencesOverLastTwoshuffles];
        int repeatSequenceCountAlgo1 = (int)[[myDeck getAllRepeatedSequencesInLastTwoShuffles] count];
        
        [analyzer printAnalysis];
        NSLog(@"Algorithm with 1 random number produced %d sequences of repeats", repeatSequenceCountAlgo1);
        NSLog(@"Algorithm with 2 random numbers produced %d sequences of repeats", repeatSequenceCountAlgo2);
        
    }
    return 0;
}

