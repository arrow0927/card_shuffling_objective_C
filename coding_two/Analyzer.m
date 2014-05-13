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
        [_analysisLog setObject:[[NSMutableDictionary alloc] init] forKey: @"Algo:1Random"];
        [_analysisLog setObject:[[NSMutableDictionary alloc] init] forKey: @"Algo:2Random"];
        
    }
    
    return self;
}

-(void)setMetricsForShuffle:(NSString*)shuffle forAlgorithm:(NSString*)algorithm
{
    NSMutableDictionary *shuffles = [self.analysisLog objectForKey:algorithm];
    NSArray *metrics = @[@"start_time", @"end_time", @"run_time_ms"];
    NSMutableArray *metricValues = [[NSMutableArray alloc] initWithArray:@[@"-1", @"-1", @"-1"]];
    NSMutableDictionary *metricDictionary = [[NSMutableDictionary alloc] initWithObjects:metricValues forKeys:metrics];
    [shuffles setObject:metricDictionary forKey:shuffle];
}

-(double)getCurrentTimeInMilliseconds
{
    NSTimeInterval seconds = [NSDate timeIntervalSinceReferenceDate];
    int MILLISECONDSINSECONDS = 1000;
    
    return seconds * MILLISECONDSINSECONDS;
}



-(void)logStartTimeForAlgorithm:(NSString*)algorithm forShuffleNumber:(NSString*)shuffle
{
    [[[self.analysisLog objectForKey:algorithm] objectForKey:shuffle] removeObjectForKey:@"start_time"];
    [[[self.analysisLog objectForKey:algorithm] objectForKey:shuffle] setObject:[NSString stringWithFormat:@"%f",[self getCurrentTimeInMilliseconds]] forKey:@"start_time"];
}

-(void)logEndTimeForAlgorithm:(NSString*)algorithm forShuffleNumber:(NSString*)shuffle
{
    [[[self.analysisLog objectForKey:algorithm] objectForKey:shuffle] removeObjectForKey:@"end_time"];
    [[[self.analysisLog objectForKey:algorithm] objectForKey:shuffle] setObject:[NSString stringWithFormat:@"%f",[self getCurrentTimeInMilliseconds]] forKey:@"end_time"];
}

-(void)calculateDurationForAlgorithm:(NSString*)algorithm shuffle:(NSString*) shuffle
{
    double startTimeMS =[[[[self.analysisLog objectForKey:algorithm] objectForKey:shuffle] objectForKey:@"start_time"]doubleValue];
    double endTimeMS =[[[[self.analysisLog objectForKey:algorithm] objectForKey:shuffle] objectForKey:@"end_time"]doubleValue];
    
    double runtime = endTimeMS - startTimeMS;
    
    
    [[[self.analysisLog objectForKey:algorithm] objectForKey:shuffle] removeObjectForKey:@"run_time_ms"];
    [[[self.analysisLog objectForKey:algorithm] objectForKey:shuffle] setObject:[NSString stringWithFormat:@"%f",runtime] forKey:@"run_time_ms"];

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
