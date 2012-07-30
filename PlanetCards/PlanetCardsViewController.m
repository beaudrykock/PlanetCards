//
//  PlanetCardsViewController.m
//  PlanetCards
//
//  Created by Beaudry Kock on 7/2/11.
//  Copyright 2011 Better World Coding. All rights reserved.
//

#import "PlanetCardsViewController.h"
#import "PlanetaryObjectViewController.h"
#import "QuizViewController.h"

@implementation PlanetCardsViewController

@synthesize planetaryObjectViewController;
@synthesize quizViewController;

- (void)dealloc
{
    [planetaryObjectViewController release];
    [quizViewController release];
    [backgroundView release];
    [super dealloc];
}

- (void)didReceiveMemoryWarning
{
    // Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
    
    // Release any cached data, images, etc that aren't in use.
}

#pragma mark - UI functionality

-(IBAction)exploreSolarSystem:(id)sender
{
    if (self.planetaryObjectViewController == nil)
    {
        PlanetaryObjectViewController *planetaryController = [[PlanetaryObjectViewController alloc] initWithNibName:@"PlanetaryObjectViewController" bundle:nil];
        self.planetaryObjectViewController = planetaryController;
        [planetaryController release];
    }
    
    CGRect frame = [planetaryObjectViewController.view frame];
    frame.origin.x = 340;
    
    planetaryObjectViewController.view.frame = frame;
    
    [self.view addSubview:planetaryObjectViewController.view];
    
    // insert code here to remove quiz view controller
    // [quizViewController.view removeFromSuperview];
    CGRect newViewFrame = self.view.frame;
    
    [UIView beginAnimations:nil context:NULL];
    [UIView setAnimationDuration:.5];
    newViewFrame.origin.x = 0.0;
    newViewFrame.origin.y = 0.0;
    planetaryObjectViewController.view.frame = newViewFrame;
    [UIView commitAnimations];
}


-(IBAction)challengeYourself:(id)sender
{
     if (self.quizViewController == nil)
     {
         QuizViewController *quizController = [[[QuizViewController alloc] initWithNibName:@"QuizView" bundle: nil] autorelease];
         self.quizViewController = quizController;
         self.quizViewController.parentController = self;
         
     }
    [self.view addSubview:self.quizViewController.view];
    
    CGRect frame = [self.quizViewController.view frame];
    frame.origin.x = 340;
    
    self.quizViewController.view.frame = frame;
    
    CGRect newViewFrame = self.view.frame;
    
    [UIView beginAnimations:nil context:NULL];
    [UIView setAnimationDuration:.5];
    
    // Slide up based on y axis
    // A better solution over a hard-coded value would be to
    // determine the size of the title and msg labels and 
    // set this value accordingly
    newViewFrame.origin.x = 0.0;
    newViewFrame.origin.y = 0.0;
    quizViewController.view.frame = newViewFrame;
    [UIView commitAnimations];

}

-(void)clearQuizView
{
    [self.quizViewController.view removeFromSuperview];
    self.quizViewController = nil;
}

-(IBAction)showAcknowledgements:(id)sender
{
    AcknowledgementsViewController *ackView = [[AcknowledgementsViewController alloc] initWithNibName:@"AcknowledgementsView"
                                                                                               bundle:nil];
    [self presentModalViewController:ackView animated:YES];
    [ackView release];
}

#pragma mark - View lifecycle


// Implement viewDidLoad to do additional setup after loading the view, typically from a nib.
- (void)viewDidLoad
{
    [super viewDidLoad];
    
    [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleBlackTranslucent];
    
#ifdef LITE_VERSION
    [self.backgroundView setImage:[UIImage imageNamed:@"Default_lite.png"]];
#endif
    
    [Utilities checkBundleCompleteness];
    
    
}


- (void)viewDidUnload
{
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
    self.backgroundView = nil;
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    // Return YES for supported orientations
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

@end
