//
//  PlanetaryObjectViewController.m
//  PlanetCards
//
//  Created by Beaudry Kock on 7/2/11.
//  Copyright 2011 Better World Coding. All rights reserved.
//

#import "PlanetaryObjectViewController.h"


@implementation PlanetaryObjectViewController

@synthesize scrollingObjectView, scrollingViewControllers, pageControl, mainPlanetaryImageList, moreSatellitesButtonView, moreSatellitesButtonLabel, scrollingSatellites;
@synthesize objectTitleFrame_1,objectTitleFrame_2,objectTitleFrame_3, activeObjectName, objectDB, objectNameLabel, objectTypeLabel, satelliteCountLabel, satelliteCountLabelView;
@synthesize imageFilenames, imageLabels, imageViews, numberOfPlanetaryObjects;
@synthesize homeButton, infoButton;
@synthesize backToPlanetLabel, backToPlanetButtonView;
@synthesize backgroundTopPanel;
@synthesize infoTab, mainScrollingObjectView, moon, backToPlanetInnerContainerView, satelliteCountInnerContainerView, planetaryImages, scrollableInterior, exitTarget;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidUnload
{
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
    
    self.scrollableInterior = nil;
    self.planetaryImages = nil;
    self.satelliteCountInnerContainerView = nil;
    self.backToPlanetInnerContainerView = nil;
    self.moon = nil;
    self.scrollingObjectView = nil;
    self.objectNameLabel = nil;
    self.objectTypeLabel = nil;
    self.pageControl = nil;
    self.objectTitleFrame_1 = nil;
    self.objectTitleFrame_2 = nil;
    self.objectTitleFrame_3 = nil;
    self.satelliteCountLabelView = nil;
    self.satelliteCountLabel = nil;
    self.moreSatellitesButtonLabel = nil;
    self.moreSatellitesButtonView = nil;
    self.homeButton = nil;
    self.infoButton = nil;
    self.backToPlanetButtonView = nil;
    self.backToPlanetLabel = nil;
    self.backgroundTopPanel = nil;
    self.infoTab = nil;
}

- (void)dealloc
{
    [exitTarget release];
    [scrollableInterior release];
    [planetaryImages release];
    [scrollingObjectView release];
    [pageControl release];
    [scrollingViewControllers release];
    [mainPlanetaryImageList release];
    [activeObjectName release];
    [objectDB release];
    [objectTitleFrame_1 release];
    [objectTitleFrame_2 release];
    [objectTitleFrame_3 release];
    [objectNameLabel release];
    [objectTypeLabel release];
    [satelliteCountLabelView release];
    [satelliteCountInnerContainerView release];
    [satelliteCountLabel release];
    [moreSatellitesButtonView release];
    [moreSatellitesButtonLabel release];
    [backToPlanetButtonView release];
    [backToPlanetLabel release];
    [backgroundTopPanel release];
    [infoTab release];
    [scrollingSatellites release];
    [imageFilenames release];
    [images release];
    [imageLabels release];
    [imageViews release];
    [currentBorder release];
    [numberOfPlanetaryObjects release];
    [homeButton release];
    [infoButton release];
    [infoTab release];
    [mainScrollingObjectView release];
    [backToPlanetInnerContainerView release];
    [moon release];
    
    [super dealloc];
}

- (void)animationDidStop:(NSString*)animationID finished:(BOOL)finished context:(void *)context 
{
    UIView *viewToRemove = [self.view viewWithTag:kInfoViewTag];
    viewToRemove.hidden = YES;
    [self.view bringSubviewToFront:viewToRemove];
    [viewToRemove removeFromSuperview];

}

- (void)didReceiveMemoryWarning
{
    // Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
    
    // Release any cached data, images, etc that aren't in use.
}



#pragma mark - 
#pragma mark - Frame management
-(void)setFrameToInitialPosition
{
    if (currentBorder)
        [currentBorder removeFromSuperview];
    
    // show outline
    CGRect frame = [[imageViews objectAtIndex:0] frame];
    frame.size.width = frame.size.width+5.0;
    frame.origin.x -= 2.5;
    frame.origin.y = 3.0;
    frame.size.height = 60.0f;
    currentBorder = nil;
    currentBorder = [[UIView alloc] initWithFrame:frame];
    [currentBorder.layer setBorderColor: [[UIColor colorWithRed:255.0/255.0 green:141.0/255.0 blue:44.0/255.0 alpha:1.0] CGColor]];
    [currentBorder.layer setBorderWidth: 2.0];
    
    [scrollingObjectView addSubview:currentBorder];   
}

-(void)setFrameToImageAtIndex:(NSInteger)index
{
    if (currentBorder)
        [currentBorder removeFromSuperview];
    
    // show outline
    CGRect frame = [[imageViews objectAtIndex:index] frame];
    frame.size.width = frame.size.width+5.0;
    frame.origin.x -= 2.5;
    frame.origin.y = 3.0;
    frame.size.height = 60.0f;
    currentBorder = nil;
    currentBorder = [[UIView alloc] initWithFrame:frame];
    [currentBorder.layer setBorderColor: [[UIColor colorWithRed:255.0/255.0 green:141.0/255.0 blue:44.0/255.0 alpha:1.0] CGColor]];
    [currentBorder.layer setBorderWidth: 2.0];
    
    [scrollingObjectView addSubview:currentBorder];
    
}

-(BOOL)activeObjectInRangeForPage:(NSUInteger)pageNumber
{
    
    NSArray *possibles = [objectDB arrayofActiveObjectsForPageNumber:pageNumber];
    
    if ([possibles containsObject:activeObjectName])
    {
        return YES;
    }
    return NO;
}

#pragma mark - View lifecycle

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    [self loadObjectDB];
    
    [self loadTopScrollView];
    
    [self loadBottomScrollView];
    
    satellitesShowing = NO;
    
    restoreSatellites = NO;
    
    satellitesCountShowing = NO;
     
    self.activeObjectName = [self.objectDB objectNameForIndex: mainScrollViewPage];
    self.objectNameLabel.text = [self.activeObjectName uppercaseString];
    self.objectTypeLabel.text = [[self.objectDB objectTypeForIndex: mainScrollViewPage] uppercaseString];

    self.exitTarget = [[UIButton alloc] initWithFrame:CGRectMake(8.0, 8.0, 44.0, 44.0)];
    [self.exitTarget addTarget:self action:@selector(home:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:exitTarget];
    
    [self.homeButton setHighlighted:NO];
}


- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    // Return YES for supported orientations
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

-(void)loadTopScrollView
{
    scrollableInterior = [[UIView alloc] initWithFrame:CGRectMake(0.0, 0.0, 306*12.0, 337)];
    self.mainScrollingObjectView = [[UIScrollView alloc] initWithFrame:CGRectMake(7, 43, 306, 337)];
    [self.mainScrollingObjectView setTag:kMainScrollViewTag];
    [self.mainScrollingObjectView setPagingEnabled: YES];
    [self.mainScrollingObjectView setDirectionalLockEnabled: YES];
    [self.mainScrollingObjectView setUserInteractionEnabled: YES];
    [self.mainScrollingObjectView setDelegate:self];
    [self.view insertSubview:self.mainScrollingObjectView belowSubview:self.objectTitleFrame_2];
    float scrollableContentWidth = [[self.objectDB numberOfPlanetaryObjects] intValue]*306.0;
    float scrollContentHeight = 337.0;
    [self.mainScrollingObjectView setContentSize:CGSizeMake(scrollableContentWidth, scrollContentHeight)];
    self.planetaryImages =[[NSMutableArray alloc] initWithCapacity:[[self.objectDB numberOfPlanetaryObjects] intValue]];
    float image_pos_x = 0.0;
    float image_pos_y = 0.0;
    
    for (int i = 0; i<[[self.objectDB numberOfPlanetaryObjects] intValue]; i++)
    {
        NSString *imageFilename = [objectDB mainImageFilenameForIndex: i];
        UIImage *image = [UIImage imageWithContentsOfFile:[[NSBundle mainBundle] pathForResource:imageFilename ofType:@"png"]];
        UIImageView* newPlanet = [[UIImageView alloc] initWithImage:image];
        newPlanet.contentMode = UIViewContentModeScaleAspectFit;
        
        // double tap to zoom
        //UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget: self action:@selector(scrollViewDoubleTapped:)];
        //[tap setNumberOfTapsRequired:2];
        //[newPlanet addGestureRecognizer: tap];
        //[newPlanet setUserInteractionEnabled:YES];
        
        // single tap to show info
        UITapGestureRecognizer *tap_info = [[UITapGestureRecognizer alloc] initWithTarget: self action:@selector(showPlanetaryInfo:)];
        [tap_info setNumberOfTapsRequired:1];
        [newPlanet addGestureRecognizer: tap_info];
        [tap_info release];
        [newPlanet setUserInteractionEnabled:YES];
        
        UIScrollView *scroll = [[UIScrollView alloc] initWithFrame:CGRectMake(image_pos_x, image_pos_y, 306.0, 337.0)];
        [scroll setTag:500];
        [scroll setDelegate:self];
        [scroll addSubview:newPlanet];
        [scroll setMinimumZoomScale:1.0];
        [scroll setMaximumZoomScale:1.5];
        [self.mainScrollingObjectView addSubview:scroll];
        [scroll release];
        [newPlanet setFrame:CGRectMake(0.0, 0.0, 306.0, 337.0)];
        //[self.scrollableInterior addSubview:newPlanet];
        //[self.mainScrollingObjectView addSubview: newPlanet];
        //[newPlanet setFrame:CGRectMake(image_pos_x, image_pos_y, 306.0, 337.0)];
        image_pos_x+=306.0;
        [newPlanet release];
    }
    //[self.mainScrollingObjectView addSubview:self.scrollableInterior];
    
    mainScrollViewPage = 0;
    activeObjectName = [objectDB objectNameForIndex: mainScrollViewPage];
    
}

-(void)loadBottomScrollView
{
    [self setImageLabels: [objectDB arrayOfObjectNames]];
    [self setImageFilenames: [objectDB arrayOfObjectTabImageFilenames]];
    [self setNumberOfPlanetaryObjects: [objectDB numberOfPlanetaryObjects]];
    
    imageViews = [[NSMutableArray alloc] initWithCapacity:[imageFilenames count]];
    
    int objCount = [numberOfPlanetaryObjects intValue];
    
    // constants
    float imageHeight = 45.0;
    float imageWidth = 45.0;
    float labelHeight = 10.0;
    float labelWidth = 55.0;
    float imageToLabel_y_distance = 2.0;
    float imagesTopBottomMargin = 5.0;
    float imagesLeftRightMargin = 10.0;
    float images_pos_x = imagesLeftRightMargin;
    float images_pos_y = imagesTopBottomMargin;
    float label_pos_x = 5.0;
    float label_pos_y = images_pos_y + imageHeight + imageToLabel_y_distance;
    float scrollableContentHeight = 63.0;
    float scrollableContentWidth = objCount*(imageWidth
                                             +imagesLeftRightMargin);
    for (int i = 0; i<12; i++)
    {
        NSString *imageFilename = [[[objectDB planetaryObjects] objectAtIndex: i] tabImageFilenameWithoutType];
        UIImage *image = [UIImage imageWithContentsOfFile:[[NSBundle mainBundle] pathForResource:imageFilename ofType:@"png"]];
        UIImageView* newPlanet = [[UIImageView alloc] initWithImage:image];
        newPlanet.contentMode = UIViewContentModeScaleAspectFit;
        [newPlanet setTag:i];
        UILabel *planetLabel = [[UILabel alloc] initWithFrame:CGRectMake(label_pos_x, label_pos_y, labelWidth, labelHeight)];
        
        // TODO: insert right image label control, as per below
        // add image labels
        NSString *upperCaseConv = nil;
        if ([[imageLabels objectAtIndex:i] isEqualToString:@"Hale-Bopp"])
        {
            [planetLabel setText:@"COMETS"];
        }
        else if ([[imageLabels objectAtIndex:i] isEqualToString:@"Ceres"])
        {
            [planetLabel setText:@"ASTEROIDS"];
        }
        else
        {
            upperCaseConv = [imageLabels objectAtIndex:i];
            upperCaseConv = [upperCaseConv uppercaseString];
            [planetLabel setText: upperCaseConv];
        }
        
        [planetLabel setFont:[UIFont fontWithName:@"HelveticaNeue" size: kScrollObjectLabelFontSize]];
        [planetLabel setBackgroundColor:[UIColor clearColor]];
        [planetLabel setTextColor:[UIColor whiteColor]];
        planetLabel.textAlignment = UITextAlignmentCenter;
        
        [newPlanet setUserInteractionEnabled:YES];
        UITapGestureRecognizer *singleTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(showPlanetaryObjectViaLowerScrollTap:)];
        [newPlanet setTag:i];
        [newPlanet addGestureRecognizer:singleTap];
        
        [scrollingObjectView addSubview: newPlanet];
        [imageViews addObject: newPlanet];
        [scrollingObjectView addSubview: planetLabel];
        [newPlanet setFrame:CGRectMake(images_pos_x, images_pos_y, imageWidth, imageHeight)];
        
        images_pos_x += imageWidth+imagesLeftRightMargin;
        label_pos_x = images_pos_x-5.0;
        
    }       
    
    CGSize size = CGSizeMake(scrollableContentWidth, scrollableContentHeight); // figure out correct height here
    [scrollingObjectView setBackgroundColor:[UIColor colorWithRed:24.0/255.0 green:24.0/255.0 blue:24.0/255.0 alpha:1.0]];
    [scrollingObjectView setDirectionalLockEnabled:YES];
    [scrollingObjectView setContentSize:size];
    
    //[self clearFrames];
    [self setFrameToInitialPosition];
    
}


#pragma mark - Scrolling delegate methods
- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    if (scrollView.tag == kMainScrollViewTag && !controlledScrolling && !zooming)
    {
        mainScrollViewPage = [self getCurrentMainScrollViewPage];
        
        // move lower scroll view to match
        CGPoint offset_lower = self.scrollingObjectView.contentOffset;
        CGPoint offset_upper = self.mainScrollingObjectView.contentOffset;
        float offset_x_as_percent = offset_upper.x/self.mainScrollingObjectView.contentSize.width;
        //NSLog(@"current offset lower x = %f", offset_lower.x);
        //NSLog(@"computed offset lower x = %f", offset_x_as_percent*self.scrollingObjectView.contentSize.width);
        if (!((offset_x_as_percent*self.scrollingObjectView.contentSize.width)>=offset_lower.x &&
            ((offset_x_as_percent*self.scrollingObjectView.contentSize.width)+45.0)<=(offset_lower.x+self.scrollingObjectView.frame.size.width)))
        {
            float supplement = 0.0;
            if (((offset_x_as_percent*self.scrollingObjectView.contentSize.width)+45.0)>(offset_lower.x+self.scrollingObjectView.frame.size.width))
            {
                supplement = 20.0;
            }
            offset_lower.x = offset_x_as_percent*self.scrollingObjectView.contentSize.width;
            CGRect scrollTo = CGRectMake(offset_lower.x+supplement, offset_upper.y, 45.0, 450.0);
            [self.scrollingObjectView scrollRectToVisible:scrollTo animated: YES];
            //[self.scrollingObjectView setContentOffset:offset_lower];
        }
    }
}

- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView
{
    mainScrollViewPage = [self getCurrentMainScrollViewPage];
    
    if (mainScrollViewPage != mainScrollViewLastPage)
    {
        // have changed page
        mainScrollViewLastPage = mainScrollViewPage;
    }
    
    if (!controlledScrolling)
    {
        [self setFrameToImageAtIndex:mainScrollViewPage];
    }
    
    self.activeObjectName = [objectDB objectNameForIndex: mainScrollViewPage];
        
    [self showPlanetaryObjectAtPage:mainScrollViewPage];
}

- (void)scrollViewDidEndScrollingAnimation:(UIScrollView *)scrollView
{
    if (controlledScrolling) controlledScrolling = NO;
    activeObjectName = [objectDB objectNameForIndex: mainScrollViewPage];
    

}

-(NSInteger)getCurrentMainScrollViewPage
{
    CGFloat pageWidth = self.mainScrollingObjectView.frame.size.width;
    int page = floor((self.mainScrollingObjectView.contentOffset.x - pageWidth / 2) / pageWidth) + 1;
    return page;
}

#pragma mark - 
#pragma mark - Multitouch controls

-(void)showInfoViaImageDoubleTap
{
    [self showPlanetaryInfo:nil];
}

-(void)moveScrollToLeft
{
    CGPoint existingOffset = scrollingObjectView.contentOffset;
    [UIView beginAnimations:nil context:nil];
    [UIView setAnimationDuration:0.5];
    scrollingObjectView.contentOffset = CGPointMake(existingOffset.x+[[imageViews objectAtIndex:lastPlanetaryObjectIndex] frame].size.width+10.0, 0);
    [UIView commitAnimations];
}

-(void)moveScrollToRight
{
    CGPoint existingOffset = scrollingObjectView.contentOffset;
    [UIView beginAnimations:nil context:nil];
    [UIView setAnimationDuration:0.5];
    scrollingObjectView.contentOffset = CGPointMake(existingOffset.x-([[imageViews objectAtIndex:lastPlanetaryObjectIndex] frame].size.width+10.0), 0);
    [UIView commitAnimations];
}

-(IBAction)home:(id)sender
{
    [self.homeButton setHighlighted:YES];
    CGRect frame = [self.view frame];
    
    // insert code here to remove quiz view controller
    // [quizViewController.view removeFromSuperview];
    CGRect newViewFrame = frame;
    newViewFrame.origin.x += 320.0;
    
    [UIView beginAnimations:nil context:NULL];
    [UIView setAnimationDuration:.5];
    
    self.view.frame = newViewFrame;
    [UIView commitAnimations];
    
}

#pragma mark - 
#pragma mark - Data model
-(void)loadObjectDB
{
    PlanetCardsAppDelegate *appDelegate = (PlanetCardsAppDelegate *)[[UIApplication sharedApplication] delegate];
    objectDB = [appDelegate objectDB];
    
    totalPages = [[objectDB numberOfPlanetaryObjects] intValue];
}

-(NSArray*)arrayOfFactoidsForActiveObject
{
    NSArray *factoids  = [NSArray arrayWithArray:[objectDB factoidsForObjectNamed:activeObjectName]];
    
    return factoids;
}


-(NSString*)teaserForActiveObject
{
    return [objectDB teaserForObjectNamed:activeObjectName];
}

#pragma mark - 
#pragma mark - Managing planetary objects
-(void)showPlanetaryObjectViaLowerScrollTap:(UITapGestureRecognizer*)tap
{
    UIImageView *planetTapped = (UIImageView*)tap.view;
    mainScrollViewPage = planetTapped.tag;
    mainScrollViewLastPage = planetTapped.tag;
    [self scrollMainScrollingViewToCurrentPage];
    [self showPlanetaryObjectAtPage:planetTapped.tag];
}

// for use when lower scroll view is tapped and top view needs to be aligned
-(void)scrollMainScrollingViewToCurrentPage
{
    controlledScrolling = YES;
    
    float upper_offset = (mainScrollViewPage*1.0)/(totalPages*1.0) * self.mainScrollingObjectView.contentSize.width;
    //NSLog(@"upper offset = %f", upper_offset);
    CGRect scrollTo = CGRectMake(upper_offset, 0.0, self.mainScrollingObjectView.frame.size.width, self.mainScrollingObjectView.frame.size.height);
    
    [self.mainScrollingObjectView scrollRectToVisible:scrollTo animated:YES];
    
    //CGPoint newOffset = CGPointMake(upper_offset, self.mainScrollingObjectView.contentOffset.y);
    //[self.mainScrollingObjectView setContentOffset:newOffset];
}

-(void)showPlanetaryObjectAtPage: (NSInteger)page
{
    if ([self.moon superview]!=nil)
    {
        // if a moon is showing, need to remove the image
        [self.moon removeFromSuperview];
        [self.view insertSubview: self.mainScrollingObjectView belowSubview: self.satelliteCountLabelView];
    
        // also need to remove the back-to-planet button
        [self.backToPlanetButtonView removeFromSuperview];
    }
    
    if (![objectDB objectAtIndexIsSatellite:page])
    {
        keepSatelliteStrip = NO;
    }
    
    if (!keepSatelliteStrip)
    {
        [self hideSatellites];
        [self hideSatellitesCount];
    }
    
    // clear any info view if necessary
    if (infoViewDisplayed)
    {
        [self closeInfoView];
        infoViewDisplayed = NO;
    }
    
    activeObjectName = [objectDB objectNameForIndex: page];
    objectNameLabel.text = [activeObjectName uppercaseString];
    objectTypeLabel.text = [[objectDB objectTypeForIndex: page] uppercaseString];
    
    // make sure planetary index is set
    lastPlanetaryObjectIndex = page;
    
    if (lastPlanetaryObjectIndex<12)
    {
        [self setFrameToImageAtIndex:page];
    }
    
    if (!satellitesCountShowing)
        [self addSatellitesIndicatorForObjectAtIndex:page];
    
    if (!satellitesShowing && restoreSatellites)
    {
        [self restoreSatellites];
    }
}

#pragma mark - 
#pragma mark - Info view management
-(void)remoteCall_closeInfo
{
    [self showPlanetaryInfo:nil];
}

-(IBAction)showPlanetaryInfo:(id)sender
{
    if (!infoViewDisplayed)
    {
        if (satellitesShowing)
        {
            [self hideSatellites];
            
            restoreSatellites = YES;
        }
        
        if (satellitesCountShowing && satelliteType != kSatelliteType_comet)
        {
            restoreSatelliteCount = YES;
            [self hideSatellitesCount];
        }
        
        
        UIImage *image = [UIImage imageWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"info_selected" ofType:@"png"]];
        [infoButton setImage:image forState:UIControlStateNormal];
        
        infoViewDisplayed = YES;
        PlanetaryInfoViewController* infoViewController = [[[PlanetaryInfoViewController alloc] init] retain];
        [infoViewController setObjectName: activeObjectName];
        [infoViewController setInfoValues: [self arrayOfFactoidsForActiveObject]];
        
        [infoViewController setObjectTeaser: [self teaserForActiveObject]];
        [infoViewController setParentController:self];
        
        int index = [[self.view subviews] indexOfObject:self.mainScrollingObjectView];
        
        if (self.moon.superview!=nil && satelliteType==kSatelliteType_moon)
        {
            index = [[self.view subviews] indexOfObject:self.backToPlanetButtonView];
        }
        else if (self.moon.superview!=nil && satelliteType==kSatelliteType_comet) {
            index = [[self.view subviews] indexOfObject:self.satelliteCountLabelView];
        }
        [infoViewController.view setTag:kInfoViewTag];
        CGRect objectTitleView_frame = objectTitleFrame_1.frame; 
        CGRect offscreen_rect = CGRectMake(objectTitleView_frame.origin.x, -301.0, infoViewController.view.frame.size.width, infoViewController.view.frame.size.height);
        
        [infoViewController.view setFrame:offscreen_rect];
        
        float y_origin = objectTitleView_frame.origin.y+objectTitleView_frame.size.height+2.0; 
        
        
        [self.view insertSubview:infoViewController.view atIndex:index+1];
        //[self.view addSubview:infoViewController.view];
        [infoViewController release];
        
        // Slide the view down off screen
        [UIView beginAnimations:nil context:NULL];
        [UIView setAnimationDuration:.75];
        
        CGRect rect = CGRectMake(objectTitleView_frame.origin.x, y_origin, infoViewController.view.frame.size.width, infoViewController.view.frame.size.height);
        [infoViewController.view setFrame:rect];
        [UIView commitAnimations];
    }
    else
    {
        UIImage *image = [UIImage imageWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"info_btn" ofType:@"png"]];
        [infoButton setImage:image forState:UIControlStateNormal];
        [self closeInfoView];
        infoViewDisplayed = NO;
                
        if (!satellitesCountShowing && restoreSatelliteCount)
        {
            [self addSatellitesIndicatorForObjectAtIndex:lastPlanetaryObjectIndex];
            restoreSatelliteCount = NO;
        }
        if (!satellitesShowing && restoreSatellites)
        {
            [self restoreSatellites];
        }
        
    }
}

-(void)closeInfoView
{
    UIView *viewToRemove = [self.view viewWithTag:kInfoViewTag];
    
    // NEW
    // Slide the up off screen
    [UIView beginAnimations:nil context:NULL];
    [UIView setAnimationDuration:.75];
    
    CGRect removalFrame = CGRectMake(viewToRemove.frame.origin.x, -301.0, viewToRemove.frame.size.width, viewToRemove.frame.size.width);
    
    CGRect oldInfoTabFrame = infoTab.frame;
    CGRect newInfoTabFrame = CGRectMake(oldInfoTabFrame.origin.x, 
                                        oldInfoTabFrame.origin.y-viewToRemove.frame.size.height, 
                                        oldInfoTabFrame.size.width, 
                                        oldInfoTabFrame.size.height);
    infoTab.frame = newInfoTabFrame;
    
    viewToRemove.frame = removalFrame;
    
    [UIView setAnimationDelegate:self];
    [UIView setAnimationDidStopSelector:@selector(animationDidStop:finished:context:)];
    [UIView commitAnimations];
    
    //viewToRemove.hidden = YES;
    //[self.view bringSubviewToFront:viewToRemove];
    //[viewToRemove removeFromSuperview];
}

#pragma mark - 
#pragma mark - Satellite scroll and display
-(void)restoreSatellites
{
    [self displaySatellitesForObjectAtIndex: lastPlanetaryObjectIndex];
    satellitesShowing = YES;
    restoreSatellites = NO;
}

-(void)showSatellitesButtonTap
{
    if (!satellitesShowing)
    {
        [self displaySatellitesForObjectAtIndex: lastPlanetaryObjectIndex];
        satellitesShowing = YES;
    }
    else
    {
        [self hideSatellites];
        satellitesShowing = NO;
    }
}

-(void)hideSatellitesCount
{
    satellitesCountShowing = NO;
    [satelliteCountLabelView removeFromSuperview];
}

-(void)hideSatellites
{
    UIView* removeView = nil;
    while ((removeView = [self.view viewWithTag:1000]) != nil)
    {
        [removeView removeFromSuperview];
        satellitesShowing = NO;
    }
}

-(void)displaySatellitesForObjectAtIndex:(NSUInteger)index
{
    if ([objectDB objectWithSatellitesAtIndex: index])
    {
        NSArray *satellites = [objectDB arrayOfSatellitesForObjectAtIndex: index];
        BOOL addCometTapRecognizers = NO;
        
        PlanetaryObject *testForComets = [satellites objectAtIndex:0];
        if ([[testForComets type] isEqualToString:kCometType])
        {
            // add gesture recognizers
            addCometTapRecognizers = YES;
            
        }
        
        // constants 
        float satImageHeight = kSatelliteImageHeight;
        float satImageWidth = kSatelliteImageWidth;
        float satBackgroundWidth = kSatelliteScrollViewWidth;
        float satLabelHeight = 10.0;
        float satLabelWidth = satBackgroundWidth;
        float imageToLabel_y_distance = 2.0;
        float labelToNextImage_y_distance = 5.0;
        float imagesTopBottomMargin = 10.0;
        float imagesLeftRightMargin = kSatelliteImageSideMargins;
        float satelliteCountLabelFramePosition_y = [satelliteCountLabelView frame].origin.y;
        float satBackgroundPosition_x = 6.0;
        float satBackgroundPosition_y = satelliteCountLabelFramePosition_y + [satelliteCountLabelView frame].size.height + imageToLabel_y_distance;
        float satImagesPosition_x = imagesLeftRightMargin;
        float satImagesPosition_y = imagesTopBottomMargin;
        float satLabel_pos_x = 0.0;
        float satLabel_pos_y = satImagesPosition_y + satImageHeight + imageToLabel_y_distance;
        
        float backgroundHeightFactor = [satellites count];
        if (backgroundHeightFactor > 4.1)
        {
            backgroundHeightFactor = 4.15;
        }
        
        float satBackgroundHeight = (backgroundHeightFactor*(satImageHeight+imageToLabel_y_distance+satLabelHeight+labelToNextImage_y_distance))+(imagesTopBottomMargin*2);
        
        float scrollableContentHeight = ([satellites count]*(satImageHeight+imageToLabel_y_distance+satLabelHeight+labelToNextImage_y_distance))+(imagesTopBottomMargin*2);
        
        /*UIScrollView */
        scrollingSatellites = [[UIScrollView alloc] initWithFrame:CGRectMake(satBackgroundPosition_x, satBackgroundPosition_y, satBackgroundWidth, satBackgroundHeight)];
        
        for (int i = 0; i<[satellites count]; i++)
        {
            NSString *satelliteImageFilename = [[satellites objectAtIndex: i] tabImageFilenameWithoutType];
            UIImage *image = [UIImage imageWithContentsOfFile:[[NSBundle mainBundle] pathForResource:satelliteImageFilename ofType:@"png"]];
            UIImageView* newSatellite = [[UIImageView alloc] initWithImage:image];
            
            UILabel *satelliteLabel = [[UILabel alloc] initWithFrame:CGRectMake(satLabel_pos_x, satLabel_pos_y, satLabelWidth, satLabelHeight)];
            NSString *satLabUC =[[satellites objectAtIndex: i] name];
            satLabUC = [satLabUC uppercaseString];
            [satelliteLabel setText: satLabUC];
            [satelliteLabel setFont:[UIFont fontWithName:@"Helvetica" size: 10.0]];
            [satelliteLabel setBackgroundColor:[UIColor clearColor]];
            [satelliteLabel setTag:1000];
            [satelliteLabel setTextColor:[UIColor whiteColor]];
            satelliteLabel.textAlignment = UITextAlignmentCenter;
            if (addCometTapRecognizers)
            {
                [newSatellite setUserInteractionEnabled:YES];
                [newSatellite setTag: i];
                UITapGestureRecognizer *singleTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(showComet:)];
                //Default value for cancelsTouchesInView is YES, which will prevent buttons to be clicked
                //singleTap.cancelsTouchesInView = NO; 
                [newSatellite addGestureRecognizer:singleTap];
                [singleTap release];
            }
            else
            {
                [newSatellite setUserInteractionEnabled:YES];
                UITapGestureRecognizer *singleTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(showMoon:)];
                //Default value for cancelsTouchesInView is YES, which will prevent buttons to be clicked
                //singleTap.cancelsTouchesInView = NO; 
                [newSatellite addGestureRecognizer:singleTap];
                [singleTap release];
                [newSatellite setTag:i];
            }
            
            
            [scrollingSatellites addSubview: newSatellite];
            [scrollingSatellites addSubview: satelliteLabel];
            [newSatellite setFrame:CGRectMake(satImagesPosition_x, satImagesPosition_y, satImageWidth, satImageHeight)];
            
            satImagesPosition_y += (satImageHeight + satLabelHeight + imageToLabel_y_distance + labelToNextImage_y_distance);
            satLabel_pos_y = satImagesPosition_y + satImageHeight + imageToLabel_y_distance;
            [newSatellite release];
            [satelliteLabel release];
        }       
        
        CGSize size = CGSizeMake(satBackgroundWidth, scrollableContentHeight);
        [scrollingSatellites setDirectionalLockEnabled:YES];
        [scrollingSatellites setContentSize:size];
        [scrollingSatellites setBackgroundColor:[UIColor grayColor]];
        [scrollingSatellites setTag:1000];
        scrollingSatellites.layer.cornerRadius = 5.0;
        [scrollingSatellites setBackgroundColor: [UIColor colorWithRed:53.0/255.0 green:53.0/255.0 blue:53.0/255.0 alpha:1.0]];
        [scrollingSatellites setShowsVerticalScrollIndicator:NO];
        
        [self.view addSubview:scrollingSatellites];
        
    }
}

-(void)showComet:(UITapGestureRecognizer*)gesture
{
    keepSatelliteStrip = YES;
    //NSLog(@"[gesture.view tag] = %i", [gesture.view tag]);
    [self showCometAtSubIndex: [gesture.view tag]];
}

-(void)showMoon:(UITapGestureRecognizer *)gesture
{
    keepSatelliteStrip = NO;
    [self showSatelliteAtSubIndex:[[gesture view] tag]];
}

-(void)showSatelliteAtSubIndex:(NSInteger)subIndex
{
    NSArray *satellites = [objectDB arrayOfSatellitesForObjectAtIndex:lastPlanetaryObjectIndex];
    
    satelliteType =kSatelliteType_moon;
    
    // clear any info view if necessary
    if (infoViewDisplayed)
    {
        [self closeInfoView];
        infoViewDisplayed = NO;
    }
    
    if (satellitesShowing)
    {
        [self hideSatellites];
    }
    
    if (satellitesCountShowing)
    {
        [self hideSatellitesCount];
    }
    
    [self showBackToPlanetButtonForPlanetAtIndex: lastPlanetaryObjectIndex];
    
    PlanetaryObject *objToDisplay = [satellites objectAtIndex:subIndex];
    activeObjectName = [objToDisplay name]; // TEST
    objectNameLabel.text = [[objToDisplay name] uppercaseString];
    objectTypeLabel.text = [[objToDisplay type] uppercaseString];
    
    NSString *largeImageFilename = [objToDisplay mainImageFilenameWithoutType];
    UIImage *image = [UIImage imageWithContentsOfFile:[[NSBundle mainBundle] pathForResource:largeImageFilename ofType:@"png"]];
    if (!self.moon)
    {
        self.moon = [[UIImageView alloc] initWithFrame:CGRectMake(mainScrollingObjectView.frame.origin.x,
                                                                     mainScrollingObjectView.frame.origin.y,
                                                                     mainScrollingObjectView.frame.size.width,
                                                                     mainScrollingObjectView.frame.size.height)];
        UITapGestureRecognizer *tap_info = [[UITapGestureRecognizer alloc] initWithTarget: self action:@selector(showPlanetaryInfo:)];
        [tap_info setNumberOfTapsRequired:1];
        [self.moon addGestureRecognizer: tap_info];
        [tap_info release];
        [self.moon setUserInteractionEnabled:YES];
    }
    [self.moon setContentMode: UIViewContentModeScaleAspectFit];
    [self.moon setImage:image];
    [self.mainScrollingObjectView removeFromSuperview];
    [self.view insertSubview:self.moon belowSubview:self.backToPlanetButtonView];
    
}

-(void)showCometAtSubIndex:(NSInteger)subIndex
{
    if ([self.moon superview] != nil)
        [self.moon removeFromSuperview];
    
    NSArray *comets = [objectDB arrayOfSatellitesForObjectAtIndex:11];
    
    satelliteType = kSatelliteType_comet;
   // NSLog(@"no in comets = %i", [comets count]);
    
   // NSLog(@"subindex = %i", subIndex);
    
    // clear any info view if necessary
    if (infoViewDisplayed)
    {
        [self closeInfoView];
        infoViewDisplayed = NO;
    }
    
    if (satellitesShowing)
    {
        [self hideSatellites];
    }
    
    PlanetaryObject *objToDisplay = [comets objectAtIndex:subIndex];
    objectNameLabel.text = [objToDisplay name];
    objectTypeLabel.text = [objToDisplay type];
    
    NSString *largeImageFilename = [objToDisplay mainImageFilenameWithoutType];
    UIImage *image = [UIImage imageWithContentsOfFile:[[NSBundle mainBundle] pathForResource:largeImageFilename ofType:@"png"]];
    if (!self.moon)
    {
        self.moon = [[UIImageView alloc] initWithFrame:CGRectMake(mainScrollingObjectView.frame.origin.x,
                                                                  mainScrollingObjectView.frame.origin.y,
                                                                  mainScrollingObjectView.frame.size.width,
                                                                  mainScrollingObjectView.frame.size.height)];
        UITapGestureRecognizer *tap_info = [[UITapGestureRecognizer alloc] initWithTarget: self action:@selector(showPlanetaryInfo:)];
        [tap_info setNumberOfTapsRequired:1];
        [self.moon addGestureRecognizer: tap_info];
        [tap_info release];
        [self.moon setUserInteractionEnabled:YES];
    }
    [self.moon setContentMode: UIViewContentModeScaleAspectFit];
    [self.moon setImage:image];
    [self.mainScrollingObjectView removeFromSuperview];
    [self.view insertSubview:self.moon belowSubview:self.satelliteCountLabelView];
    
}

-(void)showBackToPlanetButtonForPlanetAtIndex: (NSInteger)index
{
    PlanetaryObject *planetaryObject = [[self.objectDB planetaryObjects] objectAtIndex:index];
    
    [self.backToPlanetLabel setText:[planetaryObject name]];
    
    self.backToPlanetInnerContainerView.layer.cornerRadius = 5.0;
    [self.backToPlanetInnerContainerView setBackgroundColor: [UIColor colorWithRed:53.0/255.0 green:53.0/255.0 blue:53.0/255.0 alpha:1.0]];
    
    [self.backToPlanetButtonView setFrame:CGRectMake(2.0, 45.0, [self.backToPlanetButtonView frame].size.width, [self.backToPlanetButtonView frame].size.height)];
    
    UITapGestureRecognizer *backTap = 
    [[UITapGestureRecognizer alloc]
     initWithTarget:self action:@selector(backToPlanet)];
    
    [self.backToPlanetButtonView addGestureRecognizer:backTap];
    [backTap release];
    [self.view addSubview: self.backToPlanetButtonView];
}

-(void)backToPlanet
{
    [self.moon removeFromSuperview];
    [self.view insertSubview: self.mainScrollingObjectView belowSubview: self.satelliteCountLabelView];
    [backToPlanetButtonView removeFromSuperview];
    restoreSatellites = YES;
    
    UITapGestureRecognizer *falseGesture = [[UITapGestureRecognizer alloc] init];
    UIView *view = [[[UIView alloc] init] autorelease];
    [view setTag:lastPlanetaryObjectIndex];
    [view addGestureRecognizer:falseGesture];
    [falseGesture release];
    
    //[falseGesture release];
    [self showPlanetaryObjectAtPage:mainScrollViewPage];
}

-(void)addSatellitesIndicatorForObjectAtIndex:(NSInteger)index
{
    
    if ([objectDB objectWithSatellitesAtIndex: index])
    {
        PlanetaryObject *planetaryObject = [[objectDB planetaryObjects] objectAtIndex:index];
        
        NSInteger count = [objectDB numberOfSatellitesForObjectAtIndex: index];
        NSString *countStr = nil;
        if (count>1)
        {
            //countStr = [NSString stringWithFormat:@"%i%@", count, @" moons"];
            countStr = @"Moons";
            
        }
        else
        {
            //countStr = [NSString stringWithFormat:@"%i%@", count, @" moon"];
            countStr = @"Moon";
        }
        
        if ([[planetaryObject name] isEqualToString:kCeres])
        {
            if (count>1)
            {
                //countStr = [NSString stringWithFormat:@"%i%@", count, @" asteroids"];
                countStr = @"Asteroids";
            }
            else
            {
                //countStr = [NSString stringWithFormat:@"%i%@", count, @" asteroid"];
                countStr = @"Asteroid";
            }
        }
        countStr = [countStr uppercaseString];
        [satelliteCountLabel setText:countStr];
        
        if ([[planetaryObject type] isEqualToString:kCometType])
        {
            //[satelliteCountLabel setText:@"ALL COMETS"];
            [satelliteCountLabel setText:@"COMETS"];
        }
       
        satelliteCountInnerContainerView.layer.cornerRadius = 5.0;
        satelliteCountLabel.layer.cornerRadius = 5.0;
        [satelliteCountLabel setFont:[UIFont fontWithName:@"HelveticaNeue" size:10.0]];
        [satelliteCountLabel setTextColor:[UIColor blackColor]];
        [satelliteCountLabelView setFrame:CGRectMake(2.0, 44, [satelliteCountLabelView frame].size.width, [satelliteCountLabelView frame].size.height)];
        
        
        UITapGestureRecognizer *satTap = 
        [[UITapGestureRecognizer alloc]
         initWithTarget:self action:@selector(showSatellitesButtonTap)];
        
        [self.satelliteCountLabelView addGestureRecognizer:satTap];
        
        [self.view addSubview: satelliteCountLabelView];
        
        [satTap release];
        satellitesCountShowing = YES;
    }
}

#pragma mark - Zooming
-(UIView*)viewForZoomingInScrollView:(UIScrollView *)scrollView
{
    //return [self.mainScrollingObjectView.subviews objectAtIndex:0];
    //NSLog(@"Scrollview tag = %i", scrollView.tag);
    return [scrollView.subviews objectAtIndex:0];
}

-(void)scrollViewWillBeginZooming:(UIScrollView *)scrollView withView:(UIView *)view
{
    
}

-(void)scrollViewDidZoom:(UIScrollView *)scrollView
{
    //[self centerScrollViewContents];
}

-(void)scrollViewDidEndZooming:(UIScrollView *)scrollView withView:(UIView *)view atScale:(float)scale
{
    //zooming = NO;
    //if (scale>1.01 || scale < 0.99)
   // {
     //   [self.mainScrollingObjectView setScrollEnabled:NO];
    //}
    //else {
     //   [self.mainScrollingObjectView setScrollEnabled:YES];
    //}
}

- (void)scrollViewDoubleTapped:(UITapGestureRecognizer*)recognizer {
    // 1
    CGPoint pointInView = [recognizer locationInView:self.scrollableInterior];
    
    // 2
    CGFloat newZoomScale = self.mainScrollingObjectView.zoomScale * 1.5f;
    newZoomScale = MIN(newZoomScale, self.mainScrollingObjectView.maximumZoomScale);
    
    // 3
    CGSize scrollViewSize = self.mainScrollingObjectView.bounds.size;
    
    CGFloat w = scrollViewSize.width / newZoomScale;
    CGFloat h = scrollViewSize.height / newZoomScale;
    CGFloat x = pointInView.x - (w / 2.0f);
    CGFloat y = pointInView.y - (h / 2.0f);
    
    CGRect rectToZoomTo = CGRectMake(x, y, w, h);
    
    // 4
    [self.mainScrollingObjectView zoomToRect:rectToZoomTo animated:YES];
}

- (void)centerScrollViewContents {
    CGSize boundsSize = self.mainScrollingObjectView.bounds.size;
    CGRect contentsFrame = self.scrollableInterior.frame;
    
    if (contentsFrame.size.width < boundsSize.width) {
        contentsFrame.origin.x = (boundsSize.width - contentsFrame.size.width) / 2.0f;
    } else {
        contentsFrame.origin.x = 0.0f;
    }
    
    if (contentsFrame.size.height < boundsSize.height) {
        contentsFrame.origin.y = (boundsSize.height - contentsFrame.size.height) / 2.0f;
    } else {
        contentsFrame.origin.y = 0.0f;
    }
    
    self.scrollableInterior.frame = contentsFrame;
}

@end
