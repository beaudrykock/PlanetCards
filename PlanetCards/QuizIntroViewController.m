//
//  QuizIntroViewController.m
//  PlanetCards
//
//  Created by Beaudry Kock on 2/20/12.
//  Copyright (c) 2012 Better World Coding. All rights reserved.
//

#import "QuizIntroViewController.h"

@implementation QuizIntroViewController

@synthesize parentController;

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

-(IBAction)letsPlay:(id)sender
{
    [[self parentController] startQuiz];
    
    CGRect newframe = CGRectMake(0.0, -460.0, self.view.frame.size.width, self.view.frame.size.height);
    // animate a slide up out of view
    [UIView beginAnimations:nil context:NULL];
    [UIView setAnimationDuration:.5];
    
    // Slide up based on y axis
    // A better solution over a hard-coded value would be to
    // determine the size of the title and msg labels and 
    // set this value accordingly
    self.view.frame = newframe;
    
    [UIView commitAnimations];

//    [self.view removeFromSuperview];
}

#pragma mark - View lifecycle

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
    self.view.layer.cornerRadius = 5.0;
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
