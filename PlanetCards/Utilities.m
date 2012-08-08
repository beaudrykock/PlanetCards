//
//  Utilities.m
//  PlanetCards
//
//  Created by Beaudry Kock on 2/22/12.
//  Copyright (c) 2012 Better World Coding. All rights reserved.
//

#import "Utilities.h"
#import "AppConstants.h"

@implementation Utilities

+(BOOL)hasInternet
{
    Reachability *reachability = [Reachability reachabilityForInternetConnection];
    NetworkStatus internetStatus = [reachability currentReachabilityStatus];
    if (internetStatus != NotReachable) {
        return YES;
    }
    else {
        return NO;
    }
    
}

+(NSString*)cachePath:(NSString *)filename
{
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES);
	NSString *cacheDirectory = [paths objectAtIndex:0];
	NSString *cacheFolder = [cacheDirectory stringByAppendingPathComponent: @"com.scientificplayground.planetcards"];
#ifdef LITE_VERSION
    cacheFolder = [cacheDirectory stringByAppendingPathComponent: @"com.scientificplayground.planetcards.lite"];
#endif
    
    //NSLog(@"cachePath = %@", [cacheFolder stringByAppendingPathComponent: filename]);
    return [cacheFolder stringByAppendingPathComponent: filename];
}

+(BOOL)shouldReset
{
    if ([[NSUserDefaults standardUserDefaults] boolForKey:kResetPreference])
        return [[NSUserDefaults standardUserDefaults] boolForKey:kResetPreference];
    return NO;
}

+(void)clearReset
{
    [[NSUserDefaults standardUserDefaults] setBool:NO forKey:kResetPreference];
}

+(NSString*)getUnitPreference
{
    //NSLog(@"%@", [[NSUserDefaults standardUserDefaults] stringForKey:kUnitPreference]);
    return [[NSUserDefaults standardUserDefaults] stringForKey:kUnitPreference];
}

+(BOOL)vibrationOn
{
    //NSLog(@"Are unit prefs set to vibration on? %i",[[[NSUserDefaults standardUserDefaults] objectForKey:kVibrationKey] boolValue]);
    return [[[NSUserDefaults standardUserDefaults] objectForKey:kVibrationKey] boolValue];
}

// utility function to handle the bug in the simulator where user has to go into preferences page to set preferences
+(void)checkBundleCompleteness
{
    NSUserDefaults *prefs = [NSUserDefaults standardUserDefaults];
    //NSLog(@"%@", [[[NSUserDefaults standardUserDefaults] dictionaryRepresentation] allKeys]);
    
    if (prefs)
    {
        if (nil == [prefs objectForKey:kQuizPlayCountKey])
        {
            [prefs setInteger:0 forKey:kQuizPlayCountKey];
            [prefs synchronize];
        }
    
        if (nil == [prefs objectForKey: kMetricUnitKey])
        {
            [prefs setBool:YES forKey:kMetricUnitKey];
            [prefs synchronize];
        }
    
        if (nil == [prefs objectForKey:kVibrationKey])
        {
            [prefs setBool:NO forKey:kVibrationKey];
            [prefs synchronize];
        }
        
        if (nil == [prefs objectForKey:kResetPreference])
        {
            [prefs setBool:NO forKey:kResetPreference];
            [prefs synchronize];
        }
    }
}

+(void)removeQuizRecords
{
    [[NSUserDefaults standardUserDefaults] setInteger:0 forKey:kAllTimeBestScoreKey];
    [[NSUserDefaults standardUserDefaults] setInteger:-1 forKey:kLastScoreKey];
#ifdef LITE_VERSION
    [[NSUserDefaults standardUserDefaults] setInteger:1 forKey:kLastDifficultyLevelKey];
#else
    [[NSUserDefaults standardUserDefaults] setInteger:4 forKey:kLastDifficultyLevelKey];
#endif
    [[NSUserDefaults standardUserDefaults] setInteger:0 forKey:kQuizPlayCountKey];
    [[NSUserDefaults standardUserDefaults] setInteger:0 forKey:kAnswerTrackingQuizCountKey];
    
    [[NSUserDefaults standardUserDefaults] synchronize];
}

+(void)updateAllTimeBestScore:(NSInteger)newScore
{
    NSInteger existingScore = 0;
    NSUserDefaults *prefs = [NSUserDefaults standardUserDefaults];
    if (prefs)
    {
        if (nil == [prefs objectForKey:kAllTimeBestScoreKey])
        {
            [prefs setInteger:newScore forKey:kAllTimeBestScoreKey];
            [prefs synchronize];
        }
        else
        {
            existingScore = [[prefs objectForKey:kAllTimeBestScoreKey] intValue];
            
            if (existingScore < newScore)
            {
                [prefs setInteger:newScore forKey:kAllTimeBestScoreKey];
                [prefs synchronize];
            }
        }
    }
}

+(NSInteger)getAllTimeBestScore
{
    if ([[NSUserDefaults standardUserDefaults] integerForKey:kAllTimeBestScoreKey])
        return [[NSUserDefaults standardUserDefaults] integerForKey:kAllTimeBestScoreKey];
    return 0;
}

+(void)setLastScore:(NSInteger)lastScore
{
    [[NSUserDefaults standardUserDefaults] setInteger:lastScore forKey:kLastScoreKey];
    [[NSUserDefaults standardUserDefaults] synchronize];
}

+(NSInteger)getLastScore
{
    if ([[NSUserDefaults standardUserDefaults] integerForKey:kLastScoreKey])
        return [[NSUserDefaults standardUserDefaults] integerForKey:kLastScoreKey];
    return -1;
}

+(BOOL)iOS5available
{
    return [[[UIDevice currentDevice] systemVersion] floatValue] >= 5.0;
}


+(void)setLastDifficultyLevel:(NSInteger)lastDifficultyLevel
{
    [[NSUserDefaults standardUserDefaults] setInteger:lastDifficultyLevel forKey:kLastDifficultyLevelKey];
    [[NSUserDefaults standardUserDefaults] synchronize];
}

+(NSInteger)getLastDifficultyLevel
{
    if ([[NSUserDefaults standardUserDefaults] integerForKey:kLastDifficultyLevelKey])
        return [[NSUserDefaults standardUserDefaults] integerForKey:kLastDifficultyLevelKey];
    
#ifdef LITE_VERSION
    return 1;
#else
    return 4;
#endif
}

+(void)setLastStartingQuestionNumber:(NSInteger)questionNumber
{
    [[NSUserDefaults standardUserDefaults] setInteger:questionNumber forKey:kLastStartingQuestionNumberKey];
    [[NSUserDefaults standardUserDefaults] synchronize];
}

+(NSInteger)getLastStartingQuestionNumber
{
    return [[NSUserDefaults standardUserDefaults] integerForKey:kLastStartingQuestionNumberKey];
}

+(NSInteger)quizPlays
{
    return [[NSUserDefaults standardUserDefaults] integerForKey:kQuizPlayCountKey];
}

+(void)addQuizPlay
{
    NSInteger quizPlayCount = [[NSUserDefaults standardUserDefaults] integerForKey:kQuizPlayCountKey];
    quizPlayCount++;
    [[NSUserDefaults standardUserDefaults] setInteger:quizPlayCount forKey:kQuizPlayCountKey];
    [[NSUserDefaults standardUserDefaults] synchronize];
}

+(NSInteger)answerTrackingQuizPlays
{
    return [[NSUserDefaults standardUserDefaults] integerForKey:kAnswerTrackingQuizCountKey];
}

+(void)addAnswerTrackingQuizPlay
{
    NSInteger quizPlayCount = [[NSUserDefaults standardUserDefaults] integerForKey:kAnswerTrackingQuizCountKey];
    quizPlayCount++;
    [[NSUserDefaults standardUserDefaults] setInteger:quizPlayCount forKey:kAnswerTrackingQuizCountKey];
    [[NSUserDefaults standardUserDefaults] synchronize];
}

+(void)resetAnswerTrackingQuizPlays
{
    [[NSUserDefaults standardUserDefaults] setInteger:0 forKey:kAnswerTrackingQuizCountKey];
    [[NSUserDefaults standardUserDefaults] synchronize];
}

@end
