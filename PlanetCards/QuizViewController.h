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
#import "GameCenterController.h"
#import "GameCenterManager.h"
#import <Twitter/Twitter.h>
#import <Accounts/Accounts.h>

@interface QuizViewController : UIViewController <GKLeaderboardViewControllerDelegate, GKAchievementViewControllerDelegate, GameCenterManagerDelegate, UIActionSheetDelegate>
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
    
    // GAME CENTER
    GameCenterManager* gameCenterManager;
    int64_t  currentScore; // ONLY for game center - must be set with value of score variable above
    NSString* cachedHighestScore;
    
    NSString* currentLeaderBoard;
    NSString* personalBestScoreDescription;
    NSString* personalBestScoreString;
    
    NSString* leaderboardHighScoreDescription;
    NSString* leaderboardHighScoreString;
    
    BOOL gameCenterActivated;
    BOOL postQuizOptionsSheetShowing;
    UIView *topFrameView;
    
    IBOutlet UIButton *tweetButton;
    
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
}

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
@property (nonatomic, retain) id parentController;
@property (nonatomic, retain) GameCenterManager *gameCenterManager;
@property (nonatomic, assign) int64_t currentScore;
@property (nonatomic, retain) NSString* cachedHighestScore;
@property (nonatomic, retain) NSString* currentLeaderBoard;
@property (nonatomic, retain) NSString* personalBestScoreDescription;
@property (nonatomic, retain) NSString* personalBestScoreString;
@property (nonatomic, retain) NSString* leaderboardHighScoreDescription;
@property (nonatomic, retain) NSString* leaderboardHighScoreString;
@property (nonatomic, retain) IBOutlet UIView *topFrameView;
@property (nonatomic, retain) IBOutlet UIButton *tweetButton;
@property (nonatomic, retain) NSTimer *answerTimer;
@property (nonatomic, retain) NSTimer *subTimer_1;
@property (nonatomic, retain) NSTimer *subTimer_2;
@property (nonatomic, retain) NSTimer *progressBarTimer;
@property (nonatomic, retain) IBOutlet UIProgressView* timerBar;

-(void)loadQuizDB;
-(void)transitionCardsWithCorrect:(BOOL)isCorrect inTimeBlock:(NSInteger)block;
-(void)discard;
-(void)nextQuestionWithIsCorrect:(BOOL)isCorrect inTimeBlock:(NSInteger)block;
-(void)addCards;
-(void)newGame;
-(void)resetDeck;
-(void)exploreSolarSystem;
-(IBAction)quitQuizFromButton:(id)sender;
-(void)runEndOfQuizFunctionality;
-(void)activateGameCenter;
- (void)showLeaderboard;
- (void)showAchievements;
-(void)updateCurrentScore;
-(void)skip;
- (void) submitHighScore;
-(void)prettify;
-(void)tweetScore;
-(void)showPostQuizActionSheet;
-(void)removePostQuizViews;
-(void)showSkippingViewWithTimer:(NSInteger)seconds;
-(void)removeSkippingView;
-(void)skippingViewRemoved;
-(void)nextCard;
-(void)answerQuestionIsCorrect:(BOOL)isCorrect withSkip:(BOOL)isSkip;

@end
