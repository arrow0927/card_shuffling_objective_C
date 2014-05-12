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


-(id)initWithSuits:(NSArray*)suitsArray numberOfCardValues:(NSArray*)cardValues; //Custom Init
-(void)showPositionsOfEachGuidOverShuffles; //Debug Method
-(void)printDeckForLastShuffle;
-(void)shuffleDeckAlgorithmTwoRandomNumbers;
-(void)shuffleDeckAlgorithmOneRandomNumber;
-(void)printGuidGraph;
-(NSMutableArray *)getAllRepeatedSequencesInLastTwoShuffles;
-(void)printRepeatedSequencesOverLastTwoshuffles;
-(NSString*)getNumberOfShuffles;



@end
