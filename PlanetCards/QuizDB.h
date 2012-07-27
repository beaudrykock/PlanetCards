//
//  QuizDB.h
//  PlanetCards
//
//  Created by Beaudry Kock on 2/18/12.
//  Copyright (c) 2012 Better World Coding. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "SMXMLDocument.h"
#import "QuizQuestion.h"
#import "AppConstants.h"
#import "Utilities.h"

@interface QuizDB : NSObject
{
    NSMutableArray *quizQuestions;
    NSMutableDictionary *quizQuestionsByDifficulty;
    NSMutableArray *questionsAsked; // reset after each quiz
    NSMutableArray *questionsAnsweredCorrectly; // reset after every 3 quizzes
    NSInteger currentDifficultyLevel;
    BOOL lastQuestionWasCorrect;
}

@property (nonatomic) BOOL lastQuestionWasCorrect;
@property (nonatomic) NSInteger currentDifficultyLevel;
@property (nonatomic, retain) NSMutableDictionary *quizQuestionsByDifficulty;
@property (nonatomic, retain) NSMutableArray *quizQuestions;
@property (nonatomic, retain) NSMutableArray *questionsAsked;
@property (nonatomic, retain) NSMutableArray *questionsAnsweredCorrectly;

-(NSInteger)getRandomQuestionNumberWithRecord:(BOOL)record;
-(void)loadContent;
-(NSString*)stringStrippedOfWhitespaceAndNewlines:(NSString*)oldString;
-(void)generateQuestionFromQuizItem:(SMXMLElement*)quizItem;
-(QuizQuestion*)getQuestionNumbered:(NSInteger)questionNumber;
-(BOOL)checkCorrectnessForQuestion:(NSInteger)questionNumber andAnswer:(NSInteger)answerNumber;
-(NSInteger)getRightAnswerIndexForQuestion:(NSInteger)questionNumber;
-(NSInteger)getRandomQuestionNumberFromCurrent:(NSInteger)currentQuestionNumber inNext: (NSInteger)count withMinChoices: (NSInteger)minChoices;
-(NSInteger)getRandomQuestionNumberFromCurrent:(NSInteger)currentQuestionNumber inPrevious: (NSInteger)count withMinChoices: (NSInteger)minChoices;
-(NSInteger)getRandomQuestionNumberWithDifficultyLevel:(NSInteger)difficultyLevel andRecord:(BOOL)record;
-(BOOL)questionIsAskableWithNumber:(NSInteger)questionNumber;
-(void)addQuestionAskedRecord:(NSInteger)questionNumber;
-(NSInteger)getRandomQuestionNumber;
-(UIImage*)getRandomImage;
-(BOOL)questionsAreAvailableAtDifficultyLevel:(NSInteger)level;
-(void)changeDifficultyLevelBy:(NSInteger)change;
-(NSInteger)knowledgeScoreForQuestionNumber:(NSInteger)questionNumber;
-(NSInteger)speedScoreForQuestionNumber:(NSInteger)questionNumber inTimeBlock:(NSInteger)timeBlock;
-(void)resetQuestionsAnsweredCorrectlyRecord;
-(void)resetQuestionsAskedRecord;
-(void)addQuestionAnsweredCorrectlyRecord:(NSInteger)questionNumber;
-(void)writeQuizData;
-(void)readQuizData;

@end
