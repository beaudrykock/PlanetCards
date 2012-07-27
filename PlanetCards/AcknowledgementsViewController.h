//
//  AcknowledgementsViewController.h
//  PlanetCards
//
//  Created by Beaudry Kock on 2/24/12.
//  Copyright (c) 2012 Better World Coding. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "UIUnderlinedButton.h"
#import "AppConstants.h"

@interface AcknowledgementsViewController : UIViewController
{
    UILabel *developedBy;
    UILabel *supportFrom;
    UILabel *viewTitle;
    UIButton *upgradeButton;
}

@property (nonatomic, retain) IBOutlet UIButton *upgradeButton;
@property (nonatomic, retain) IBOutlet UILabel *viewTitle;
@property (nonatomic, retain) IBOutlet UILabel *developedBy;
@property (nonatomic, retain) IBOutlet UILabel *supportFrom;

-(IBAction)hide:(id)sender;
-(IBAction)sendToBWCWithSafari:(id)sender;
-(IBAction)sendToScientificPlaygroundWithSafari:(id)sender;
-(IBAction)sendToMeloniWithSafari:(id)sender;

@end
