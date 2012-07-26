//
//  AcknowledgementsViewController.m
//  PlanetCards
//
//  Created by Beaudry Kock on 2/24/12.
//  Copyright (c) 2012 Better World Coding. All rights reserved.
//

#import "AcknowledgementsViewController.h"

@implementation AcknowledgementsViewController
@synthesize developedBy, supportFrom, viewTitle;

-(IBAction)hide:(id)sender
{
    [self dismissModalViewControllerAnimated:YES];
}

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

-(IBAction)sendToBWCWithSafari:(id)sender
{
    [[UIApplication sharedApplication] openURL:[NSURL URLWithString: @"http://www.betterworldcoding.org"]];
}

-(IBAction)sendToScientificPlaygroundWithSafari:(id)sender
{
    [[UIApplication sharedApplication] openURL:[NSURL URLWithString: @"http://www.scientificplayground.com"]];
}

-(IBAction)sendToMeloniWithSafari:(id)sender
{
    [[UIApplication sharedApplication] openURL:[NSURL URLWithString: @"http://www.meloni.dk/resultat.php?search=planetkort&submit=S%F8g"]];
}

#pragma mark - View lifecycle

- (void)viewDidLoad
{
    [super viewDidLoad];
    
#ifdef LITE_VERSION
    [self.viewTitle setText:@"About PlanetCards Lite"];
#endif
    
    [self loadUrlButtons];
    // Do any additional setup after loading the view from its nib.
}

-(void)loadUrlButtons
{
    NSString *title = @"Better World Coding";
    CGSize expectedSize_1 = [title sizeWithFont: [UIFont fontWithName:@"Helvetica Neue" size:13.0]];
    title = @"Scientific Playground";
    CGSize expectedSize_2 = [title sizeWithFont: [UIFont fontWithName:@"Helvetica Neue" size:13.0]];
    title = @"Meloni Publishing Company";
    CGSize expectedSize_3 = [title sizeWithFont: [UIFont fontWithName:@"Helvetica Neue" size:13.0]];
    
    
    UIButton *bwcButton = [UIUnderlinedButton underlinedButton];
    bwcButton.frame=CGRectMake(developedBy.frame.origin.x+developedBy.frame.size.width, developedBy.frame.origin.y+2, expectedSize_1.width, expectedSize_2.height);
    [bwcButton.titleLabel setFont:[UIFont fontWithName:@"Helvetica Neue" size:13.0]];
    [bwcButton.titleLabel setTextColor:[UIColor whiteColor]];
    [bwcButton setTitle:@"Better World Coding" forState:UIControlStateNormal];
    [bwcButton addTarget:self action:@selector(sendToBWCWithSafari:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:bwcButton];
    
    UIButton *sciPlayButton = [UIUnderlinedButton underlinedButton];
    sciPlayButton.frame=CGRectMake(supportFrom.frame.origin.x+supportFrom.frame.size.width, supportFrom.frame.origin.y+4, expectedSize_2.width, expectedSize_2.height);
    [sciPlayButton.titleLabel setFont:[UIFont fontWithName:@"Helvetica Neue" size:13.0]];
    [sciPlayButton.titleLabel setTextColor:[UIColor whiteColor]];
    [sciPlayButton setTitle:@"Scientific Playground" forState:UIControlStateNormal];
    [sciPlayButton addTarget:self action:@selector(sendToScientificPlaygroundWithSafari:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:sciPlayButton];
    
    UIButton *meloniButton = [UIUnderlinedButton underlinedButton];
    meloniButton.frame=CGRectMake(111.0, 358.0, expectedSize_3.width, expectedSize_3.height);
    [meloniButton.titleLabel setFont:[UIFont fontWithName:@"Helvetica Neue" size:13.0]];
    [meloniButton.titleLabel setTextColor:[UIColor whiteColor]];
    [meloniButton setTitle:@"Meloni Publishing Company" forState:UIControlStateNormal];
    [meloniButton addTarget:self action:@selector(sendToMeloniWithSafari:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:meloniButton];
}

- (void)viewDidUnload
{
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
    self.developedBy = nil;
    self.supportFrom = nil;
    self.viewTitle = nil;
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    // Return YES for supported orientations
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

-(void)dealloc
{
    [developedBy release];
    [supportFrom release];
    [viewTitle release];
    
    [super dealloc];
}

@end
