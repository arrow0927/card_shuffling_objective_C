//
//  Card.h
//  coding_two
//
//  Created by AM on 2014-05-09.
//  Copyright (c) 2014 AM. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Card : NSObject <NSCopying>

@property (readonly) NSString *suit;
@property (readonly) NSString *value;

/* Category*/
@property (readonly) NSString *guid;



-(id)initWithSuit:(NSString*)suit value:(NSString*)value;
-(NSString*)showCardWithoutGUID;

@end
