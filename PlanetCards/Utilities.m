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

+(NSString*)getUnitPreference
{
    NSLog(@"%@", [[NSUserDefaults standardUserDefaults] stringForKey:kUnitPreference]); 
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
    NSLog(@"%@", [[[NSUserDefaults standardUserDefaults] dictionaryRepresentation] allKeys]);
    
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
    }
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
    return [[[NSUserDefaults standardUserDefaults] objectForKey:kAllTimeBestScoreKey] intValue];
}

+(void)setLastScore:(NSInteger)lastScore
{
    [[NSUserDefaults standardUserDefaults] setInteger:lastScore forKey:kLastScoreKey];
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
}

+(NSInteger)getLastStartingQuestionNumber
{
    return [[NSUserDefaults standardUserDefaults] integerForKey:kLastStartingQuestionNumberKey];
}

@end
