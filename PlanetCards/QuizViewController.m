//
//  QuizViewController.m
//  PlanetCards
//
//  Created by Beaudry Kock on 2/18/12.
//  Copyright (c) 2012 Better World Coding. All rights reserved.
//

#import "QuizViewController.h"

@implementation QuizViewController

@synthesize cards, quizDB, backgroundView, scoreLabel, questionCountLabel, scoreResultLabel, encouragingMessageLabel, resultView_outerFrame, resultView_innerFrame, parentController, topFrameView;
@synthesize gameCenterManager, cachedHighestScore, currentScore, currentLeaderBoard, bestScoreResultLabel, personalBestScoreString, personalBestScoreDescription, leaderboardHighScoreString, leaderboardHighScoreDescription, tweetButton, skippingView;
@synthesize answerTimer, subTimer_1, subTimer_2, progressBarTimer, timerBar;

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

#pragma mark - Game center
- (void) showAlertWithTitle: (NSString*) title message: (NSString*) message
{
    UIAlertView* alert= [[[UIAlertView alloc] initWithTitle: title message: message 
                                                   delegate: NULL cancelButtonTitle: @"OK" otherButtonTitles: NULL] autorelease];
    [alert show];
    
}

-(void)activateGameCenter
{
    
    self.currentLeaderBoard = kLeaderboardID;
    self.currentScore = score;
    
    if([GameCenterManager isGameCenterAvailable])
    {
        if (!gameCenterActivated)
        {
            self.gameCenterManager= [[[GameCenterManager alloc] init] autorelease];
            [self.gameCenterManager setDelegate: self];
            [self.gameCenterManager authenticateLocalUser];
        
            [self updateCurrentScore];
            [self submitHighScore];
            
            gameCenterActivated = YES;
        }
    }
    else
    {
        [self showAlertWithTitle: @"Game Center Support Required!"
                         message: @"The current device does not support Game Center, which this app requires."];
    }
    
    [self.gameCenterManager retrieveTopTenScores]; // TESTING - writes scores to console
    [self showLeaderboard];
}

- (void)showLeaderboard
{
    GKLeaderboardViewController *leaderboardController = [[GKLeaderboardViewController alloc] init];
    if (leaderboardController != NULL) 
    {
        leaderboardController.category = self.currentLeaderBoard;
        leaderboardController.timeScope = GKLeaderboardTimeScopeAllTime;
        leaderboardController.leaderboardDelegate = self; 
        [self presentModalViewController: leaderboardController animated: YES];
    }
}

- (void)leaderboardViewControllerDidFinish:(GKLeaderboardViewController *)viewController
{
    [self dismissModalViewControllerAnimated: YES];
    if (viewController)
        [viewController release];
    [self showPostQuizActionSheet];
}

- (void)showAchievements
{
    self.currentLeaderBoard = kLeaderboardID;
    self.currentScore = score;
    
    if([GameCenterManager isGameCenterAvailable])
    {
        if (!gameCenterActivated)
        {
            self.gameCenterManager= [[[GameCenterManager alloc] init] autorelease];
            [self.gameCenterManager setDelegate: self];
            [self.gameCenterManager authenticateLocalUser];
        
            [self updateCurrentScore];
            [self submitHighScore];
            gameCenterActivated = YES;
        }
    }
    else
    {
        [self showAlertWithTitle: @"Game Center Support Required!"
                         message: @"The current device does not support Game Center, which is needed to show your achievements."];
    }
    
    GKAchievementViewController *achievements = [[GKAchievementViewController alloc] init];
    if (achievements != NULL)
    {
        achievements.achievementDelegate = self;
        [self presentModalViewController: achievements animated: YES];
    }
}

- (void)achievementViewControllerDidFinish:(GKAchievementViewController *)viewController;
{
    [self dismissModalViewControllerAnimated: YES];
    [viewController release];
    [self showPostQuizActionSheet];
}

#pragma mark Score Handlers

- (void) checkAchievements
{
    NSString* identifier= NULL;
    double percentComplete= 0;
    switch(self.currentScore)
    {
        case 10:
        {
            identifier= kAchievement50PercentOrMore;
            percentComplete= 100.0;
            break;
        }
            // UNCOMMENT FOR OTHER ACHIEVEMENTS
            /*case 10:
             {
             identifier= kAchievementHidden20Taps;
             percentComplete= 50.0;
             break;
             }
             case 20:
             {
             identifier= kAchievementHidden20Taps;
             percentComplete= 100.0;
             break;
             }
             case 50:
             {
             identifier= kAchievementBigOneHundred;
             percentComplete= 50.0;
             break;
             }
             case 75:
             {
             identifier= kAchievementBigOneHundred;
             percentComplete= 75.0;
             break;
             }
             case 100:
             {
             identifier= kAchievementBigOneHundred;
             percentComplete= 100.0;
             break;
             }*/
            
    }
    if(identifier!= NULL)
    {
        [self.gameCenterManager submitAchievement: identifier percentComplete: percentComplete];
    }
}

// NOTE: if want to have achievements, call this method when the score is updated
// after each card is answered >> will show an achievements alert if an achievement is reached
- (void) updateCurrentScore
{
    [self checkAchievements]; 
}

- (NSString*) currentLeaderboardHumanName
{
    return NSLocalizedString(currentLeaderBoard, @"Mapping the Leaderboard IDS");
}

#pragma mark Action Methods
/*- (void) addOne;
{
    self.currentScore= self.currentScore + 1;
    [self updateCurrentScore];
}*/

- (void) submitHighScore
{
    if(self.currentScore > 0)
    {
        [self.gameCenterManager reportScore: self.currentScore forCategory: self.currentLeaderBoard];
    }
}

#pragma mark GameCenterDelegateProtocol Methods
//Delegate method used by processGameCenterAuth to support looping waiting for game center authorization
- (void)alertView:(UIAlertView *)alertView didDismissWithButtonIndex:(NSInteger)buttonIndex
{
    NSString *buttonTitle = [alertView buttonTitleAtIndex:buttonIndex];
    
    if ([buttonTitle isEqualToString:@"Try Again"])
    {
        if (authenticationAttempts<kMaxAuthenticationAttempts)
        {
            [self.gameCenterManager authenticateLocalUser];
            authenticationAttempts++;
        }
        else {
            UIAlertView* alert= [[UIAlertView alloc] initWithTitle: @"Try again later" 
                                                           message: @"There is a problem with authentication, please try again later"
                                                          delegate: self cancelButtonTitle: @"OK" otherButtonTitles: NULL];
            [alert show];
            [alert release];
        }
    }
    else if ([buttonTitle isEqualToString:@"OK"])
    {
        // dismiss leaderboard
        [self leaderboardViewControllerDidFinish:nil];
    }
    else if ([buttonTitle isEqualToString:@"Restart"])
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

- (void) processGameCenterAuth: (NSError*) error
{
    if(error == NULL)
    {
        [self.gameCenterManager reloadHighScoresForCategory: self.currentLeaderBoard];
    }
    else
    {
        UIAlertView* alert= [[UIAlertView alloc] initWithTitle: @"Authentication error" 
                                                        message: [NSString stringWithFormat: @"%@", [error localizedDescription]]
                                                       delegate: self cancelButtonTitle: @"Try Again" otherButtonTitles: NULL];
        [alert show];
        [alert release];
    }
    
}

- (void) mappedPlayerIDToPlayer: (GKPlayer*) player error: (NSError*) error;
{
    if((error == NULL) && (player != NULL))
    {
        self.leaderboardHighScoreDescription= [NSString stringWithFormat: @"%@ got:", player.alias];
        
        if(self.cachedHighestScore != NULL)
        {
            self.leaderboardHighScoreString= self.cachedHighestScore;
        }
        else
        {
            self.leaderboardHighScoreString= @"-";
        }
        
    }
    else
    {
        self.leaderboardHighScoreDescription= @"GameCenter Scores Unavailable";
        self.leaderboardHighScoreDescription=  @"-";
    }
}

- (void) reloadScoresComplete: (GKLeaderboard*) leaderBoard error: (NSError*) error;
{
    if(error == NULL)
    {
        bestScore = leaderBoard.localPlayerScore.value;
        [self.bestScoreResultLabel setText:[NSString stringWithFormat: @"Best: %i", bestScore]];
        if([leaderBoard.scores count] >0)
        {
            GKScore* allTime= [leaderBoard.scores objectAtIndex: 0];
            self.cachedHighestScore= allTime.formattedValue;
            [gameCenterManager mapPlayerIDtoPlayer: allTime.playerID];
        }
    }
    else
    {
        [self.bestScoreResultLabel setText: @"GameCenter Scores Unavailable"];
        [self showAlertWithTitle: @"Score Reload Failed!"
                         message: [NSString stringWithFormat: @"Reason: %@", [error localizedDescription]]];
    }
}

- (void) scoreReported: (NSError*) error;
{
    if(error == NULL)
    {
        [self.gameCenterManager reloadHighScoresForCategory: self.currentLeaderBoard];
        [self showAlertWithTitle: @"High Score Reported!"
                         message: [NSString stringWithFormat: @"", [error localizedDescription]]];
    }
    else
    {
        [self showAlertWithTitle: @"Score Report Failed!"
                         message: [NSString stringWithFormat: @"Reason: %@", [error localizedDescription]]];
    }
}

- (void) achievementSubmitted: (GKAchievement*) ach error:(NSError*) error;
{
    if((error == NULL) && (ach != NULL))
    {
        if(ach.percentComplete == 100.0)
        {
            [self showAlertWithTitle: @"Achievement Earned!"
                             message: [NSString stringWithFormat: @"Great job!  You earned an achievement: \"%@\"", NSLocalizedString(ach.identifier, NULL)]];
        }
        else
        {
            if(ach.percentComplete > 0)
            {
                [self showAlertWithTitle: @"Achievement Progress!"
                                 message: [NSString stringWithFormat: @"Great job!  You're %.0f\%% of the way to: \"%@\"",ach.percentComplete, NSLocalizedString(ach.identifier, NULL)]];
            }
        }
    }
    else
    {
        [self showAlertWithTitle: @"Achievement Submission Failed!"
                         message: [NSString stringWithFormat: @"Reason: %@", [error localizedDescription]]];
    }
}

- (void) achievementResetResult: (NSError*) error;
{
    self.currentScore= 0;
    if(error != NULL)
    {
        [self showAlertWithTitle: @"Achievement Reset Failed!"
                         message: [NSString stringWithFormat: @"Reason: %@", [error localizedDescription]]];
    }
}

#pragma mark - View lifecycle

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
    [self loadQuizDB];
    currentQuestionNumber = 40+arc4random_uniform(20);
    
    // always start with front card
    [self addCards];
    
    QuizIntroViewController* intro = [[QuizIntroViewController alloc] initWithNibName:@"QuizIntroView" bundle:nil];
    [intro setParentController:self];
    [self.view addSubview:intro.view];
    questionCount = 0;
    score = 0;
    numberOfAnswers = -1;
    
    [scoreLabel setText: [NSString stringWithFormat: @"%i POINTS",score]];
    [questionCountLabel setText:[NSString stringWithFormat:@"%i/20 QUESTIONS", 1]];

    [self prettify];
    
    subTimer_1_active = NO;
    subTimer_2_active = NO;
    
    currentQuestionInterval = kDefaultQuestionIntervalInSeconds;
    
    [self resetProgressBar];
    [self resetTimerFlags];
}

-(void)startQuiz
{
    NSUserDefaults *prefs = [NSUserDefaults standardUserDefaults];
    
    NSInteger quizPlayCount = [prefs integerForKey:kQuizPlayCountKey];
    quizPlayCount++;
    [prefs setInteger:quizPlayCount forKey:kQuizPlayCountKey];
    [prefs synchronize];
    
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
        
        CGRect frame = CGRectMake(10.0, 50.0, kCardViewWidth, kCardViewHeight);
        newCard.view.frame = frame;
        
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
    [[self.cards objectAtIndex:currentCardIndex+1] prepCardForQuestionNumber:currentQuestionNumber+1];
    
    [self.quizDB addQuestionAskedRecord:currentQuestionNumber];
    [self.quizDB addQuestionAskedRecord:currentQuestionNumber+1];
}

#pragma mark - Handling answering logic and functionality

// call this FIRST from the card when a response is completed
-(void)answerQuestionIsCorrect:(BOOL)isCorrect withSkip:(BOOL)isSkip
{
    [[UIApplication sharedApplication] beginIgnoringInteractionEvents];
    
    if (!isSkip)
        [[UIApplication sharedApplication] endIgnoringInteractionEvents];
    
    [self invalidateAllTimers];
    
    wasLastQuestionAnsweredCorrect = isCorrect;
    
    // get rid of any skipping view that was added
    if (self.skippingView.superview != nil)
        [self.skippingView removeFromSuperview];
    
    NSInteger block = (NSInteger)(currentQuestionInterval-secondsCount);
    questionCount++;
    numberOfAnswers = -1; // flag as needing a reset so this is correctly handled in startTimers
    
    [questionCountLabel setText:[NSString stringWithFormat:@"%i/20 QUESTIONS", (questionCount+1)]];
    
    if (isCorrect && block<=kFirstAnswerBlock) 
    {
        score += 5;
    }
    else if (isCorrect && block<=kSecondAnswerBlock)
    {
        score += 4;
    }
    else if (isCorrect && block<=kThirdAnswerBlock)
    {
        score += 3;
    }
    [scoreLabel setText: [NSString stringWithFormat: @"%i POINTS",score]];
    
    if (questionCount == 20)
    {
        quizComplete = YES;
        [self runEndOfQuizFunctionality];
    }
    else {
        [self nextCard];
    }
}

-(void)nextCard
{
    // update the index referencing the viewcontroller array
    currentCardIndex++;
    
    // update the current question number (may vary because of random selections)
    currentQuestionNumber = [[self.cards objectAtIndex:currentCardIndex] getCurrentQuestionNumber];
    
    QuizQuestion *newQuestion = [quizDB getQuestionNumbered:currentQuestionNumber];
    numberOfAnswers = [[newQuestion quizAnswers] count];
    
    [self prepTimerParameters];
    
    NSLog(@"Current question number based on card now displayed = %i", currentQuestionNumber);
    [self prepBottomCard];
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
}

// the card added at the bottom of the view stack must be prepped based on the answer to the just removed card
-(void)prepBottomCard
{
    [self pushBottomCardView];
    
    NSInteger block = (NSInteger)(currentQuestionInterval-secondsCount);
    NSInteger questionNumberForBottomCard = currentQuestionNumber;
    if (wasLastQuestionAnsweredCorrect && block<=kFirstAnswerBlock) 
    {
        questionNumberForBottomCard+=5;
        
        questionNumberForBottomCard = [quizDB getRandomQuestionNumberFromCurrent: questionNumberForBottomCard inNext:5 withMinChoices: 2];
    }
    else if (wasLastQuestionAnsweredCorrect && block<=kSecondAnswerBlock)
    {
        questionNumberForBottomCard = [quizDB getRandomQuestionNumberFromCurrent: questionNumberForBottomCard inNext:5 withMinChoices: 3];
    }
    /*else if (isCorrect && block<=kThirdAnswerBlock)
     {
     //NSLog(@"question number before selection (block 3) = %i",currentQuestionNumber);
     currentQuestionNumber = [quizDB getRandomQuestionNumberFromCurrent: currentQuestionNumber inNext:5 withMinChoices: 4];
     
     score += 2;
     //NSLog(@"question number after selection (block 3) = %i",currentQuestionNumber);
     }*/
    else
    {
        questionNumberForBottomCard = [quizDB getRandomQuestionNumberFromCurrent: questionNumberForBottomCard inPrevious:5 withMinChoices: 2];
    }
    
    // prep the bottom card
    if ([self.cards count]>currentCardIndex+1)
    {
         [[self.cards objectAtIndex:currentCardIndex+1] prepCardForQuestionNumber:questionNumberForBottomCard];
    }
    // and finally, slide a new view under the currently visible one
    NSLog(@"ended ignoring interaction events");

    
}

-(void)pushBottomCardView
{
    if ([self.cards count]>currentCardIndex+1)
    {
        CardViewController *newCard = [self.cards objectAtIndex:currentCardIndex+1];
    
        newCard.view.tag = ((currentCardIndex+1)+1)*100;
        NSLog(@"pushing card to bottom of view stack, with tag %i, underneath view with tag %i",((currentCardIndex+1)+1)*100, (currentCardIndex+1)*100);
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
        [self startTimer];
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
    resultView_outerFrame.layer.cornerRadius = 5.0;
    
    CGRect startingFrame = CGRectMake(0, -154, resultView_outerFrame.frame.size.width, resultView_outerFrame.frame.size.height);
    [resultView_outerFrame setFrame:startingFrame];
    
    [scoreResultLabel setText:[NSString stringWithFormat:@"Score: %i%% correct",score]];
    
    [Utilities updateAllTimeBestScore:score];
    NSInteger allTimeScore = [Utilities getAllTimeBestScore];
    
    [bestScoreResultLabel setText:[NSString stringWithFormat:@"Best: %i%% correct",allTimeScore]];
    
    if (score <50)
    {
        [encouragingMessageLabel setText:@"Better luck next time. Perhaps you'd like to learn more about the solar system?"];
    }
    else
    {
        [encouragingMessageLabel setText:@"Congratulations! Play again, and beat your score!"];
    }
    
    CGRect newFrame = CGRectMake(0.0, 0.0, resultView_outerFrame.frame.size.width, resultView_outerFrame.frame.size.height);
    [self.view addSubview:resultView_outerFrame];
    UIView *lowerPane = [[UIView alloc] initWithFrame:CGRectMake(0.0, 154.0, 320.0, 308.0)];
    [lowerPane setTag:500];
    [lowerPane setBackgroundColor:[UIColor lightGrayColor]];
    [lowerPane setAlpha:0.0];
    [self.view addSubview:lowerPane];
    [lowerPane release];
    
    [UIView beginAnimations:nil context:NULL];
    [UIView setAnimationDuration:.5];
    resultView_outerFrame.frame = newFrame;
    [lowerPane setAlpha:0.8];
    [UIView commitAnimations];

    [NSTimer scheduledTimerWithTimeInterval:3.0 target:self selector:@selector(showPostQuizActionSheet) userInfo:nil repeats:NO];
}

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
}

-(void)removePostQuizViews
{
    if (self.resultView_innerFrame.superview!=nil)
        [self.resultView_outerFrame removeFromSuperview];
    if ([self.view viewWithTag:500].superview !=nil)
        [[self.view viewWithTag:500] removeFromSuperview];
}

-(void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (buttonIndex ==0)
    {
        [self removePostQuizViews];
        [self newGame];
    }
    else if (buttonIndex ==1)
    {
        [self activateGameCenter];
        [self showLeaderboard];
    }
    else if (buttonIndex ==2)
    {
        [self activateGameCenter];
        [self showAchievements];
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
}

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
    currentQuestionNumber = 40+arc4random_uniform(20);
    
    if ([self.view viewWithTag:((currentCardIndex+1)*100)].superview != nil)
        [[self.view viewWithTag:((currentCardIndex+1)*100)] removeFromSuperview];
    
    if ([self.view viewWithTag:((currentCardIndex+2)*100)].superview != nil)
        [[self.view viewWithTag:((currentCardIndex+2)*100)] removeFromSuperview];
        
    questionCount = 0;
    score = 0;
    numberOfAnswers = -1;
    
    [scoreLabel setText: [NSString stringWithFormat: @"%i POINTS",score]];
    [questionCountLabel setText:[NSString stringWithFormat:@"%i/20 QUESTIONS", questionCount]];
    
    [cards removeAllObjects];
    
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
    [twitter addURL:[NSURL URLWithString:[NSString stringWithString:@"http://www.scientificplayground.com/"]]];
    [twitter setInitialText:[NSString stringWithFormat:@"I just scored %i/100 on PlanetCards!",score]];
    
    // Show the controller
    [self presentModalViewController:twitter animated:YES];
    
    // Called when the tweet dialog has been closed
    twitter.completionHandler = ^(TWTweetComposeViewControllerResult result) 
    {
        NSString *title = @"Tweet Status";
        NSString *msg; 
        
        if (result == TWTweetComposeViewControllerResultCancelled)
            msg = @"Tweet composition was canceled.";
        else if (result == TWTweetComposeViewControllerResultDone)
            msg = @"Tweet composition completed.";
        
        // Show alert to see how things went...
        UIAlertView* alertView = [[UIAlertView alloc] initWithTitle:title message:msg delegate:self cancelButtonTitle:@"Okay" otherButtonTitles:nil];
        [alertView show];
        [alertView release];
        // Dismiss the controller
        [self dismissModalViewControllerAnimated:YES];
        [self showPostQuizActionSheet];
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
-(void)startTimer
{
    [self prepTimerParameters];
    
    NSLog(@"starting timers...");
    NSLog(@"currentQuestionInterval = %f", currentQuestionInterval);
    NSLog(@"number of answers = %i", numberOfAnswers);
    
    self.progressBarTimer = [NSTimer scheduledTimerWithTimeInterval:0.1 target:self selector:@selector(updateProgressBar) userInfo:nil repeats:YES];
    self.answerTimer = [NSTimer scheduledTimerWithTimeInterval: currentQuestionInterval target: self selector: @selector(answerPeriodExpired) userInfo: nil repeats: NO];
    
    // sub timers
    if (numberOfAnswers==3)
    {
        self.subTimer_1 = [NSTimer scheduledTimerWithTimeInterval: kAnswerLossIntervalInSeconds target: self selector: @selector(loseAnAnswer) userInfo: nil repeats: NO];
    }
    else if (numberOfAnswers ==4)
    {
        self.subTimer_1 = [NSTimer scheduledTimerWithTimeInterval: kAnswerLossIntervalInSeconds target: self selector: @selector(loseAnAnswer) userInfo: nil repeats: NO];
        self.subTimer_2 = [NSTimer scheduledTimerWithTimeInterval: kAnswerLossIntervalInSeconds*2 target: self selector: @selector(loseAnAnswer) userInfo: nil repeats: NO];
        subTimer_1_active = YES;
        subTimer_2_active = YES;
    }
    
}

-(void)updateProgressBar
{
    [self.timerBar setProgress:(secondsCount/currentQuestionInterval) animated:YES];
    secondsCount-=0.1;
}

-(void)loseAnAnswer
{
    if (subTimer_1_active && subTimer_2_active)
    {
        subTimer_1_active = NO;
    }
    else
    {
        subTimer_2_active = NO;
    }
    
    [[self.cards objectAtIndex:currentCardIndex] loseAnAnswer];
}

-(void)answerPeriodExpired
{
    timerExpired = YES;
    
    [[self.cards objectAtIndex:currentCardIndex] answerPeriodExpired];
    [self invalidateAllTimers];
    [self answerQuestionIsCorrect:NO];
}

-(void)resetTimerFlags
{
    timerExpired = NO;
    subTimer_1_active = NO;
    subTimer_2_active = NO;
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
    
    if (subTimer_1_active)
    {
        [self.subTimer_1 invalidate];
    }
    if (subTimer_2_active)
    {
        [self.subTimer_2 invalidate];
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

- (void)viewDidUnload
{
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    // Return YES for supported orientations
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

@end
