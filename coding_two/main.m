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
        

        //Shuffle using one type of algorithm
        Deck *myDeck = [[Deck alloc] initWithSuits:deckSuits
                                numberOfCardValues:deckValues];
        NSLog(@"Shuffling using 1st Algorithm which uses 2 random numbers");
        [myDeck printDeckForLastShuffle];
        int repeatSequenceCountAlgo2 = 0;
        
        for(int shuffleNumber = 1; shuffleNumber <= numberOfShuffles; shuffleNumber++)
        {
            NSLog(@"Shuffling Deck %d time",shuffleNumber);
            
            [analyzer setMetricsForShuffle:[NSString stringWithFormat:@"%d", shuffleNumber] forAlgorithm:@"Algo:2Random"];
            [analyzer logStartTimeForAlgorithm:@"Algo:2Random" forShuffleNumber:[NSString stringWithFormat:@"%d",shuffleNumber]];
                
            [myDeck shuffleDeckAlgorithmTwoRandomNumbers];
            
            [analyzer logEndTimeForAlgorithm:@"Algo:2Random" forShuffleNumber:[NSString stringWithFormat:@"%d",shuffleNumber]];
            [analyzer calculateDurationForAlgorithm:@"Algo:2Random" shuffle:[NSString stringWithFormat:@"%d",shuffleNumber]];
            [myDeck printDeckForLastShuffle];
            
        }
        repeatSequenceCountAlgo2 = (int)[[myDeck getAllRepeatedSequencesInLastTwoShuffles] count];
        if(repeatSequenceCountAlgo2 > 0)
        {
            while (repeatSequenceCountAlgo2 > 0)
            {
                NSLog(@"Detected %d repeated sequences after shuffling for %@ times.\nWe will try to go for 1 more shuffle and see if we get no repeated sequences", repeatSequenceCountAlgo2, [myDeck getNumberOfShuffles]);
                NSString* shuffleNumber = [NSString stringWithFormat:@"%d",([[myDeck getNumberOfShuffles] intValue] + 1) ];
                NSLog(@"Shuffling Deck %@ time",shuffleNumber);

                [analyzer setMetricsForShuffle:shuffleNumber forAlgorithm:@"Algo:2Random"];
                [analyzer logStartTimeForAlgorithm:@"Algo:2Random" forShuffleNumber:shuffleNumber];
                
                [myDeck shuffleDeckAlgorithmTwoRandomNumbers];
                
                [analyzer logEndTimeForAlgorithm:@"Algo:2Random" forShuffleNumber:shuffleNumber];
                [analyzer calculateDurationForAlgorithm:@"Algo:2Random" shuffle:shuffleNumber];
                [myDeck printDeckForLastShuffle];
                repeatSequenceCountAlgo2 = (int)[[myDeck getAllRepeatedSequencesInLastTwoShuffles] count];
            }
        }
       
        NSLog(@"No repeated sequences found after shuffling for %@ times",[myDeck getNumberOfShuffles]);
       

       
        
        
        //Now Shuffle using another type of algorithm
        NSLog(@"\nShuffling using 2nd Algorithm which uses 1 random numbers");
        Deck *myDeck1 = [[Deck alloc] initWithSuits:deckSuits
                                 numberOfCardValues:deckValues];
        [myDeck1 printDeckForLastShuffle];
        int repeatSequenceCountAlgo1 = 0;
        
        
        for(int shuffleNumber = 1; shuffleNumber <= numberOfShuffles; shuffleNumber++)
        {
            NSLog(@"Shuffling Deck %d time",shuffleNumber);
            
            [analyzer setMetricsForShuffle:[NSString stringWithFormat:@"%d", shuffleNumber] forAlgorithm:@"Algo:1Random"];
            [analyzer logStartTimeForAlgorithm:@"Algo:1Random"
                              forShuffleNumber:[NSString stringWithFormat:@"%d",shuffleNumber]];
                
            [myDeck1 shuffleDeckAlgorithmOneRandomNumber];
                
            [analyzer logEndTimeForAlgorithm:@"Algo:1Random" forShuffleNumber:[NSString stringWithFormat:@"%d",shuffleNumber]];
            [analyzer calculateDurationForAlgorithm:@"Algo:1Random" shuffle:[NSString stringWithFormat:@"%d",shuffleNumber]];
            [myDeck1 printDeckForLastShuffle];
            
        }
        repeatSequenceCountAlgo1 = (int)[[myDeck1 getAllRepeatedSequencesInLastTwoShuffles] count];
        
        if(repeatSequenceCountAlgo1 > 0)
        {
            while (repeatSequenceCountAlgo1 > 0)
            {
                NSLog(@"Detected %d repeated sequences after shuffling for %@ times.\nWe will try to go for 1 more shuffleand see if we get no repeated sequences", repeatSequenceCountAlgo1, [myDeck1 getNumberOfShuffles]);
                NSString* shuffleNumber = [NSString stringWithFormat:@"%d",([[myDeck1 getNumberOfShuffles] intValue] + 1) ];
                NSLog(@"Shuffling Deck %@ time",shuffleNumber);
                
                [analyzer setMetricsForShuffle:shuffleNumber forAlgorithm:@"Algo:1Random"];
                [analyzer logStartTimeForAlgorithm:@"Algo:1Random" forShuffleNumber:shuffleNumber];
                
                [myDeck1 shuffleDeckAlgorithmOneRandomNumber];
                
                [analyzer logEndTimeForAlgorithm:@"Algo:1Random" forShuffleNumber:shuffleNumber];
                [analyzer calculateDurationForAlgorithm:@"Algo:1Random" shuffle:shuffleNumber];
                [myDeck1 printDeckForLastShuffle];
                repeatSequenceCountAlgo1 = (int)[[myDeck1 getAllRepeatedSequencesInLastTwoShuffles] count];
            }
    
        }
        
        NSLog(@"No repeated sequences found after shuffling for %@ times\n\n",[myDeck1 getNumberOfShuffles]);
        
        
        
        
        
        NSLog(@"Printing analysis of the 2 shuffling algorithms used in this program:");
        NSLog(@"Run times of shuffle method");
        [analyzer printAnalysis];
        NSLog(@"Number of shuffles needed to achieve no repeats");
        
        NSLog(@"Algorithm with 2 random numbers produced %d sequences of repeats", repeatSequenceCountAlgo2);
        NSLog(@"Algorithm with 2 random numbers  took %@ tries to reach 0 repeated sequences", [myDeck getNumberOfShuffles]);
        
        NSLog(@"Algorithm with 1 random number produced %d sequences of repeats", repeatSequenceCountAlgo1);
        NSLog(@"Algorithm with 1 random number  took %@ tries to reach 0 repeated sequences", [myDeck1 getNumberOfShuffles]);
        
    }
    return 0;
}

