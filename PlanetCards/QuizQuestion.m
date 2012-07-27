//
//  QuizQuestion.m
//  PlanetCards
//
//  Created by Beaudry Kock on 2/18/12.
//  Copyright (c) 2012 Better World Coding. All rights reserved.
//

#import "QuizQuestion.h"

@implementation QuizQuestion

@synthesize question,questionImageFilename,quizAnswers,level,supplementalInfo, masterArrayIndex;

-(void)setup
{
    quizAnswers = [NSMutableArray arrayWithCapacity:4];
}

-(void)addAnswerWithString:(NSString*)answerStr andIsRight:(NSNumber*)isRight
{
    QuizAnswer *newAnswer = [[QuizAnswer alloc] init];
    [newAnswer setAnswer:answerStr];
    [newAnswer setIsRight:isRight];
    
    [quizAnswers addObject:newAnswer];
    [newAnswer release];
    
}

-(NSString*)questionImageFilenameWithoutType
{
    NSString *cleanFilename = [questionImageFilename stringByReplacingOccurrencesOfString: @".png" withString: @""];
    
   return cleanFilename;
}

-(BOOL)isAnswerRight:(NSInteger)answerNumber
{
    return [[[quizAnswers objectAtIndex:answerNumber] isRight] boolValue];
}

-(NSInteger)getRightAnswerIndex
{
    BOOL found = NO;
    NSInteger count = 0;
    NSInteger index = 0;
    while (!found && count <[quizAnswers count])
    {
        if ([[[quizAnswers objectAtIndex:count] isRight] boolValue])
        {
            found = YES;
            index = count;
        }
        else
        {
            count++;
        }
    }
    return index;
}

-(void)randomizeAnswers
{
    NSUInteger count = [quizAnswers count];
    for (NSUInteger i = 0; i < count; ++i) {
        // Select a random element between i and end of array to swap with.
        int nElements = count - i;
        int n = (arc4random() % nElements) + i;
        [quizAnswers exchangeObjectAtIndex:i withObjectAtIndex:n];
    } 
    [quizAnswers retain];
}

-(NSInteger)answerCount
{
    return [quizAnswers count];
}

-(void)dealloc
{
    [question release];
    [questionImageFilename release];
    [quizAnswers release];
    [super dealloc];
}

@end
