//
//  Deck.h
//  coding_two
//
//  Created by AM on 2014-05-09.
//  Copyright (c) 2014 AM. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Card.h"

@interface Deck : NSObject


-(void)showPositionsOfEachGuidOverShuffles;
-(id)initWithSuits:(NSArray*)suitsArray numberOfCardValues:(NSArray*)cardValues;
-(void)printDeck;
-(void)shuffleDeck;
-(void)printGuidGraph;
-(NSMutableArray *)getAllRepeatedSequencesInLastTwoShuffles;



@end
