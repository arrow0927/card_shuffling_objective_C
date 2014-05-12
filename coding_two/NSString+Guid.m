//
//  NSString+Guid.m
//  coding_two
//
//  Created by AM on 2014-05-09.
//  Copyright (c) 2014 AM. All rights reserved.
//

#import "NSString+Guid.h"

@implementation NSString (Guid)


+(NSString*)guid
{
    return [[NSUUID UUID] UUIDString];
}

@end
