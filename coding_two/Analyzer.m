//
//  Analyzer.m
//  coding_two
//
//  Created by AM on 2014-05-12.
//  Copyright (c) 2014 AM. All rights reserved.
//

#import "Analyzer.h"

@interface Analyzer ()

@property (nonatomic, strong) NSMutableDictionary *analysisLog;
-(double)getCurrentTimeInMilliseconds;
@end



@implementation Analyzer

-(id)init
{
    if(self = [super init])
    {
        _analysisLog = [[NSMutableDictionary alloc ] init];
        NSArray * algorithms = @[@"Algo:1Random",@"Algo:2Random"];
        NSArray * shuffles = @[@"1", @"2"];
        NSArray *metrics = @[@"start_time", @"end_time", @"run_time_ms"];
        
        
        for(NSString * algo in algorithms)
        {
            
            [_analysisLog setObject:[[NSMutableDictionary alloc] init] forKey:algo];
            for(NSString * shuffle in shuffles)
            {
                [[_analysisLog objectForKey:algo] setObject:[[NSMutableDictionary alloc]init]
                                                     forKey:shuffle];
                
                for(NSString * metric in metrics)
                {
                    [[[_analysisLog objectForKey:algo] objectForKey:shuffle]setObject:[NSNull null]
                                                                               forKey:metric];
                }
            }
        }
    }
    
    return self;
}



-(double)getCurrentTimeInMilliseconds
{
    NSTimeInterval seconds = [NSDate timeIntervalSinceReferenceDate];
    int MILLISECONDSINSECONDS = 1000;
    
    return seconds * MILLISECONDSINSECONDS;
}


-(void)calculateDurationForAlgorithm:(NSString*)algorithm shuffle:(NSString*) shuffle
{
    double startTimeMS =[[[[self.analysisLog objectForKey:algorithm] objectForKey:shuffle] objectForKey:@"start_time"]doubleValue];
    double endTimeMS =[[[[self.analysisLog objectForKey:algorithm] objectForKey:shuffle] objectForKey:@"end_time"]doubleValue];
    
    double runtime = endTimeMS - startTimeMS;
    
    [[[self.analysisLog objectForKey:algorithm] objectForKey:shuffle] setObject:[NSString stringWithFormat:@"%f", runtime]
                                                                         forKey:@"run_time_ms"];
    
}

-(void)logStartTimeForAlgorithm:(NSString*)algorithm forShuffleNumber:(NSString*)shuffle
{
    [[[self.analysisLog objectForKey:algorithm] objectForKey :shuffle]
     setObject:[NSNumber numberWithDouble:[self getCurrentTimeInMilliseconds]]forKey:@"start_time"];
}

-(void)logEndTimeForAlgorithm:(NSString*)algorithm forShuffleNumber:(NSString*)shuffle
{
    [[[self.analysisLog objectForKey:algorithm] objectForKey :shuffle]
     setObject:[NSNumber numberWithDouble:[self getCurrentTimeInMilliseconds]]forKey:@"end_time"];
}


-(void)printAnalysis
{
    for(NSString * algo in [self.analysisLog allKeys])
    {
        for(NSString* shuff in [[self.analysisLog objectForKey:algo] allKeys])
        {
            for(NSString * metric in [[[self.analysisLog objectForKey:algo] objectForKey:shuff] allKeys])
            {
                NSLog(@"%@ for shuffle %@ has %@ = %@ milliseconds",algo,shuff, metric, [[[self.analysisLog objectForKey:algo] objectForKey:shuff] objectForKey:metric] );
            }
        }
    }
    
}



@end
