//
//  PlanetaryObjectViewController.h
//  PlanetCards
//
//  Created by Beaudry Kock on 7/2/11.
//  Copyright 2011 Better World Coding. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "PlanetaryInfoViewController.h"
#import "PlanetCardsAppDelegate.h"
#import <QuartzCore/QuartzCore.h>
#import "SingleTapScrollView.h"

@interface PlanetaryObjectViewController : UIViewController <UIScrollViewDelegate> 
{
    
    UIScrollView *scrollingObjectView;
    UIScrollView *mainScrollingObjectView;
    UIPageControl *pageControl;
    NSMutableArray *scrollingViewControllers;
    NSMutableArray *mainPlanetaryImageList;
    NSString *activeObjectName;
    PlanetaryObjectDB *objectDB;
    
    // titles
    IBOutlet UIView *objectTitleFrame_1;
    IBOutlet UIView *objectTitleFrame_2;
    IBOutlet UIView *objectTitleFrame_3;
    IBOutlet UILabel *objectNameLabel;
    IBOutlet UILabel *objectTypeLabel;
    
    // tracking if infoview is shown
    BOOL infoViewDisplayed;
    
    BOOL frameActive;
    
    NSInteger lastPlanetaryObjectIndex;
    
    IBOutlet UIView *satelliteCountLabelView;
    IBOutlet UIView *satelliteCountInnerContainerView;
    IBOutlet UILabel *satelliteCountLabel;
    
    IBOutlet UIView *moreSatellitesButtonView;
    IBOutlet UILabel *moreSatellitesButtonLabel;
    
    IBOutlet UIView *backToPlanetButtonView;
    IBOutlet UIView *backToPlanetInnerContainerView;
    IBOutlet UILabel *backToPlanetLabel;
    
    IBOutlet UIImageView *backgroundTopPanel;
    IBOutlet UIImageView *infoTab;
    
    BOOL satellitesShowing;
    
    UIScrollView *scrollingSatellites;
    
    BOOL keepSatelliteStrip;
    BOOL satellitesCountShowing;
    
    NSArray *imageFilenames;
    NSMutableArray *images;
    NSArray *imageLabels;
    NSMutableArray *imageViews;
    
    UIView *currentBorder;
    NSNumber* numberOfPlanetaryObjects;
    
    UIButton *homeButton;
    UIButton *infoButton;
    
    BOOL restoreSatellites;
    BOOL dragging;
    float oldX;
    float oldY;
    
    NSInteger mainScrollViewLastPage;
    NSInteger mainScrollViewPage;
    NSInteger totalPages;
    BOOL controlledScrolling; // used when the lower scroll view is tapped
    
    UIImageView *moon;
    NSMutableArray *planetaryImages;
    UIView *scrollableInterior;
    BOOL zooming;
    
    NSInteger satelliteType;
    UIButton *exitTarget;
}

@property (nonatomic, retain) UIButton *exitTarget;
@property (nonatomic, retain) IBOutlet UIView *scrollableInterior;
@property (nonatomic, retain) IBOutlet NSMutableArray *planetaryImages;
@property (nonatomic, retain) IBOutlet UIView *satelliteCountInnerContainerView;
@property (nonatomic, retain) IBOutlet UIView *backToPlanetInnerContainerView;
@property (nonatomic, retain) IBOutlet UIImageView *moon;
@property (nonatomic, retain) UIScrollView *mainScrollingObjectView;
@property (nonatomic, retain) IBOutlet UIScrollView *scrollingObjectView;
@property (nonatomic, retain) IBOutlet UILabel *objectNameLabel;
@property (nonatomic, retain) IBOutlet UILabel *objectTypeLabel;
@property (nonatomic, retain) IBOutlet UIPageControl *pageControl;
@property (nonatomic, retain) NSMutableArray *scrollingViewControllers;
@property (nonatomic, retain) NSMutableArray *mainPlanetaryImageList;
@property (nonatomic, retain) IBOutlet UIView *objectTitleFrame_1;
@property (nonatomic, retain) IBOutlet UIView *objectTitleFrame_2;
@property (nonatomic, retain) IBOutlet UIView *objectTitleFrame_3;
@property (nonatomic, retain) NSString* activeObjectName;
@property (nonatomic, retain) PlanetaryObjectDB *objectDB;
@property (nonatomic, retain) IBOutlet UIView *satelliteCountLabelView;
@property (nonatomic, retain) IBOutlet UILabel *satelliteCountLabel;
@property (nonatomic, retain) IBOutlet UIView *moreSatellitesButtonView;
@property (nonatomic, retain) IBOutlet UILabel *moreSatellitesButtonLabel;
@property (nonatomic, retain) UIScrollView *scrollingSatellites;
@property (nonatomic, retain) NSArray *imageLabels;
@property (nonatomic, retain) NSArray *imageFilenames;
@property (nonatomic, retain) NSMutableArray *imageViews;
@property (nonatomic, retain) NSNumber *numberOfPlanetaryObjects;
@property (nonatomic, retain) IBOutlet UIButton* homeButton;
@property (nonatomic, retain) IBOutlet UIButton* infoButton;
@property (nonatomic, retain) IBOutlet UIView *backToPlanetButtonView;
@property (nonatomic, retain) IBOutlet UILabel *backToPlanetLabel;
@property (nonatomic, retain) IBOutlet UIImageView *backgroundTopPanel;
@property (nonatomic, retain) IBOutlet UIImageView *infoTab;

-(NSString*)teaserForActiveObject;
-(IBAction)home:(id)sender;
-(IBAction)showPlanetaryInfo:(id)sender;
-(void)closeInfoView;
-(NSArray*)arrayOfFactoidsForActiveObject;
-(void)moveScrollToLeft;
-(void)moveScrollToRight;
-(void)showInfoViaImageDoubleTap;
-(void)displaySatellitesForObjectAtIndex:(NSUInteger)index;
-(void)addSatellitesIndicatorForObjectAtIndex:(NSInteger)index;
-(void)hideSatellites;
-(void)hideSatellitesCount;
-(void)showSatelliteAtSubIndex:(NSInteger)subIndex;
-(void)showCometAtSubIndex:(NSInteger)subIndex;
-(void)loadObjectDB;
-(void)setFrameToInitialPosition;
-(void)setFrameToImageAtIndex:(NSInteger)index;
-(void)showBackToPlanetButtonForPlanetAtIndex: (NSInteger)index;
-(void)backToPlanet;
-(void)restoreSatellites;
-(void)remoteCall_closeInfo;
-(void)loadBottomScrollView;
-(void)showComet:(UITapGestureRecognizer*)gesture;

@end
