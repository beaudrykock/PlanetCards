//
//  QuizQuestion.h
//  PlanetCards
//
//  Created by Beaudry Kock on 2/18/12.
//  Copyright (c) 2012 Better World Coding. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "QuizAnswer.h"

@interface QuizQuestion : NSObject
{
    NSNumber* level;
    NSString* question;
    NSMutableArray* quizAnswers;
    NSString *questionImageFilename;
    
}

@property (nonatomic, retain) NSNumber*level;
@property (nonatomic, retain) NSString *question;
@property (nonatomic, retain) NSMutableArray *quizAnswers;
@property (nonatomic, retain) NSString *questionImageFilename;

-(void)addAnswerWithString:(NSString*)answerStr andIsRight:(NSNumber*)isRight;
-(void)setup;
-(void)randomizeAnswers;
-(NSString*)questionImageFilenameWithoutType;
-(BOOL)isAnswerRight:(NSInteger)answerNumber;
-(NSInteger)getRightAnswerIndex;
-(NSInteger)answerCount;

@end
