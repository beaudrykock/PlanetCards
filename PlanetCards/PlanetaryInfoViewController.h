//
//  PlanetaryInfoViewController.h
//  PlanetCards
//
//  Created by Beaudry Kock on 26/07/2011.
//  Copyright 2011 Better World Coding. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <QuartzCore/QuartzCore.h>
#import "AppConstants.h"
#import "Utilities.h"

@interface PlanetaryInfoViewController : UIViewController
{
    NSMutableArray *infoCategories;
    NSArray *infoValues;
    NSMutableArray *infoUnits;
    NSString *objectName;
    NSString *objectTeaser;
    id parentController;
    
    // outlets
    UILabel *massValue;
    UILabel *dayLengthValue;
    UILabel *speedValue;
    UILabel *densityValue;
    UILabel *diameterValue;
    UILabel *temperatureValue;
    UILabel *sunDistanceValue;
    UITextView *teaser;
    
    UILabel *massUnits;
    UILabel *diameterUnits;
    UILabel *densityUnits;
    UILabel *speedUnits;
    UILabel *dayLengthUnits;
    UILabel *temperatureUnits;
    UILabel *sunDistanceUnits;
}

@property (nonatomic, retain) NSMutableArray *infoCategories;
@property (nonatomic, retain) NSArray *infoValues;
@property (nonatomic, retain) NSMutableArray *infoUnits;
@property (nonatomic, retain) id parentController;
@property (nonatomic, retain) NSString *objectName;
@property (nonatomic, retain) NSString *objectTeaser;
@property (nonatomic, retain) IBOutlet UILabel *massValue;
@property (nonatomic, retain) IBOutlet UILabel *dayLengthValue;
@property (nonatomic, retain) IBOutlet UILabel *speedValue;
@property (nonatomic, retain) IBOutlet UILabel *densityValue;
@property (nonatomic, retain) IBOutlet UILabel *diameterValue;
@property (nonatomic, retain) IBOutlet UILabel *temperatureValue;
@property (nonatomic, retain) IBOutlet UILabel *sunDistanceValue;
@property (nonatomic, retain) IBOutlet UITextView *teaser;
@property (nonatomic, retain) IBOutlet UILabel *massUnits;
@property (nonatomic, retain) IBOutlet UILabel *diameterUnits;
@property (nonatomic, retain) IBOutlet UILabel *densityUnits;
@property (nonatomic, retain) IBOutlet UILabel *speedUnits;
@property (nonatomic, retain) IBOutlet UILabel *dayLengthUnits;
@property (nonatomic, retain) IBOutlet UILabel *temperatureUnits;
@property (nonatomic, retain) IBOutlet UILabel *sunDistanceUnits;

-(NSString*)SIParser:(NSString*)metric forType:(NSString*)type;
-(void)setUnits;
-(NSString *)superScriptOf:(NSString *)inputNumber;

@end
