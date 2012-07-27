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

+(BOOL)reset;
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
+(void)addQuizPlay;
+(NSInteger)quizPlays;
+(void)addAnswerTrackingQuizPlay;
+(NSInteger)answerTrackingQuizPlays;
+(void)resetAnswerTrackingQuizPlays;
+(BOOL)shouldReset;
+(void)clearReset;
+(void)removeQuizRecords;

@end
