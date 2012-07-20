//
//  PlanetCardsAppDelegate.h
//  PlanetCards
//
//  Created by Beaudry Kock on 7/2/11.
//  Copyright 2011 Better World Coding. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "PlanetaryObjectDB.h"
#import "QuizDB.h"
#import "TestFlight.h"

@class PlanetCardsViewController;

@interface PlanetCardsAppDelegate : NSObject <UIApplicationDelegate> {
    PlanetaryObjectDB *objectDB;
    QuizDB *quizDB;
}

@property (nonatomic, retain) IBOutlet UIWindow *window;
@property (nonatomic, retain) PlanetaryObjectDB *objectDB;
@property (nonatomic, retain) QuizDB *quizDB;
@property (nonatomic, retain) IBOutlet PlanetCardsViewController *viewController;

@end
