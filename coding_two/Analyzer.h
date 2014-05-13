//
//  Analyzer.h
//  coding_two
//
//  Created by AM on 2014-05-12.
//  Copyright (c) 2014 AM. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Analyzer : NSObject



-(void)calculateDurationForAlgorithm:(NSString*)algorithm shuffle:(NSString*) shuffle;
-(void)logStartTimeForAlgorithm:(NSString*)algorithm forShuffleNumber:(NSString*)shuffle;
-(void)logEndTimeForAlgorithm:(NSString*)algorithm forShuffleNumber:(NSString*)shuffle;
-(void)printAnalysis;
-(void)setMetricsForShuffle:(NSString*)shuffle forAlgorithm:(NSString*)algorithm;
@end
