//
//  Deck.h
//  coding_two
//
//  Created by AM on 2014-05-09.
//  Copyright (c) 2014 AM. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Card.h"
#import "Analyzer.h"

@interface Deck : NSObject

/* Deck size is computed from suits array and card values */
-(id)initWithSuits:(NSArray*)suitsArray numberOfCardValues:(NSArray*)cardValues;


-(void)printDeckForLastShuffle;

/* This algorithm uses 2 random numbers: 
 1 random number to find a random index from the unshuffled deck of cards
 2nd random number to find a random index in the unshuffled deck of cards
 */
-(void)shuffleDeckAlgorithmTwoRandomNumbers;

/* This algorithm uses 1 random number:
 1 random number to find a random index from the unshuffled deck of cards
 Cards are inserted sequentially in the destination(shuffled) array
 */
-(void)shuffleDeckAlgorithmOneRandomNumber;

/* This method detects repeated sequences in the last 2 shuffles
    Then takes the GUID values of the cards in the sequence and converts them into NSStrings and inserts them into an array.
    The method retruns and array of NStrings where each element is a unique repeated sequence detected in the shuffles.
 
 */
-(NSMutableArray *)getAllRepeatedSequencesInLastTwoShuffles;

/*
 Shuffle number 0 is the original setup of the deck
 Shuffle number 1 is the first shuffle.
 All computations are based on this
 */
-(NSString*)getNumberOfShuffles;



@end
