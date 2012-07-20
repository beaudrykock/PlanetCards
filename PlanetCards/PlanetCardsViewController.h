//
//  PlanetCardsViewController.h
//  PlanetCards
//
//  Created by Beaudry Kock on 7/2/11.
//  Copyright 2011 Better World Coding. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <QuartzCore/QuartzCore.h>
#import "Utilities.h"
#import "AcknowledgementsViewController.h"

@class PlanetaryObjectViewController;
@class QuizViewController;

@interface PlanetCardsViewController : UIViewController {
    PlanetaryObjectViewController *planetaryObjectViewController;
    QuizViewController *quizViewController;
}

@property (nonatomic, retain) PlanetaryObjectViewController *planetaryObjectViewController;
@property (nonatomic, retain) QuizViewController *quizViewController;

-(IBAction)exploreSolarSystem:(id)sender;
-(IBAction)challengeYourself:(id)sender;
-(void)clearQuizView;
-(IBAction)showAcknowledgements:(id)sender;

@end
