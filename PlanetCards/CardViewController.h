//
//  CardViewController.h
//  PlanetCards
//
//  Created by Beaudry Kock on 2/20/12.
//  Copyright (c) 2012 Better World Coding. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "QuizDB.h"
#import <QuartzCore/QuartzCore.h>
#import "AppConstants.h"
#import <AudioToolbox/AudioServices.h>
#import "Utilities.h"

@interface CardViewController : UIViewController
{
    IBOutlet UIImageView* question_image;
    IBOutlet UIView* question_frame;
    IBOutlet UILabel* question;
    IBOutlet UIButton* answer_1;
    IBOutlet UIButton* answer_2;
    IBOutlet UIButton* answer_3;
    IBOutlet UIButton* answer_4;
    
    UIImage *buttonBackground_wrong;
    UIImage *buttonBackground_right;
    UIImage *buttonBackground_corrected;
    
    NSArray *buttonArray;
    
    IBOutlet UILabel* correctIncorrectLabel;
    IBOutlet UIView * correctIncorrectView;
    IBOutlet UIImageView *correctIncorrectImage;
    
    id parentController;
    
    QuizDB *quizDB;
    
    NSInteger currentQuestionNumber;
    BOOL answeredCorrect;
    BOOL timerExpired;
    NSInteger numberOfAnswers;
    IBOutlet UIView *buttonTray;
    
    // touch to drag
    float offset_x;
    float offset_y;
    CGRect originalFrame;
    
    NSInteger cardIndex; // index of this vc in the QVC array
    BOOL answered;
    
    UIView *imageContainerView;
    UIView *supplementalInfoView;
    UILabel *supplementalInfoTitle;
    UITextView *supplementalInfoText;
    BOOL supplementalInfoShowing;
    UILabel *postAnswerInstructions;
    
    UIImageView *difficultyView;
    
    UIView *paidVersionOnlyView;
}

@property (nonatomic, retain) IBOutlet UIView *paidVersionOnlyView;
@property (nonatomic, retain) IBOutlet UIImageView *difficultyView;
@property (nonatomic, retain) IBOutlet UILabel *postAnswerInstructions;
@property (nonatomic, retain) IBOutlet UIView *imageContainerView;
@property (nonatomic, retain) IBOutlet UIView *supplementalInfoView;
@property (nonatomic, retain) IBOutlet UILabel *supplementalInfoTitle;
@property (nonatomic, retain) IBOutlet UITextView *supplementalInfoText;
@property (nonatomic, retain) IBOutlet UIImageView* question_image;
@property (nonatomic, retain) IBOutlet UIView* question_frame;
@property (nonatomic, retain) IBOutlet UILabel* question;
@property (nonatomic, retain) IBOutlet UIButton* answer_1;
@property (nonatomic, retain) IBOutlet UIButton* answer_2;
@property (nonatomic, retain) IBOutlet UIButton* answer_3;
@property (nonatomic, retain) IBOutlet UIButton* answer_4;

@property (nonatomic, retain) UIImage *buttonBackground_wrong;
@property (nonatomic, retain) UIImage *buttonBackground_right;
@property (nonatomic, retain) UIImage *buttonBackground_corrected;

@property (nonatomic, retain) NSArray *buttonArray;

@property (nonatomic, retain) IBOutlet UILabel *correctIncorrectLabel;
@property (nonatomic, retain) IBOutlet UIView *correctIncorrectView;
@property (nonatomic, retain) IBOutlet UIImageView *correctIncorrectImage;

@property (nonatomic, assign) id parentController;

@property (nonatomic, retain) QuizDB *quizDB;

@property (nonatomic, retain) IBOutlet UIView *buttonTray;

-(void)loadButtonBackgrounds;
-(void)stockButtonArray;
-(void)prettifyCards;
-(void)showCorrectIncorrectOverlay;
-(void)prepCard;
-(void)setCurrentQuestionNumber:(NSInteger)questionNumber;
-(IBAction)submitAnswer:(id)sender;
-(void)hideAnswerButtons;
-(void)answerPeriodExpired;
-(void)startTimer;
-(void)loseAnAnswer;
-(void)prepCardForQuestionNumber:(NSInteger)questionNumber;
-(void)invalidateAllTimers;
-(IBAction)skipQuestion:(id)sender;
-(void)freezeButtons;
-(NSInteger)getCardQuestionNumber;
-(void)setCardIndex:(NSInteger)_cardIndex;
-(void)removeCorrectionOverlay;
-(IBAction)showSupplementalInformation:(id)sender;

@end
