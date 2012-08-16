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
@synthesize quizViewController, quizPrepAV;

- (void)dealloc
{
    [planetaryObjectViewController release];
    [quizViewController release];
    [backgroundView release];
    [quizPrepAV release];
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
    
    CGRect frame = [self.planetaryObjectViewController.view frame];
    frame.origin.x = 340;
    
    self.planetaryObjectViewController.view.frame = frame;
    
    if (!self.planetaryObjectViewController.view.superview)
        [self.view addSubview:self.planetaryObjectViewController.view];
    
    [self.planetaryObjectViewController.homeButton setHighlighted:NO];
    CGRect newViewFrame = self.view.frame;
    
    [UIView beginAnimations:nil context:NULL];
    [UIView setAnimationDuration:.5];
    newViewFrame.origin.x = 0.0;
    newViewFrame.origin.y = -5.0;
    self.planetaryObjectViewController.view.frame = newViewFrame;
    [UIView commitAnimations];
}


-(IBAction)challengeYourself:(id)sender
{
    PlanetCardsAppDelegate *appDelegate = (PlanetCardsAppDelegate *)[[UIApplication sharedApplication] delegate];
    QuizDB* quizDB = [appDelegate quizDB];
    if ([quizDB contentLoaded])
    {
        if (self.quizPrepAV.isAnimating)
        {
            [self.quizPrepAV stopAnimating];
            [self.quizPrepAV removeFromSuperview];
            [[NSNotificationCenter defaultCenter] removeObserver:self];
        }
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
    else
    {
        [[NSNotificationCenter defaultCenter] addObserver:self
                                                 selector:@selector(challengeYourself:)
                                                     name:kQuizDBLoaded
                                                   object:nil];
        
        self.quizPrepAV = [[UIActivityIndicatorView alloc] initWithFrame:CGRectMake(256.0, 394.0, 50.0,50.0)];
        [self.quizPrepAV setActivityIndicatorViewStyle:UIActivityIndicatorViewStyleWhite];
        [self.view addSubview:self.quizPrepAV];
        [self.quizPrepAV startAnimating];
    }
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
    
    [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleBlackOpaque];
    
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
