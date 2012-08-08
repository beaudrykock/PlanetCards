//
//  QuizDB.m
//  PlanetCards
//
//  Created by Beaudry Kock on 2/18/12.
//  Copyright (c) 2012 Better World Coding. All rights reserved.
//

#import "QuizDB.h"

@implementation QuizDB

@synthesize quizQuestions, questionsAsked, quizQuestionsByDifficulty, currentDifficultyLevel, lastQuestionWasCorrect, questionsAnsweredCorrectly, contentLoaded;

-(void)loadContent
{
    [self readQuizUserData];
    currentDifficultyLevel = [Utilities getLastDifficultyLevel];
    
    self.questionsAsked = [NSMutableArray arrayWithCapacity:20];
    self.questionsAnsweredCorrectly = [NSMutableArray arrayWithCapacity:50];
    self.quizQuestions = [[NSMutableArray alloc] initWithCapacity:200];
    if (!self.quizQuestionsByDifficulty)
        self.quizQuestionsByDifficulty = [[NSMutableDictionary alloc] initWithCapacity:10];
    
    dispatch_queue_t queue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0);
    
    dispatch_async(queue, ^{
        __block typeof (self)myself = self;
        
        NSString *objectXML = nil;
        NSData *data = nil;
        BOOL loadedSuccessfully = NO;
        if (![Utilities hasInternet])
        {
            NSLog(@"No internet - trying to load quiz data from cache");
            data = [NSData dataWithContentsOfFile:[Utilities cachePath:kXmlDataFile]];
            if (!data)
            {
                NSLog(@"No cache - trying to load quiz data from file");
                objectXML = [[NSBundle mainBundle] pathForResource:@"PlanetCardsQuizData" ofType:@"xml"];
                data = [NSData dataWithContentsOfFile:objectXML];
            }
            loadedSuccessfully = YES;
        }
        else {
            // load from URL
            NSString *urlString = @"http://www.scientificplayground.com/app-resources/planetcards/PlanetCardsQuizData.xml";
            //NSString *urlString = @"http://web62557.aiso.net/app-resources/planetcards/PlanetCardsQuizData.xml";
            // alternative: @"http://web62557.aiso.net/cultivate/VegVanStops.xml";
            ASIHTTPRequest *request = [[ASIHTTPRequest alloc] initWithURL:[NSURL URLWithString:urlString]];
            [request setTimeOutSeconds:10.0];
            [request startSynchronous];
            
            data = [request responseData];
            //NSLog(@"data contents = %@", [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding]);
            if (!data)
            {
                NSLog(@"Internet load failed - trying to load quiz data from cache");
                data = [NSData dataWithContentsOfFile:[Utilities cachePath:kXmlDataFile]];
                if (!data)
                {
                    NSLog(@"No cache and internet load failed - trying to load quiz data from file");
                    objectXML = [[NSBundle mainBundle] pathForResource:@"PlanetCardsQuizData" ofType:@"xml"];
                    data = [NSData dataWithContentsOfFile:objectXML];
                }
                loadedSuccessfully = YES;
            }
            else
            {
                NSLog(@"Loaded quiz data from URL");
                loadedSuccessfully = YES;
            }
            
            NSAssert(loadedSuccessfully, @"Data not loaded successfully");
            BOOL writtenSuccessfully = [self writeQuizDataToFile:data];
            NSAssert(writtenSuccessfully, @"Data not written successfully");
            
            // create a new SMXMLDocument with the contents of sample.xml
            SMXMLDocument *document = [SMXMLDocument documentWithData:data error:NULL];
            
            // demonstrate -description of document/element classes
            //NSLog(@"Document:\n %@", document);
            
            // Pull out the <rdf> node
            SMXMLElement *root = document.root;
            
            for (SMXMLElement *quizItem in [root childrenNamed:kQuizItem])
            {
                [myself generateQuestionFromQuizItem: quizItem];
            }
            
            for (NSNumber *key in [myself.quizQuestionsByDifficulty allKeys])
            {
                NSMutableArray *arr= (NSMutableArray*)[myself.quizQuestionsByDifficulty objectForKey:key];
                NSLog(@"count of questions for level %i = %i", [key intValue], [arr count]);
            }
        }
        contentLoaded = YES;
        dispatch_sync(dispatch_get_main_queue(), ^{
            [[NSNotificationCenter defaultCenter] postNotificationName:kQuizDBLoaded object:nil];
        });
    });
    
    //////////
       
    
    
        
    
}

-(BOOL)writeQuizDataToFile:(NSData*)data
{
    return [data writeToFile:[Utilities cachePath:kXmlDataFile] atomically:YES];
}

-(BOOL)readQuizQuestionData
{
    
}

-(UIImage*)getRandomImage
{
    QuizQuestion *randQuestion = [self getQuestionNumbered: [self getRandomQuestionNumber]];
    
    UIImage *image = [UIImage imageWithContentsOfFile:[[NSBundle mainBundle] pathForResource:[randQuestion questionImageFilenameWithoutType] ofType:@"png"]];
    
    return image;
}

-(BOOL)questionIsAskableWithNumber:(NSInteger)questionNumber
{
    BOOL questionAskedInCurrentQuiz = [self.questionsAsked containsObject:[NSNumber numberWithInt:questionNumber]];
    BOOL questionAskedCorrectlyInLastThree = [self.questionsAnsweredCorrectly containsObject:[NSNumber numberWithInt:questionNumber]];
    //NSLog(@"askability for question number %i = %i, %i", questionNumber, questionAskedInCurrentQuiz, questionAskedCorrectlyInLastThree);
    if (questionAskedInCurrentQuiz || questionAskedCorrectlyInLastThree) return NO;
    return YES;
}

-(void)addQuestionAskedRecord:(NSInteger)questionNumber;
{
    if (![self.questionsAsked containsObject:[NSNumber numberWithInt:questionNumber]])
    {
        //NSLog(@"adding question asked record for number %i", questionNumber);
        [self.questionsAsked addObject:[NSNumber numberWithInt:questionNumber]];
    }
}

-(void)addQuestionAnsweredCorrectlyRecord:(NSInteger)questionNumber
{
    if (![self.questionsAnsweredCorrectly containsObject:[NSNumber numberWithInt:questionNumber]])
    {
        //NSLog(@"adding question answered correctly record for number %i", questionNumber);
        [self.questionsAnsweredCorrectly addObject:[NSNumber numberWithInt:questionNumber]];
    }
}

-(void)resetQuestionsAskedRecord
{
    [self.questionsAsked removeAllObjects];
}

-(void)resetQuestionsAnsweredCorrectlyRecord
{
    [self.questionsAnsweredCorrectly removeAllObjects];
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

-(void)changeDifficultyLevelBy:(NSInteger)change
{
    currentDifficultyLevel+=change;

    // sets difficulty level randomly if it hits max level; back to minimum if less than minimum
#ifdef LITE_VERSION
    if (currentDifficultyLevel>kMaximumDifficultyLevel_lite)
    {
        currentDifficultyLevel = arc4random()%kMaximumDifficultyLevel_lite;
    }
    else if (currentDifficultyLevel<kMinimumDifficultyLevel)
    {
        currentDifficultyLevel = kMinimumDifficultyLevel;
    }
#else 
    if (currentDifficultyLevel>kMaximumDifficultyLevel)
    {
        currentDifficultyLevel = arc4random()%kMaximumDifficultyLevel;
    }
    else if (currentDifficultyLevel<kMinimumDifficultyLevel)
    {
        currentDifficultyLevel = kMinimumDifficultyLevel;
    }
#endif
}


-(NSInteger)getRandomQuestionNumberWithRecord:(BOOL)record
{
    BOOL found = NO;
    NSInteger questionNbr = 0;
    NSInteger counter = 0;
    NSInteger maxDifficultyLevel = kMaximumDifficultyLevel;
    
#ifdef LITE_VERSION
    maxDifficultyLevel = kMaximumDifficultyLevel_lite+1;
#endif
    
    int direction = 1;
    if (!lastQuestionWasCorrect)
    {
        //NSLog(@"Last question incorrect - reversing search direction");
        direction = -1;
        maxDifficultyLevel = 0;
    }
    
    for (int i = currentDifficultyLevel; i != maxDifficultyLevel; i += direction)
    {
        //NSLog(@"Difficulty level %i", i);
        NSMutableArray *indices = [self.quizQuestionsByDifficulty objectForKey:[NSNumber numberWithInt:currentDifficultyLevel]];
        counter = 0;
        
        while (!found && counter<[indices count])
        {
            #ifdef RANDOM_SELECTION
                questionNbr = [[indices objectAtIndex:arc4random_uniform([indices count]-1)] intValue];
            #else
                questionNbr = [[indices objectAtIndex:counter] intValue];
            #endif
            if ([self questionIsAskableWithNumber:questionNbr])
            {
                //NSLog(@"found askable question with number %i", questionNbr);
                //QuizQuestion *question = [self getQuestionNumbered:questionNbr];
                //NSLog(@"askable question text = %@", [question question]);
                
                found = YES;
            }
            counter++;
        }
        if (found)
        {
            currentDifficultyLevel = i;
            break;
        }
    }
    
    // if still not found, likely that we ran off end of difficulty levels; in this case
    // reset the question asked record and drop back in the middle
    if (!found)
    {
        counter = 0;
        
        //NSLog(@"not found, so resetting difficulty level");
        currentDifficultyLevel = 4;
        
#ifdef LITE_VERSION
        currentDifficultyLevel = 1;
#endif
        [self resetQuestionsAskedRecord];
        [self resetQuestionsAnsweredCorrectlyRecord];
        [Utilities resetAnswerTrackingQuizPlays];
        
        NSMutableArray *indices = [self.quizQuestionsByDifficulty objectForKey:[NSNumber numberWithInt:currentDifficultyLevel]];
        
        while (!found && counter<[indices count])
        {
            questionNbr = [[indices objectAtIndex:counter] intValue];
            
            if ([self questionIsAskableWithNumber:questionNbr])
            {
                found = YES;
            }
            counter++;
        }
    }
    
    if (record)
        [self addQuestionAskedRecord:questionNbr];
    
    return questionNbr;
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
    
    [newQuestion setLevel: [[self stringStrippedOfWhitespaceAndNewlines:[quizItem valueWithPath:kLevel]] integerValue]];
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
        
    int count = [quizQuestions count];
    //NSLog(@"Adding question with index %i", count);
    [newQuestion setMasterArrayIndex:count];
    [quizQuestions addObject:newQuestion];
    
    if (![quizQuestionsByDifficulty objectForKey:[NSNumber numberWithInt:[newQuestion level]]])
    {
        NSMutableArray *questionIndices = [[NSMutableArray alloc] initWithCapacity:10];
        [questionIndices addObject:[NSNumber numberWithInt:[newQuestion masterArrayIndex]]];
        [self.quizQuestionsByDifficulty setObject:questionIndices forKey:[NSNumber numberWithInt:[newQuestion level]]];
        [questionIndices release];
    }
    else 
    {
        NSMutableArray *questionIndices = [self.quizQuestionsByDifficulty objectForKey:[NSNumber numberWithInt:[newQuestion level]]];
        [questionIndices addObject:[NSNumber numberWithInt:[newQuestion masterArrayIndex]]];
    }
    
    [f release];
    [newQuestion release];
}

-(NSString*)stringStrippedOfWhitespaceAndNewlines:(NSString*)oldString
{
    return [oldString stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
}

#pragma mark - Scoring
-(NSInteger)knowledgeScoreForQuestionNumber:(NSInteger)questionNumber
{
    QuizQuestion *question = [self getQuestionNumbered:questionNumber];
    //NSLog(@"returning knowledge score of %i", question.level);
    return question.level;
}

-(NSInteger)speedScoreForQuestionNumber:(NSInteger)questionNumber inTimeBlock:(NSInteger)timeBlock
{
    QuizQuestion *question = [self getQuestionNumbered:questionNumber];
    NSInteger maxScore = question.level;
    
    float pointsPerBlock = (maxScore*1.0)/kNumberOfTimeBlocks;
    
    float score = pointsPerBlock * timeBlock;
    NSInteger intScore = roundf(score);
    //NSLog(@"returning speed score of %i", intScore);
    return intScore;
}

#pragma mark - Writing quiz records to file
-(void)writeQuizUserData
{
    NSDictionary *dict = [NSDictionary dictionaryWithObject:self.questionsAnsweredCorrectly forKey:kQuestionsAnsweredCorrectlyKey];
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *documentsDirectory = [paths objectAtIndex:0];
    NSString *dataFilename = [documentsDirectory stringByAppendingPathComponent:kQuizDataFilename];
    [dict writeToFile:dataFilename atomically:YES];
}

-(void)readQuizUserData
{
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *documentsDirectory = [paths objectAtIndex:0];
    NSString *dataFilename = [documentsDirectory stringByAppendingPathComponent:kQuizDataFilename];
    
    if ([[NSFileManager defaultManager] fileExistsAtPath:dataFilename])
    {
        NSDictionary *dict = [NSDictionary dictionaryWithContentsOfFile:dataFilename];
        self.questionsAnsweredCorrectly = (NSMutableArray*)[dict objectForKey:kQuestionsAnsweredCorrectlyKey];
    }
}

-(void)dealloc
{
    
    [quizQuestions release];
    [questionsAsked release];
    [quizQuestionsByDifficulty release];
    [questionsAnsweredCorrectly release];
    [super dealloc];
    
}

@end
