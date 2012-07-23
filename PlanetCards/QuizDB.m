//
//  QuizDB.m
//  PlanetCards
//
//  Created by Beaudry Kock on 2/18/12.
//  Copyright (c) 2012 Better World Coding. All rights reserved.
//

#import "QuizDB.h"

@implementation QuizDB

@synthesize quizQuestions, questionsAsked;

-(void)loadContent
{
    quizQuestions = [[NSMutableArray alloc] initWithCapacity:200];
    
    NSString *objectXML = [[NSBundle mainBundle] pathForResource:@"PlanetCardsQuizData" ofType:@"xml"];
	NSData *data = [NSData dataWithContentsOfFile:objectXML];
    
    // create a new SMXMLDocument with the contents of sample.xml
	SMXMLDocument *document = [SMXMLDocument documentWithData:data error:NULL];
    
	// demonstrate -description of document/element classes
	//NSLog(@"Document:\n %@", document);
    
    // Pull out the <rdf> node
	SMXMLElement *root = document.root;
    
    for (SMXMLElement *quizItem in [root childrenNamed:kQuizItem])
    {
        [self generateQuestionFromQuizItem: quizItem];
    }
    
    questionsAsked = [[NSMutableArray arrayWithCapacity:60] retain];
}

-(UIImage*)getRandomImage
{
    QuizQuestion *randQuestion = [self getQuestionNumbered: [self getRandomQuestionNumber]];
    
    UIImage *image = [UIImage imageWithContentsOfFile:[[NSBundle mainBundle] pathForResource:[randQuestion questionImageFilenameWithoutType] ofType:@"png"]];
    
    return image;
}

-(BOOL)questionIsAskableWithNumber:(NSInteger)questionNumber
{
    BOOL questionInArray = [questionsAsked containsObject:[NSNumber numberWithInt:questionNumber]];
    if (questionInArray) return NO;
    return YES;
}

-(void)addQuestionAskedRecord:(NSInteger)questionNumber;
{
    if ([questionsAsked count]==60)
    {
        [questionsAsked removeAllObjects];
    }
    
    [questionsAsked addObject:[NSNumber numberWithInt:questionNumber]];
}

-(NSInteger)getRandomQuestionNumberFromCurrent:(NSInteger)currentQuestionNumber inNext: (NSInteger)count withMinChoices: (NSInteger)minChoices
{
    NSInteger finalChoice = 0;
    
    NSMutableArray *candidates = [NSMutableArray arrayWithCapacity:5];
    QuizQuestion *newQuestion = nil;
    NSInteger index = currentQuestionNumber+1;
    
    while ([candidates count]<count && index<[quizQuestions count])
    {
        newQuestion = [self getQuestionNumbered:index];
        
        if ([newQuestion answerCount]>=minChoices && [self questionIsAskableWithNumber:index])
        {
            [candidates addObject:[NSNumber numberWithInt:index]];
        }
        else
        {
            index++;
        }
    }
    
    // case where no candidates
    if ([candidates count]==0)
        [candidates addObject:[NSNumber numberWithInt:[self getRandomQuestionNumber]]];
    
    finalChoice = [[candidates objectAtIndex:arc4random_uniform([candidates count])] intValue];
    
    [self addQuestionAskedRecord:finalChoice];
    
    return finalChoice;
}

-(NSInteger)getRandomQuestionNumberFromCurrent:(NSInteger)currentQuestionNumber inPrevious: (NSInteger)count withMinChoices: (NSInteger)minChoices
{
    NSInteger finalChoice = 0;
    
    NSMutableArray *candidates = [NSMutableArray arrayWithCapacity:5];
    QuizQuestion *newQuestion = nil;
    NSInteger index = currentQuestionNumber-1;
    
    while ([candidates count]<count && index<[quizQuestions count])
    {
        newQuestion = [self getQuestionNumbered:index];
        
        if ([newQuestion answerCount]>=minChoices && [self questionIsAskableWithNumber:index])
        {
            [candidates addObject:[NSNumber numberWithInt:index]];
        }
        else
        {
            index--;
        }
    }
    
    // case where no candidates
    if ([candidates count]==0)
        [candidates addObject:[NSNumber numberWithInt:[self getRandomQuestionNumber]]];
    
    finalChoice = [[candidates objectAtIndex:arc4random_uniform([candidates count])] intValue];
    
    [self addQuestionAskedRecord:finalChoice];
    
    return finalChoice;
}

-(NSInteger)getRandomQuestionNumber
{
    BOOL found = NO;
    NSInteger questionNbr = 0;
    while (!found)
    {
        questionNbr = arc4random_uniform(99);
        
        if ([self questionIsAskableWithNumber:questionNbr])
        {
            found = YES;
        }
    }
    
    return questionNbr;
}

-(QuizQuestion*)getQuestionNumbered:(NSInteger)questionNumber
{
    return [quizQuestions objectAtIndex:questionNumber];
}

-(BOOL)checkCorrectnessForQuestion:(NSInteger)questionNumber andAnswer:(NSInteger)answerNumber
{
    QuizQuestion *question = [self getQuestionNumbered:questionNumber];
    
    return [question isAnswerRight:answerNumber];
}

-(NSInteger)getRightAnswerIndexForQuestion:(NSInteger)questionNumber
{
    QuizQuestion *question = [self getQuestionNumbered:questionNumber];
    
    return [question getRightAnswerIndex];
}

#pragma mark -
#pragma mark XML data file parsing using TBXML
/*
 * Generates a parameterized QuizQuestion on the basis of a SMXMLElement
 * 
 */
-(void)generateQuestionFromQuizItem:(SMXMLElement*)quizItem 
{
    
    QuizQuestion *newQuestion = [[QuizQuestion alloc] init];
    
    [newQuestion setup];
    
    NSNumberFormatter * f = [[NSNumberFormatter alloc] init];
    
    [newQuestion setLevel: [f numberFromString:[self stringStrippedOfWhitespaceAndNewlines:[quizItem valueWithPath:kLevel]]]];
    [newQuestion setQuestion: [self stringStrippedOfWhitespaceAndNewlines:[quizItem valueWithPath:kQuestion]]];
    [newQuestion setQuestionImageFilename: [self stringStrippedOfWhitespaceAndNewlines:[quizItem valueWithPath:kImage]]];
    [newQuestion setSupplementalInfo: [self stringStrippedOfWhitespaceAndNewlines:[quizItem valueWithPath:kSupplement]]];
    
    
    for (SMXMLElement *answerItem in [quizItem childrenNamed:kWrongAnswer])
    {
        [newQuestion addAnswerWithString:
                                            [self stringStrippedOfWhitespaceAndNewlines:[answerItem valueForKey:@"value"]] 
                              andIsRight:
                                            [NSNumber numberWithBool:NO]
         ];
    }
    
    SMXMLElement *rightAnswer = [quizItem childNamed:kRightAnswer];
    [newQuestion addAnswerWithString:
                                    [self stringStrippedOfWhitespaceAndNewlines:[rightAnswer valueForKey:@"value"]] 
                          andIsRight:
                                    [NSNumber numberWithBool:YES]
     ];    
    
    [newQuestion randomizeAnswers];
        
    [quizQuestions addObject:newQuestion];
    
    [f release];
    [newQuestion release];
}

-(NSString*)stringStrippedOfWhitespaceAndNewlines:(NSString*)oldString
{
    return [oldString stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
}

-(void)dealloc
{
    [super dealloc];
    
    [quizQuestions release];
    [questionsAsked release];
    
}

@end
