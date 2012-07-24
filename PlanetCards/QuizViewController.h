//
//  QuizViewController.h
//  PlanetCards
//
//  Created by Beaudry Kock on 2/18/12.
//  Copyright (c) 2012 Better World Coding. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "PlanetCardsAppDelegate.h"
#import <QuartzCore/QuartzCore.h>
#import "CardViewController.h"
#import "QuizIntroViewController.h"
#import <Twitter/Twitter.h>
#import <Accounts/Accounts.h>
#import "iAd/ADInterstitialAd.h"

@interface QuizViewController : UIViewController <GKLeaderboardViewControllerDelegate, GKAchievementViewControllerDelegate, UIActionSheetDelegate, UIAlertViewDelegate, ADInterstitialAdDelegate>
{
    
    QuizDB *quizDB;
    NSInteger currentQuestionNumber; // the level of the card (i.e. number of the card in the full list)
    NSInteger questionCount; // actual number of questions that have been asked (starting with first card as 1)
    NSInteger currentCardIndex; // current index in Cards array 
    NSInteger cardShowing;
    BOOL firstCard;
    NSMutableArray *cards;
    UIImageView *backgroundView;
    NSInteger baseQuestionNumber;
    NSInteger score;
    NSInteger bestScore;
    IBOutlet UILabel *scoreLabel;
    IBOutlet UILabel *bestScoreResultLabel;
    IBOutlet UILabel *questionCountLabel;
    
    IBOutlet UIView *resultView_outerFrame;
    IBOutlet UIView *resultView_innerFrame;
    IBOutlet UILabel *scoreResultLabel;
    IBOutlet UILabel *encouragingMessageLabel;
    id parentController;
    
    BOOL postQuizOptionsSheetShowing;
    UIView *topFrameView;
    
    BOOL gameActive;
    NSInteger authenticationAttempts;
    UIView *skippingView;
    
    // TIMERS
    NSTimer* answerTimer;
    NSTimer* subTimer_1;
    NSTimer* subTimer_2;
    NSTimer *progressBarTimer;
    NSInteger numberOfAnswers;
    IBOutlet UIProgressView *timerBar;
    float secondsCount;
    
    BOOL subTimer_1_active;
    BOOL subTimer_2_active;
    BOOL timerExpired;
    
    float currentQuestionInterval;
    BOOL wasLastQuestionAnsweredCorrect;
    BOOL quizComplete;
    NSInteger currentDifficultyLevel;
    NSMutableArray *lastFiveAnswers; // YES/NO for correct
}

@property (nonatomic, retain) NSMutableArray *lastFiveAnswers;
@property (nonatomic, retain) IBOutlet UIView *skippingView;
@property (nonatomic, retain) NSMutableArray *cards;
@property (nonatomic, retain) QuizDB *quizDB;
@property (nonatomic, retain) IBOutlet UIImageView *backgroundView;
@property (nonatomic, retain) IBOutlet UILabel *scoreLabel;
@property (nonatomic, retain) IBOutlet UILabel *questionCountLabel;
@property (nonatomic, retain) IBOutlet UILabel *scoreResultLabel;
@property (nonatomic, retain) IBOutlet UILabel *bestScoreResultLabel;
@property (nonatomic, retain) IBOutlet UILabel *encouragingMessageLabel;
@property (nonatomic, retain) IBOutlet UIView *resultView_outerFrame;
@property (nonatomic, retain) IBOutlet UIView *resultView_innerFrame;
@property (nonatomic, assign) id parentController;
@property (nonatomic, retain) IBOutlet UIView *topFrameView;
@property (nonatomic, retain) NSTimer *answerTimer;
@property (nonatomic, retain) NSTimer *subTimer_1;
@property (nonatomic, retain) NSTimer *subTimer_2;
@property (nonatomic, retain) NSTimer *progressBarTimer;
@property (nonatomic, retain) IBOutlet UIProgressView* timerBar;

-(void)loadQuizDB;
-(void)addCards;
-(void)newGame;
-(void)resetDeck;
-(void)exploreSolarSystem;
-(IBAction)quitQuizFromButton:(id)sender;
-(void)runEndOfQuizFunctionality;
-(void)skip;
-(void)prettify;
-(void)tweetScore;
-(void)showPostQuizActionSheet;
-(void)removePostQuizViews;
-(void)showSkippingViewWithTimer:(NSInteger)seconds;
-(void)removeSkippingView;
-(void)skippingViewRemoved;
-(void)nextCard;
-(void)answerQuestionIsCorrect:(BOOL)isCorrect withSkip:(BOOL)isSkip;
-(IBAction)showLeaderboardFromPostQuiz:(id)sender;
-(IBAction)newGameFromPostQuiz:(id)sender;
-(IBAction)exitFromPostQuiz:(id)sender;
-(IBAction)showAchievementsFromPostQuiz:(id)sender;
-(IBAction)tweetFromPostQuiz:(id)sender;
-(void)postQuizViewDidStopAnimating;
-(NSInteger)selectStartingQuestionNumber;
@end
