//
//  QuizViewController.m
//  PlanetCards
//
//  Created by Beaudry Kock on 2/18/12.
//  Copyright (c) 2012 Better World Coding. All rights reserved.
//

#import "QuizViewController.h"

@implementation QuizViewController

@synthesize cards, quizDB, backgroundView, scoreLabel, questionCountLabel, speedScoreResultLabel, knowledgeScoreResultLabel, encouragingMessageLabel, resultView_outerFrame, resultView_innerFrame, parentController, topFrameView, questionScore, speedScore, adBannerView, adBannerViewIsVisible, placeholderBanner, answerTimer_start, lossTimer_start,progressBarTimer_start;
@synthesize bestTotalScoreResultLabel,totalScoreResultLabel, skippingView, exitTarget;
@synthesize answerTimer, lossTimer, progressBarTimer, timerBar, lastXAnswers;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)didReceiveMemoryWarning
{
    // Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
    
    // Release any cached data, images, etc that aren't in use.
}

#pragma mark - Game navigation
-(void)skip
{
    [self showSkippingViewWithTimer:1.0];
}

-(void)showSkippingViewWithTimer:(NSInteger)seconds
{
    self.skippingView.layer.cornerRadius = 8.0;
    float skippingViewWidth = self.skippingView.frame.size.width;
    float skippingViewHeight = self.skippingView.frame.size.height;
    [self.skippingView setFrame:CGRectMake((self.view.frame.size.width/2.0)-(skippingViewWidth/2.0), (self.view.frame.size.width/2.0)-(skippingViewHeight/2.0), skippingViewWidth, skippingViewHeight)];
    [self.skippingView setAlpha:0.0];
    [self.view addSubview:self.skippingView];
    
    [UIView beginAnimations:nil context:NULL];
    [UIView setAnimationDuration:.3];
    [self.skippingView setAlpha:1.0];
    [UIView commitAnimations];
    
    [NSTimer scheduledTimerWithTimeInterval:seconds target:self selector:@selector(removeSkippingView) userInfo:nil repeats:NO];
}

-(void)removeSkippingView
{
    [UIView beginAnimations:nil context:NULL];
    [UIView setAnimationDuration:.3];
    [self.skippingView setAlpha:0.0];
    [UIView setAnimationDelegate:self];
    [UIView commitAnimations];
}


- (void)alertView:(UIAlertView *)alertView didDismissWithButtonIndex:(NSInteger)buttonIndex
{
    NSString *buttonTitle = [alertView buttonTitleAtIndex:buttonIndex];
    
    if ([buttonTitle isEqualToString:@"Restart"])
    {
        [self invalidateAllTimers];
        
        UIView *overlayClear = [[UIView alloc] initWithFrame:CGRectMake(self.view.bounds.origin.x, self.view.bounds.origin.y, self.view.bounds.size.width, self.view.bounds.size.height)];
        [overlayClear setBackgroundColor:[UIColor clearColor]];
        [overlayClear setTag:kActivityIndicatorViewTag];
        
        UIView *overlayDark = [[UIView alloc] initWithFrame:CGRectMake(self.view.bounds.origin.x, self.view.bounds.origin.y, self.view.bounds.size.width, self.view.bounds.size.height)];
        [overlayDark setBackgroundColor:[UIColor blackColor]];
        [overlayDark setAlpha:0.8];
        
        UILabel *reloading = [[UILabel alloc] initWithFrame:CGRectMake((self.view.frame.size.width/2.0)-50, (self.view.frame.size.height/2.0)+37.5, 100.0, 100.0)];
        [reloading setText:@"Restarting quiz"];
        [reloading setFont:[UIFont fontWithName:@"Helvetica Neue" size:15.0]];
        [reloading setTextAlignment:UITextAlignmentCenter];
        [reloading setBackgroundColor:[UIColor clearColor]];
        [reloading setTextColor:[UIColor whiteColor]];
        
        UIActivityIndicatorView *activity = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleWhite];
        [activity setFrame:CGRectMake((self.view.frame.size.width/2.0)-37.5, (self.view.frame.size.height/2.0)-37.5, 75.0, 75.0)];
        [overlayDark addSubview:activity];
        [overlayDark addSubview:reloading];
        [overlayClear addSubview:overlayDark];
        [self.view addSubview:overlayClear];
        [activity startAnimating];
        [activity release];
        [overlayDark release];
        [overlayClear release];
        [reloading release];
        [NSTimer scheduledTimerWithTimeInterval:1.0 target:self selector:@selector(resetDeckAfterDelay) userInfo:nil repeats:NO];
    }
}

#pragma mark - View lifecycle

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
    [self loadQuizDB];
    
    numberOfAnswers = -1;
    self.lastXAnswers = [NSMutableArray arrayWithCapacity:5];
    questionCount = 0;
    questionScore = 0;
    speedScore = 0;
    currentQuestionInterval = kDefaultQuestionIntervalInSeconds;
    currentQuestionNumber = [self selectStartingQuestionNumber];
    [self addCards];
    [self.scoreLabel setText: [NSString stringWithFormat: @"%i POINTS",questionScore+speedScore]];
    [self.questionCountLabel setText:[NSString stringWithFormat:@"%i/20 QUESTIONS", 1]];
    [self prettify];
    [self resetProgressBar];
    [self resetTimerFlags];
   
    self.exitTarget = [[UIButton alloc] initWithFrame:CGRectMake(11.0, 10.0, 44.0, 44.0)];
    [self.exitTarget addTarget:self action:@selector(quitQuizFromButton:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:exitTarget];
    
    QuizIntroViewController* intro = [[QuizIntroViewController alloc] initWithNibName:@"QuizIntroView" bundle:nil];
    [intro setParentController:self];
    [self.view addSubview:intro.view];
   
#ifdef LITE_VERSION
    self.timerBar.frame = CGRectMake(self.timerBar.frame.origin.x, self.timerBar.frame.origin.y-50.0, self.timerBar.frame.size.width, self.timerBar.frame.size.height);
#endif
    
}

-(NSInteger)selectStartingQuestionNumber
{
    /*
    NSInteger lastScore = [Utilities getLastScore];

    if (lastScore>=0 && lastScore<50)
    {
        [self.quizDB changeDifficultyLevelBy:-2];
    }
    else if (lastScore>=0 && lastScore<100)
    {
        [self.quizDB changeDifficultyLevelBy:-1];
    }
    else if (lastScore>=0 && lastScore<150)
    {
        [self.quizDB changeDifficultyLevelBy:1];
    }
    else if (lastScore>=0 && lastScore<=200)
    {
        [self.quizDB changeDifficultyLevelBy:2];
    }*/
    
    NSInteger startingNumber = [self.quizDB getRandomQuestionNumberWithRecord:YES];
    [Utilities setLastStartingQuestionNumber:startingNumber];
    
    return startingNumber;
    //return 40+arc4random_uniform(20);
}

-(void)startQuiz
{
#ifdef LITE_VERSION
    [self createAdBannerView];
#endif
    
    if ([Utilities answerTrackingQuizPlays] == kMaximumQuizPlaysBeforeRepeatCorrectAnswered)
    {
        [Utilities resetAnswerTrackingQuizPlays];
        [self.quizDB resetQuestionsAnsweredCorrectlyRecord];
    }
    
    quizActive = YES;
    
    [self prepTimerParameters];
    
    [self startTimer];
}

// Called from viewDidLoad to get the view controllers array populated
-(void)addCards
{
    cards = [[NSMutableArray arrayWithCapacity:20] retain];
    CardViewController *newCard = nil;
    
    for (int i = 0; i<kNumberOfQuestions; i++)
    {
        newCard = [[CardViewController alloc] initWithNibName:@"CardView" bundle:nil];
        
        [newCard setQuizDB:self.quizDB];
        [newCard setCurrentQuestionNumber: i+(arc4random()%5)];
        [newCard setCardIndex: i];
        [newCard setParentController:self];
        
        [cards addObject:newCard];
        [newCard release];
    }
    
    //NSInteger rand_1 = 0;
    //NSInteger rand_2 = 0;
    //for (int i = kNumberOfQuestions-1; i>=0; i--)
       
    // prep this and next card so that if user swipes card to side, next question
    // is also ready to go
    
    for (int i = 1; i>=0; i--)
    {
        CardViewController *card = [cards objectAtIndex:i];
        CGRect frame = CGRectMake(10.0, 50.0, kCardViewWidth, kCardViewHeight);
        
        /* ADDS RANDOM OFFSET TO CARD PLACEMENT
         rand_1 = arc4random_uniform(3);
         rand_2 = arc4random_uniform(3);
         
         if (rand_1==1)
         {
         frame.origin.x-=kRandomCardOffset;
         }
         else if (rand_1==2)
         {
         frame.origin.x+=kRandomCardOffset;
         }
         if (rand_2==1)
         {
         frame.origin.y-=kRandomCardOffset;
         }
         else if (rand_2==2)
         {
         frame.origin.y+=kRandomCardOffset;
         }
         */
        card.view.tag = (i+1)*100;
        NSLog(@"adding view with tag %i", card.view.tag);
        [self.view addSubview: card.view];
        card.view.frame = frame;
    } 
    
    [[self.cards objectAtIndex:currentCardIndex] prepCardForQuestionNumber:currentQuestionNumber];
    [[self.cards objectAtIndex:currentCardIndex+1] prepCardForQuestionNumber:[self.quizDB getRandomQuestionNumberWithRecord:YES]]; 
}

#pragma mark - Handling answering logic and functionality
-(void)answerAnalyticsIsCorrect:(NSNumber*)isCorrect
{
    NSError *error;
    if ([isCorrect boolValue])
    {
        if (![[GANTracker sharedTracker] trackEvent:kQuizAction
                                             action:@"Correct answer"
                                              label:[NSString stringWithFormat:@"%i", currentQuestionNumber]
                                              value:0
                                          withError:&error]) {
            NSLog(@"GANTracker error, %@", [error localizedDescription]);
        }
    }
    else
    {
        if (![[GANTracker sharedTracker] trackEvent:kQuizAction
                                             action:@"Incorrect answer"
                                              label:[NSString stringWithFormat:@"%i", currentQuestionNumber]
                                              value:0
                                          withError:&error]) {
            NSLog(@"GANTracker error, %@", [error localizedDescription]);
        }
    }
}

// call this FIRST from the card when a response is completed
-(void)answerQuestionIsCorrect:(BOOL)isCorrect withSkip:(BOOL)isSkip
{
    [self performSelectorInBackground:@selector(answerAnalyticsIsCorrect:) withObject:[NSNumber numberWithBool:isCorrect]];
    
    [self.quizDB setLastQuestionWasCorrect:isCorrect];
    if (isCorrect)
        [self.quizDB addQuestionAnsweredCorrectlyRecord:currentQuestionNumber];
    
    quizActive = NO;
    [[UIApplication sharedApplication] beginIgnoringInteractionEvents];
    
    if (!isSkip)
        [[UIApplication sharedApplication] endIgnoringInteractionEvents];
    
    [self invalidateAllTimers];
    
    [self.lastXAnswers addObject: [NSNumber numberWithBool:isCorrect]];
    wasLastQuestionAnsweredCorrect = isCorrect;
    
    NSInteger elapsed = (NSInteger)(currentQuestionInterval-secondsCount);
    NSInteger block = 4;
    
    // assign full points if it's only a two answer question
    if (currentQuestionInterval == kDefaultQuestionIntervalInSeconds)
    {
        if (elapsed<kFirstAnswerBlock)
        {
            block=1;
        }
        else if (elapsed<kSecondAnswerBlock)
        {
            block=2;
        }
        else if (elapsed<kThirdAnswerBlock)
        {
            block=3;
        }
    }
    
    numberOfAnswers = -1; // flag as needing a reset so this is correctly handled in startTimers
    
    if (isCorrect)
    {
        knowledgeScore += [self.quizDB knowledgeScoreForQuestionNumber: currentQuestionNumber];
        speedScore += [self.quizDB speedScoreForQuestionNumber:currentQuestionNumber inTimeBlock: block];
    }
    
    [scoreLabel setText: [NSString stringWithFormat: @"%i POINTS",speedScore+knowledgeScore]];
    if (questionCount == 19)
    {
        quizComplete = YES;
    }
    else {
        [self.questionCountLabel setText:[NSString stringWithFormat:@"%i/20 QUESTIONS", (questionCount+2)]];
        
        dispatch_queue_t queue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_HIGH, 0);
        
        dispatch_async(queue, ^{
            [self nextCard];
        });
        
    }
}

-(void)nextCard
{
    questionCount++;
    
    //[self.questionCountLabel setText:[NSString stringWithFormat:@"%i/20 QUESTIONS", (questionCount+1)]];
    
    // update the index referencing the viewcontroller array
    currentCardIndex++;
    
    // update the current question number (may vary because of random selections)
    currentQuestionNumber = [[self.cards objectAtIndex:currentCardIndex] getCurrentQuestionNumber];
    
    QuizQuestion *newQuestion = [quizDB getQuestionNumbered:currentQuestionNumber];
    numberOfAnswers = [[newQuestion quizAnswers] count];
    
    [self prepTimerParameters];
    
    NSLog(@"Current question number based on card now displayed = %i", currentQuestionNumber);
    
    [self performSelectorOnMainThread:@selector(prepBottomCard) withObject:nil waitUntilDone:NO];
    //[self prepBottomCard];
}

-(void)prepTimerParameters
{
    if (numberOfAnswers==-1)
    {
        QuizQuestion *newQuestion = [quizDB getQuestionNumbered:currentQuestionNumber];
        numberOfAnswers = [[newQuestion quizAnswers] count];
    }
    
    // main timer
    if (numberOfAnswers==2)
    {
        currentQuestionInterval = kQuestionIntervalForTwoAnswersInSeconds;
    }
    else
    {
        currentQuestionInterval = kDefaultQuestionIntervalInSeconds;
    }
    
    secondsCount = currentQuestionInterval;
    answersLost = 0;
    answerTimer_elapsed = 0;
    lossTimer_elapsed = 0;
}

// the card added at the bottom of the view stack must be prepped based on the answer to the just removed card
-(void)prepBottomCard
{
    [self pushBottomCardView];
    
    NSInteger questionNumberForBottomCard;
    
    NSInteger levelChangeInterval = 3;
    
#ifdef LITE_VERSION
    levelChangeInterval = 5;
#endif
    
    if (currentCardIndex%3==0)
    {
        int correctCount = 0;
        for (NSNumber *answerCorrectness in self.lastXAnswers)
        {
            if ([answerCorrectness boolValue]) correctCount++;
        }
        
        int incorrectCount = [self.lastXAnswers count]-correctCount;
        
        // now clear the array
        [self.lastXAnswers removeAllObjects];
        
        if (incorrectCount==3)
        {
            [self.quizDB changeDifficultyLevelBy:-1];
        }
        else if (correctCount==3)
        {
            [self.quizDB changeDifficultyLevelBy:1];
        }

        questionNumberForBottomCard = [self.quizDB getRandomQuestionNumberWithRecord:YES];
    }
    else 
    {
        questionNumberForBottomCard = [self.quizDB getRandomQuestionNumberWithRecord:YES];
    }
    
    // prep the bottom card
    if ([self.cards count]>currentCardIndex+1)
    {
         [[self.cards objectAtIndex:currentCardIndex+1] prepCardForQuestionNumber:questionNumberForBottomCard];
    }
}

-(void)pushBottomCardView
{
    if ([self.cards count]>currentCardIndex+1)
    {
        CardViewController *newCard = [self.cards objectAtIndex:currentCardIndex+1];
    
        CGRect frame = CGRectMake(10.0, 50.0, kCardViewWidth, kCardViewHeight);
        newCard.view.frame = frame;
        
        newCard.view.tag = ((currentCardIndex+1)+1)*100;
        //NSLog(@"pushing card to bottom of view stack, with tag %i, underneath view with tag %i",((currentCardIndex+1)+1)*100, (currentCardIndex+1)*100);
        UIView *currentView = [self.view viewWithTag:(currentCardIndex+1)*100];
        
        [self.view insertSubview:newCard.view belowSubview:currentView];
    }
}

-(void)animateViewOutAtCardIndex:(NSInteger)index
{
    
    
}

-(void)cardRemovalAnimationComplete
{
    if ([[UIApplication sharedApplication] isIgnoringInteractionEvents])
        [[UIApplication sharedApplication] endIgnoringInteractionEvents];
    
    if (!quizComplete)
    {
        quizActive = YES;
        [self startTimer];
    }
    else {
        [self runEndOfQuizFunctionality];
    }
}



#pragma mark - Utilities
-(void)prettify
{
    topFrameView.layer.masksToBounds = NO;
    topFrameView.layer.shadowOffset = CGSizeMake(-5, 5);
    topFrameView.layer.shadowOffset = CGSizeMake(-5, 5);
    topFrameView.layer.shadowOpacity = 0.5;
}

#pragma mark - Post-quiz options
-(void)runEndOfQuizFunctionality
{
    // QUIZ PLAY TRACKING
    [Utilities addQuizPlay];
    [Utilities addAnswerTrackingQuizPlay];
    
    // QUIZ FUNCTIONS
    [self.quizDB resetQuestionsAskedRecord];
    [self.quizDB writeQuizData];
    
    // remove the ad banner view
    if (adBannerViewIsVisible)
        [self showAdBannerView];
    
    // report the score
    [[DDGameKitHelper sharedGameKitHelper] submitScore:(speedScore+knowledgeScore) category:kLeaderboardID];
    
    resultView_outerFrame.layer.cornerRadius = 5.0;
    
    CGRect startingFrame = CGRectMake(0, -460, resultView_outerFrame.frame.size.width, resultView_outerFrame.frame.size.height);
    [resultView_outerFrame setFrame:startingFrame];
    
    [self.knowledgeScoreResultLabel setText:[NSString stringWithFormat:@"Knowledge: %i/100",knowledgeScore]];
    [self.speedScoreResultLabel setText:[NSString stringWithFormat:@"Speed: %i/100",speedScore]];
    [self.totalScoreResultLabel setText:[NSString stringWithFormat:@"Total: %i/200",speedScore+knowledgeScore]];
    
    [Utilities setLastScore:knowledgeScore+speedScore];
    [Utilities updateAllTimeBestScore:knowledgeScore+speedScore];
    [Utilities setLastDifficultyLevel:[self.quizDB currentDifficultyLevel]];
    
    NSInteger allTimeScore = [Utilities getAllTimeBestScore];
    
    [self.bestTotalScoreResultLabel setText:[NSString stringWithFormat:@"Best: %i/200",allTimeScore]];
    
    if (knowledgeScore>=25)
    {
        [[DDGameKitHelper sharedGameKitHelper] reportAchievement:kKnowledgeAchievement_1 percentComplete:100];
    }
    else if (knowledgeScore>=50)
    {
        [[DDGameKitHelper sharedGameKitHelper] reportAchievement:kKnowledgeAchievement_2 percentComplete:100];
    }
    else if (knowledgeScore>=75)
    {
        [[DDGameKitHelper sharedGameKitHelper] reportAchievement:kKnowledgeAchievement_3 percentComplete:100];
    }
    else if (knowledgeScore>99) {
        [[DDGameKitHelper sharedGameKitHelper] reportAchievement:kKnowledgeAchievement_4 percentComplete:100];
    }
    
    if (speedScore>=25)
    {
        [[DDGameKitHelper sharedGameKitHelper] reportAchievement:kSpeedAchievement_1 percentComplete:100];
    }
    else if (speedScore>=50)
    {
        [[DDGameKitHelper sharedGameKitHelper] reportAchievement:kSpeedAchievement_2 percentComplete:100];
    }
    else if (speedScore>=75)
    {
        [[DDGameKitHelper sharedGameKitHelper] reportAchievement:kSpeedAchievement_3 percentComplete:100];
    }
    else if (speedScore>99) {
        [[DDGameKitHelper sharedGameKitHelper] reportAchievement:kSpeedAchievement_4 percentComplete:100];
    }
    
    if (speedScore+knowledgeScore>=50)
    {
        [[DDGameKitHelper sharedGameKitHelper] reportAchievement:kTotalAchievement_1 percentComplete:100];
    }
    else if (speedScore+knowledgeScore>=100)
    {
        [[DDGameKitHelper sharedGameKitHelper] reportAchievement:kTotalAchievement_2 percentComplete:100];
    }
    else if (speedScore+knowledgeScore>=175)
    {
        [[DDGameKitHelper sharedGameKitHelper] reportAchievement:kTotalAchievement_3 percentComplete:100];
    }
    else if (speedScore+knowledgeScore>199) {
        [[DDGameKitHelper sharedGameKitHelper] reportAchievement:kTotalAchievement_4 percentComplete:100];
    }
#ifdef LITE_VERSION
    [self.encouragingMessageLabel setText:@"Nice effort! Have another go or try learning some more by exiting the quiz and exploring the solar system using the PlanetCards gallery and knowledge bank. Remember: to score about 100, you need the paid version of PlanetCards. This unlocks 50 additional questions, plus other great functionality!"];
#else
    if (knowledgeScore>50 && speedScore<50)
    {
        [self.encouragingMessageLabel setText:@"Nice going - you know your stuff! Perhaps now you can work on answering the questions faster"];
    }
    else if (knowledgeScore<50 && speedScore<50)
    {
        [self.encouragingMessageLabel setText:@"Great effort, but perhaps you'd like to learn more? PlanetCards can help you - exit the quiz and go explore the solar system using our gallery and knowledge bank"];
    }
    else if (knowledgeScore<50 && speedScore>50)
    {
        [self.encouragingMessageLabel setText:@"You're quick on the draw, but perhaps you'd like to learn more? PlanetCards can help you - exit the quiz and go explore the solar system using our gallery and knowledge bank"];
    }
    else
    {
        [self.encouragingMessageLabel setText:@"Congratulations! You're well on your way to being a master of solar system knowledge!"];
    }
    
#endif
    CGRect newFrame = CGRectMake(0.0, 0.0, resultView_outerFrame.frame.size.width, resultView_outerFrame.frame.size.height);
    [self.view addSubview:resultView_outerFrame];
    [UIView beginAnimations:nil context:NULL];
    [UIView setAnimationDuration:.5];
    resultView_outerFrame.frame = newFrame;
    [UIView setAnimationDidStopSelector:@selector(postQuizViewDidStopAnimating)];
    [UIView setAnimationDelegate:self];
    [UIView commitAnimations];

    // DEPRECATED in favor of icon buttons
    //[NSTimer scheduledTimerWithTimeInterval:3.0 target:self selector:@selector(showPostQuizActionSheet) userInfo:nil repeats:NO];
}
     
-(void)postQuizViewDidStopAnimating
{
    [[UIApplication sharedApplication] endIgnoringInteractionEvents];
}

/*DEPRECATED
-(void)showPostQuizActionSheet
{
    if (!postQuizOptionsSheetShowing)
    {
        postQuizOptionsSheetShowing = YES;
        UIActionSheet *actionsheet = [[UIActionSheet alloc] 
                                      initWithTitle:nil
                                      delegate:self 
                                      cancelButtonTitle:@"Learn more" 
                                      destructiveButtonTitle:nil
                                      otherButtonTitles:@"Play again", @"Leaderboard", @"Achievements", @"Tweet", nil
                                      ];
        [actionsheet showInView:self.view];
    }
}*/

#pragma mark - Post-game options
-(IBAction)showLeaderboardFromPostQuiz:(id)sender
{
    [[DDGameKitHelper sharedGameKitHelper] showLeaderboard];
}

-(IBAction)newGameFromPostQuiz:(id)sender
{
    [self removePostQuizViews];
    [self newGame];
}

-(IBAction)exitFromPostQuiz:(id)sender
{
    [self removePostQuizViews];
    [self exploreSolarSystem];
}

-(IBAction)showAchievementsFromPostQuiz:(id)sender
{
    [[DDGameKitHelper sharedGameKitHelper] showAchievements];
}

-(IBAction)tweetFromPostQuiz:(id)sender
{
    [self tweetScore];
}


-(void)removePostQuizViews
{
    if (self.resultView_outerFrame.superview!=nil)
        [self.resultView_outerFrame removeFromSuperview];
}

/*DEPRECATED
-(void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (buttonIndex ==0)
    {
        [self removePostQuizViews];
        [self newGame];
    }
    else if (buttonIndex ==1)
    {
        [[DDGameKitHelper sharedGameKitHelper] showLeaderboard];
        //[self activateGameCenter];
        //[self showLeaderboard];
    }
    else if (buttonIndex ==2)
    {
        [[DDGameKitHelper sharedGameKitHelper] showAchievements];
        //[self activateGameCenter];
        //[self showAchievements];
    }
    else if (buttonIndex ==3)
    {
        [self tweetScore];
    }
    else
    {
        [self removePostQuizViews];
        [self exploreSolarSystem];
    }
    
    // COMMENT THIS OUT WHEN TESTING
    postQuizOptionsSheetShowing = NO;
}*/



// called from the reload button
-(IBAction)newGameWhileInGame:(id)sender
{
    UIAlertView *areYouSure = [[UIAlertView alloc] initWithTitle:@"Warning!" message:@"You will lose your current score if you restart the quiz" delegate:self cancelButtonTitle:@"Cancel" otherButtonTitles:@"Restart", nil];
    [areYouSure show];
    [areYouSure release];
    
    
}

-(void)resetDeckAfterDelay
{
    [[self.view viewWithTag:kActivityIndicatorViewTag] removeFromSuperview];
    [self resetDeck];
}

-(void)resetDeck
{
    currentQuestionNumber = [self selectStartingQuestionNumber];
    
    if ([self.view viewWithTag:((currentCardIndex+1)*100)].superview != nil)
        [[self.view viewWithTag:((currentCardIndex+1)*100)] removeFromSuperview];
    
    if ([self.view viewWithTag:((currentCardIndex+2)*100)].superview != nil)
        [[self.view viewWithTag:((currentCardIndex+2)*100)] removeFromSuperview];
     
    currentCardIndex = 0;
    questionCount = 0;
    speedScore = 0;
    knowledgeScore = 0;
    numberOfAnswers = -1;
    quizComplete = NO;
    
    [self.scoreLabel setText: [NSString stringWithFormat: @"%i POINTS",knowledgeScore+speedScore]];
    [self.questionCountLabel setText:[NSString stringWithFormat:@"%i/20 QUESTIONS", questionCount+1]];
    
    [self.cards removeAllObjects];
    [self.lastXAnswers removeAllObjects];
    
    [self addCards];
    
    QuizIntroViewController* intro = [[QuizIntroViewController alloc] initWithNibName:@"QuizIntroView" bundle:nil];
    [intro setParentController:self];
    [self.view addSubview:intro.view];
}

-(void)newGame
{
    [self resetDeck];
}

-(void)exploreSolarSystem
{
    [self invalidateAllTimers];
    //[[self.view viewWithTag:((currentCardIndex+1)*100)] removeFromSuperview];
    //[[self.view viewWithTag:((currentCardIndex+2)*100)] removeFromSuperview];
    
    if ([cards count]>0)
        [cards removeAllObjects];
    
    CGRect frame = [self.view frame];
    frame.origin.x = 640;
    [UIView beginAnimations:nil context:NULL];
    [UIView setAnimationDuration:.5];
    self.view.frame = frame;
    [UIView setAnimationDelegate:self];
    [UIView setAnimationDidStopSelector: @selector(quizViewCleared)];
    [UIView commitAnimations];
}

-(IBAction)quitQuizFromButton:(id)sender
{
    [self exploreSolarSystem];
}

-(void)tweetScore
{
    
    // Create the view controller
    TWTweetComposeViewController *twitter = [[TWTweetComposeViewController alloc] init];
    
    // Optional: set an image, url and initial text
    UIImage *tweetImage = [quizDB getRandomImage];
    [twitter addImage:tweetImage];
    [twitter addURL:[NSURL URLWithString:@"http://www.scientificplayground.com/"]];
    [twitter setInitialText:[NSString stringWithFormat:@"I just scored %i/200 on PlanetCards!",knowledgeScore+speedScore]];
    
    // Show the controller
    [self presentModalViewController:twitter animated:YES];
    
    // Called when the tweet dialog has been closed
    twitter.completionHandler = ^(TWTweetComposeViewControllerResult result) 
    {
        NSString *title = @"Tweet sent";
        NSString *msg = @"";
        
        if (result == TWTweetComposeViewControllerResultDone)
        {
            msg = @"Your tweet was sent successfully";
            
            // Show alert to see how things went...
            UIAlertView* alertView = [[UIAlertView alloc] initWithTitle:title message:msg delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil];
            [alertView show];
            [alertView release];
        }
        // Dismiss the controller
        [self dismissModalViewControllerAnimated:YES];
        //self showPostQuizActionSheet]; // DEPRECATED
    };
    [twitter release];
    
    /* AUTO
     // Create account store, followed by a twitter account identifier
     // At this point, twitter is the only account type available
     ACAccountStore *account = [[ACAccountStore alloc] init];
     ACAccountType *accountType = [account accountTypeWithAccountTypeIdentifier:ACAccountTypeIdentifierTwitter];
     
     // Request access from the user to access their Twitter account
     [account requestAccessToAccountsWithType:accountType withCompletionHandler:^(BOOL granted, NSError *error) 
     {
     // Did user allow us access?
     if (granted == YES)
     {
     // Populate array with all available Twitter accounts
     NSArray *arrayOfAccounts = [account accountsWithAccountType:accountType];
     
     // Sanity check
     if ([arrayOfAccounts count] > 0) 
     {
     // Keep it simple, use the first account available
     ACAccount *acct = [arrayOfAccounts objectAtIndex:0];
     
     // Build a twitter request
     TWRequest *postRequest = [[TWRequest alloc] initWithURL:
     [NSURL URLWithString:@"http://api.twitter.com/1/statuses/update.json"] 
     parameters:[NSDictionary dictionaryWithObject:
     [NSString stringWithFormat:@"I just scored %i/100 on PlanetCards.",score] 
     forKey:@"status"] requestMethod:TWRequestMethodPOST];
     
     // Post the request
     [postRequest setAccount:acct];
     
     // Block handler to manage the response
     [postRequest performRequestWithHandler:^(NSData *responseData, NSHTTPURLResponse *urlResponse, NSError *error) 
     {
     NSLog(@"Twitter response, HTTP response: %i", [urlResponse statusCode]);
     }];
     }
     }
     }];
     */
}


-(void)quizViewCleared
{
    [parentController clearQuizView];
}

-(void)loadQuizDB
{
    PlanetCardsAppDelegate *appDelegate = (PlanetCardsAppDelegate *)[[UIApplication sharedApplication] delegate];
    quizDB = [appDelegate quizDB];
}

#pragma mark - Question timing

// only call this ONCE at start of card period - restart is separate call
-(void)startTimer
{
    [self prepTimerParameters];
    
    //NSLog(@"starting timers...");
    //NSLog(@"currentQuestionInterval = %f", currentQuestionInterval);
    //NSLog(@"number of answers = %i", numberOfAnswers);
    
    self.progressBarTimer = [NSTimer scheduledTimerWithTimeInterval:0.1 target:self selector:@selector(updateProgressBar) userInfo:nil repeats:YES];
    self.progressBarTimer_start = [NSDate date];
    
    self.answerTimer = [NSTimer scheduledTimerWithTimeInterval: currentQuestionInterval target: self selector: @selector(answerPeriodExpired) userInfo: nil repeats: NO];
    self.answerTimer_start = [NSDate date];
    
    // sub timers
    if (numberOfAnswers==3)
    {
        maxAnswersToLose = 1;
    }
    else if (numberOfAnswers==4)
    {
        maxAnswersToLose = 2;
    }
    self.lossTimer = [NSTimer scheduledTimerWithTimeInterval: kAnswerLossIntervalInSeconds target: self selector: @selector(loseAnAnswer) userInfo: nil repeats: NO];
    self.lossTimer_start = [NSDate date];
}

-(void)updateProgressBar
{
    [self.timerBar setProgress:(secondsCount/currentQuestionInterval) animated:YES];
    secondsCount-=0.1;
}

-(void)loseAnAnswer
{
    if (answersLost<maxAnswersToLose)
    {
        [[self.cards objectAtIndex:currentCardIndex] loseAnAnswer];
        answersLost++;
        
        self.lossTimer = [NSTimer scheduledTimerWithTimeInterval: kAnswerLossIntervalInSeconds target: self selector: @selector(loseAnAnswer) userInfo: nil repeats: NO];
        self.lossTimer_start = [NSDate date];
    }
}

-(void)answerPeriodExpired
{
    timerExpired = YES;
    
    [[self.cards objectAtIndex:currentCardIndex] answerPeriodExpired];
    [self invalidateAllTimers];
    [self answerQuestionIsCorrect:NO withSkip:NO];
}

-(void)resetTimerFlags
{
    timerExpired = NO;
}

-(void)resetProgressBar
{
    [self.timerBar setProgress:1.0];
}

-(void)invalidateAllTimers
{
    NSLog(@"Invalidating all timers");
    if (self.answerTimer)
    {
        if ([self.answerTimer isValid])
        {
            [self.answerTimer invalidate];
        }
    }
    
    if (self.lossTimer)
    {
        if ([self.lossTimer isValid])
            [self.lossTimer invalidate];
    }
    
    if (self.progressBarTimer)
    {
        if ([self.progressBarTimer isValid])
        {
            [self.progressBarTimer invalidate];
        }
    }
    [self resetTimerFlags];
    [self resetProgressBar];
}



- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    // Return YES for supported orientations
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

#pragma mark - iAd
- (void)createAdBannerView {
    Class classAdBannerView = NSClassFromString(@"ADBannerView");
    if (classAdBannerView != nil) {
        if ([self.adBannerView superview]==nil)
        {
            self.adBannerView = [[[classAdBannerView alloc]
                                  initWithFrame:CGRectZero] autorelease];
            [adBannerView setRequiredContentSizeIdentifiers:[NSSet setWithObjects:
                                                              ADBannerContentSizeIdentifierPortrait,
                                                              ADBannerContentSizeIdentifierLandscape, nil]];
            
            [adBannerView setCurrentContentSizeIdentifier:
             ADBannerContentSizeIdentifierPortrait];
            
            [adBannerView setFrame:CGRectOffset([adBannerView frame], 0,
                                                 480.0)];
            [adBannerView setDelegate:self];
            
            [self.view addSubview:adBannerView];
        }
    }
    
    // always add the placeholder
    if ([self.placeholderBanner superview]==nil)
    {
        [self.placeholderBanner setImage:[UIImage imageNamed:@"planetcards_ad.png"]];
        [self.placeholderBanner setFrame:CGRectMake(0.0, self.view.frame.size.height-50.0, self.placeholderBanner.frame.size.width, self.placeholderBanner.frame.size.height)];
        [self.placeholderBanner setUserInteractionEnabled:YES];
        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(goToStore)];
        [self.placeholderBanner addGestureRecognizer:tap];
        [tap release];
        [self.view addSubview:self.placeholderBanner];
    }
}

-(void)goToStore
{
    NSString *urlStr = kPlanetCardsPaidLink;
    NSURL *url = [NSURL URLWithString:[urlStr stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding]];
    
    if (![[UIApplication sharedApplication] openURL:url])
        NSLog(@"%@%@",@"Failed to open url:",[url description]);
}

-(void)showAdBannerView
{
    if (adBannerView != nil) {
        [adBannerView setCurrentContentSizeIdentifier:
             ADBannerContentSizeIdentifierPortrait];
        [UIView beginAnimations:@"fixupViews" context:nil];
        if (adBannerViewIsVisible) {
            CGRect adBannerViewFrame = [adBannerView frame];
            self.placeholderBanner.frame = adBannerViewFrame;
            adBannerViewFrame.origin.x = 0;
            adBannerViewFrame.origin.y = self.view.frame.size.height-50.0;
            [adBannerView setFrame:adBannerViewFrame];
        } else {
            CGRect adBannerViewFrame = [adBannerView frame];
            self.placeholderBanner.frame = adBannerViewFrame;
            adBannerViewFrame.origin.x = 0;
            adBannerViewFrame.origin.y = self.view.frame.size.height;
            [adBannerView setFrame:adBannerViewFrame];
        }
        [UIView commitAnimations];
    }
}

- (int)getBannerHeight:(UIDeviceOrientation)orientation {
    if (UIInterfaceOrientationIsLandscape(orientation)) {
        return 32;
    } else {
        return 50;
    }
}

- (int)getBannerHeight {
    return [self getBannerHeight:[UIDevice currentDevice].orientation];
}

#pragma mark ADBannerViewDelegate

- (void)bannerViewDidLoadAd:(ADBannerView *)banner {
    if (!adBannerViewIsVisible) {
        adBannerViewIsVisible = YES;
        [self showAdBannerView];
    }
}

- (void)bannerView:(ADBannerView *)banner didFailToReceiveAdWithError:(NSError *)error
{
    if (adBannerViewIsVisible)
    {
        adBannerViewIsVisible = NO;
        [self showAdBannerView];
    }
}

- (BOOL)bannerViewActionShouldBegin:(ADBannerView *)banner willLeaveApplication:(BOOL)willLeave
{
    //NSLog(@"Banner view is beginning an ad action");
    BOOL shouldExecuteAction = YES;// [self allowActionToRun]; // your application implements this method
    if (!willLeave && shouldExecuteAction)
    {
        // insert code here to suspend any services that might conflict with the advertisement
        if (!quizComplete)
            [self suspendTimers];
    }
    return shouldExecuteAction;
}

- (void)bannerViewActionDidFinish:(ADBannerView *)banner
{
    [self restartQuiz];
}

-(void)suspendTimers
{
    // timers to suspend include
    // - progress timer update
    // - lossTimer
    // - answerTimer
    
    NSTimeInterval elapsed_1 = [[NSDate date] timeIntervalSinceDate:answerTimer_start];
    NSTimeInterval elapsed_2 = [[NSDate date] timeIntervalSinceDate:lossTimer_start];
    NSTimeInterval elapsed_3 = [[NSDate date] timeIntervalSinceDate:progressBarTimer_start];
    
    timersElapsedTime = nil;
    timersElapsedTime = [[NSArray arrayWithObjects:[NSNumber numberWithInteger:elapsed_1],
                                                  [NSNumber numberWithInteger:elapsed_2],
                                                   [NSNumber numberWithInteger:elapsed_3],nil] retain];
    suspendedProgressBarValue = self.timerBar.progress;
    [self invalidateAllTimersForAdView];
}

-(void)invalidateAllTimersForAdView
{
    if (self.answerTimer)
    {
        if ([self.answerTimer isValid])
            [self.answerTimer invalidate];
    }
    
    if (self.lossTimer)
    {
        if ([self.lossTimer isValid])
            [self.lossTimer invalidate];
    }
    
    if (self.progressBarTimer)
    {
        if ([self.progressBarTimer isValid])
            [self.progressBarTimer invalidate];
    }
}

-(void)restartQuiz
{
    [self.timerBar setProgress:suspendedProgressBarValue];
    
    // always restart the answer and progress bar timer
    self.progressBarTimer = [NSTimer scheduledTimerWithTimeInterval:0.1 target:self selector:@selector(updateProgressBar) userInfo:nil repeats:YES];
    self.progressBarTimer_start = [NSDate date];
    
    NSNumber *elapsed = (NSNumber*)[timersElapsedTime objectAtIndex:0];
    answerTimer_elapsed += [elapsed integerValue];
    NSTimeInterval remaining = currentQuestionInterval-answerTimer_elapsed;
    //NSLog(@"remaining = %f", remaining);
    self.answerTimer = [NSTimer scheduledTimerWithTimeInterval: remaining target: self selector: @selector(answerPeriodExpired) userInfo: nil repeats: NO];
    self.answerTimer_start = [NSDate date];
    
    NSNumber *elapsed_loss = (NSNumber*)[timersElapsedTime objectAtIndex:1];
    lossTimer_elapsed += [elapsed_loss integerValue];
    remaining = kAnswerLossIntervalInSeconds-lossTimer_elapsed;
    self.lossTimer = [NSTimer scheduledTimerWithTimeInterval: remaining  target: self selector: @selector(loseAnAnswer) userInfo: nil repeats: NO];
    self.lossTimer_start = [NSDate date];
    
    timersElapsedTime = nil;
}

- (void)viewDidUnload
{
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
    
    self.placeholderBanner = nil;
    self.skippingView = nil;
    self.backgroundView = nil;
    self.scoreLabel = nil;
    self.questionCountLabel = nil;
    self.knowledgeScoreResultLabel = nil;
    self.speedScoreResultLabel = nil;
    self.bestTotalScoreResultLabel = nil;
    self.totalScoreResultLabel = nil;
    self.encouragingMessageLabel = nil;
    self.resultView_innerFrame = nil;
    self.resultView_outerFrame = nil;
    self.topFrameView = nil;
    self.timerBar = nil;
}

-(void)dealloc
{
    [exitTarget release];
    [answerTimer_start release];
    [lossTimer_start release];
    [progressBarTimer_start release];
    [placeholderBanner release];
    [adBannerView release];
    [timersElapsedTime release];
    [lastXAnswers release];
    [quizDB release];
    [cards release];
    [backgroundView release];
    [scoreLabel release];
    [bestTotalScoreResultLabel release];
    [speedScoreResultLabel release];
    [knowledgeScoreResultLabel release];
    [totalScoreResultLabel release];
    [questionCountLabel release];
    [resultView_innerFrame release];
    [resultView_outerFrame release];
    [encouragingMessageLabel release];
    [topFrameView release];
    [skippingView release];
    [answerTimer release];
    [lossTimer release];
    [progressBarTimer release];
    [timerBar release];
        
    [super dealloc];
}

@end
