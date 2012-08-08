//
//  PlanetCardsAppDelegate.m
//  PlanetCards
//
//  Created by Beaudry Kock on 7/2/11.
//  Copyright 2011 Better World Coding. All rights reserved.
//

#import "PlanetCardsAppDelegate.h"

#import "PlanetCardsViewController.h"

@implementation PlanetCardsAppDelegate


@synthesize window=_window;
@synthesize objectDB;
@synthesize quizDB;
@synthesize viewController=_viewController;

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    // Override point for customization after application launch.
    [TestFlight takeOff:@"6410a6f8585edb65208670f4da2dfba3_NDM3MzMyMDExLTExLTI4IDA0OjU3OjI0LjQ5NTU5Nw"];
    
    [self startGoogleAnalytics];
    
    self.objectDB = [[PlanetaryObjectDB alloc]init];
    [self.objectDB loadContent];
    
    self.quizDB = [[QuizDB alloc] init];
    [self.quizDB loadContent];
        
    if ([Utilities shouldReset])
    {
        [[DDGameKitHelper sharedGameKitHelper] resetAchievements];
        [self.quizDB resetQuestionsAnsweredCorrectlyRecord];
        [self.quizDB resetQuestionsAskedRecord];
        [Utilities removeQuizRecords];
        [Utilities clearReset];
    }
        
    self.window.rootViewController = self.viewController;
    [self.window makeKeyAndVisible];
    return YES;
}

- (void)applicationWillResignActive:(UIApplication *)application
{
    /*
     Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
     Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
     */
}

- (void)applicationDidEnterBackground:(UIApplication *)application
{
    /*
     Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later. 
     If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
     */
}

- (void)applicationWillEnterForeground:(UIApplication *)application
{
    /*
     Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
     */
}

- (void)applicationDidBecomeActive:(UIApplication *)application
{
    /*
     Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
     */
     [[NSUserDefaults standardUserDefaults] synchronize];
    
    if ([Utilities shouldReset])
    {
        [[DDGameKitHelper sharedGameKitHelper] resetAchievements];
        [self.quizDB resetQuestionsAnsweredCorrectlyRecord];
        [self.quizDB resetQuestionsAskedRecord];
        [Utilities removeQuizRecords];
        [Utilities clearReset];
    }
}

- (void)applicationWillTerminate:(UIApplication *)application
{
    /*
     Called when the application is about to terminate.
     Save data if appropriate.
     See also applicationDidEnterBackground:.
     */
}

-(void)startGoogleAnalytics
{
    [[GANTracker sharedTracker] startTrackerWithAccountID:kGoogleAnalyticsKey
                                           dispatchPeriod:kGANDispatchPeriodSec
                                                 delegate:nil];
}

- (void)dealloc
{
    [_window release];
    [_viewController release];
    [quizDB release];
    [objectDB release];
    [super dealloc];
}

@end
