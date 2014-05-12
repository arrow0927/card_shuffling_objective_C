//
//  Card.m
//  coding_two
//
//  Created by AM on 2014-05-09.
//  Copyright (c) 2014 AM. All rights reserved.
//

#import "Card.h"
#import "NSString+Guid.h"


@interface Card ()

@property (readwrite, assign) NSString *suit;
@property (readwrite, assign) NSString *value;
@property (readwrite, assign) NSString *guid;

@end



@implementation Card


@synthesize suit = _suit;
@synthesize value = _value;
@synthesize guid = _guid;

-(id)initWithSuit:(NSString*)suit value:(NSString*)value
{
    if(self = [super init])
    {
        _suit = suit;
        _value = value;
        _guid = [NSString guid];
    }
    return self;
}


-(NSString*)description
{
    return [NSString stringWithFormat:@"Card[Suit]:%@, Card[Value]:%@, Card[Guid]:%@",self.suit, self.value, self.guid];
}





-(id)copyWithZone:(NSZone *)zone
{
    Card *cardCopy = [[Card allocWithZone:zone] init];
    
    [cardCopy setSuit:self.suit];
    [cardCopy setValue:self.value];
    [cardCopy setGuid:self.guid];
    return cardCopy;
}

@end


