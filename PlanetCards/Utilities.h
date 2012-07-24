//
//  Utilities.h
//  PlanetCards
//
//  Created by Beaudry Kock on 2/22/12.
//  Copyright (c) 2012 Better World Coding. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Utilities : NSObject
{
    
}

+(BOOL)vibrationOn;
+(void)checkBundleCompleteness;
+(NSInteger)getAllTimeBestScore;
+(void)updateAllTimeBestScore:(NSInteger)newScore;
+(BOOL)iOS5available;
+(NSString*)getUnitPreference;
+(void)setLastScore:(NSInteger)lastScore;
+(NSInteger)getLastScore;
+(void)setLastDifficultyLevel:(NSInteger)lastDifficultyLevel;
+(NSInteger)getLastDifficultyLevel;
+(void)setLastStartingQuestionNumber:(NSInteger)questionNumber;
+(NSInteger)getLastStartingQuestionNumber;
@end
