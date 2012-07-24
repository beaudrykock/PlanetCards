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
    NSInteger level;
    NSString* question;
    NSMutableArray* quizAnswers;
    NSString *questionImageFilename;
    NSString *supplementalInfo;
    NSInteger masterArrayIndex;
}

@property (nonatomic, retain) NSString *supplementalInfo;
@property (nonatomic) NSInteger level;
@property (nonatomic, retain) NSString *question;
@property (nonatomic, retain) NSMutableArray *quizAnswers;
@property (nonatomic, retain) NSString *questionImageFilename;
@property (nonatomic) NSInteger masterArrayIndex;

-(void)addAnswerWithString:(NSString*)answerStr andIsRight:(NSNumber*)isRight;
-(void)setup;
-(void)randomizeAnswers;
-(NSString*)questionImageFilenameWithoutType;
-(BOOL)isAnswerRight:(NSInteger)answerNumber;
-(NSInteger)getRightAnswerIndex;
-(NSInteger)answerCount;

@end
