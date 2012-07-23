//
//  PlanetaryInfoViewController.m
//  PlanetCards
//
//  Created by Beaudry Kock on 26/07/2011.
//  Copyright 2011 Better World Coding. All rights reserved.
//

#import "PlanetaryInfoViewController.h"

@implementation PlanetaryInfoViewController
@synthesize infoUnits, infoValues, infoCategories, parentController, objectName, objectTeaser;
@synthesize massValue, densityValue, speedValue, dayLengthValue, sunDistanceValue, temperatureValue, diameterValue, teaser;
@synthesize massUnits, diameterUnits, densityUnits, speedUnits, dayLengthUnits, temperatureUnits, sunDistanceUnits;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)dealloc
{
    [super dealloc];
    [infoUnits release];
    [infoValues release];
    [infoCategories release];
    [parentController release];
    [objectName release];
    [objectTeaser release];
    [massValue release];
    [dayLengthUnits release];
    [dayLengthValue release];
    [speedValue release];
    [speedUnits release];
    [densityUnits release];
    [densityValue release];
    [diameterUnits release];
    [diameterValue release];
    [temperatureUnits release];
    [temperatureValue release];
    [sunDistanceUnits release];
    [sunDistanceValue release];
    [teaser release];
    [massUnits release];
}

- (void)didReceiveMemoryWarning
{
    // Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
    
    // Release any cached data, images, etc that aren't in use.
}

#pragma mark - View lifecycle

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
    [teaser setBackgroundColor:[UIColor clearColor]];
    [teaser setTextColor:[UIColor whiteColor]];
    [teaser setText: objectTeaser];
    [self.teaser setUserInteractionEnabled:NO];
    for (int i = 0; i<6; i++)
    {
        NSLog(@"%@",[[self infoValues] objectAtIndex:i]);
    }
    
    NSString*pref = [Utilities getUnitPreference]; 
    if ([pref isEqualToString: kConvenientUnits])
    {
        massValue.text = [self ConvenientParser:[infoValues objectAtIndex:0] forType:kMass];
        diameterValue.text = [self ConvenientParser: [infoValues objectAtIndex:1] forType: kDiameter];
        densityValue.text = [self ConvenientParser: [infoValues objectAtIndex:2] forType: kDensity];
        speedValue.text = [self ConvenientParser: [infoValues objectAtIndex:3] forType: kSpeed];
        dayLengthValue.text = [self ConvenientParser: [infoValues objectAtIndex:4] forType: kDayLength];
        temperatureValue.text = [self ConvenientParser: [infoValues objectAtIndex:5] forType: kTemperature];
        sunDistanceValue.text = [self ConvenientParser: [infoValues objectAtIndex:6] forType: kSunDistance];
    }
    else if ([pref isEqualToString: kSIUnits])
    {
        massValue.text = [self SIParser:[infoValues objectAtIndex:0] forType:kMass];
        diameterValue.text = [self SIParser: [infoValues objectAtIndex:1] forType: kDiameter];
        densityValue.text = [self SIParser: [infoValues objectAtIndex:2] forType: kDensity];
        speedValue.text = [self SIParser: [infoValues objectAtIndex:3] forType: kSpeed];
        dayLengthValue.text = [self SIParser: [infoValues objectAtIndex:4] forType: kDayLength];
        temperatureValue.text = [self SIParser: [infoValues objectAtIndex:5] forType: kTemperature];
        sunDistanceValue.text = [self SIParser: [infoValues objectAtIndex:6] forType: kSunDistance];
    }
    else
    {
        massValue.text = [infoValues objectAtIndex:0];
        diameterValue.text = [infoValues objectAtIndex:1];
        densityValue.text = [infoValues objectAtIndex:2];
        speedValue.text = [infoValues objectAtIndex:3];
        dayLengthValue.text = [infoValues objectAtIndex:4];
        temperatureValue.text = [infoValues objectAtIndex:5];
        sunDistanceValue.text = [infoValues objectAtIndex:6];
    }
    [self setUnits];
    
    [[self.view layer] setCornerRadius:5.0f];
    
}

-(NSString*)SIParser:(NSString*)metric forType:(NSString*)type
{
   // NSLog(@"metric = %@",metric);
    NSNumber *originalVal = nil;
    NSNumber *newVal = nil;
    float ovf = 0.0f;
    NSNumberFormatter * f = [[NSNumberFormatter alloc] init];
    [f setNumberStyle:NSNumberFormatterDecimalStyle];
    [f setUsesSignificantDigits:YES];
    [f setMaximumSignificantDigits:3];
    //[f setRoundingMode:NSNumberFormatterRoundUp];
    
    NSNumberFormatter * f2 = [[NSNumberFormatter alloc] init];
    [f2 setNumberStyle:NSNumberFormatterScientificStyle];
    [f2 setMaximumFractionDigits:3];
    
    NSNumber * massConvNbr = [f numberFromString:kEarthToSIMassConversionFactor];
    NSNumber * diameterConvNbr = [f numberFromString:kEarthToSIDiameterConversionFactor];
    
    NSString *final = nil;
    
    originalVal = [f numberFromString:metric];
    ovf = [originalVal floatValue];
    
    if ([type isEqualToString:kMass])
    {
        ovf *= [massConvNbr floatValue];
    }
    else if ([type isEqualToString:kDiameter])
    {
        ovf *= [diameterConvNbr floatValue];        
    }
    else if ([type isEqualToString:kDensity])
    {
        ovf *= kEarthToSIDensityConversionFactor;
    }
    else if ([type isEqualToString:kSpeed])
    {
        ovf *= kEarthToSISpeedConversionFactor;
    }
    else if ([type isEqualToString:kDayLength])
    {
        ovf *= kEarthToSIDayLengthConversionFactor;
    }
    else if ([type isEqualToString:kTemperature])
    {
        ovf += kEarthToSITemperatureConversionFactor;
    }
    else if ([type isEqualToString:kSunDistance])
    {
        ovf *= kEarthToSISunDistanceConversionFactor;
    }
   
    newVal = [NSNumber numberWithFloat:ovf];
    
    final = [f stringFromNumber:newVal];
    
    // if final is longer than 9 characters, then re-process with scientific notation
    
    if ([final length]>9)
    {
        final = [f2 stringFromNumber:newVal];
        
        // decompose to superscript
        NSScanner *superscanner = [NSScanner scannerWithString:final];
        NSString *temp_1 = nil;
        [superscanner scanUpToString:@"E" intoString:&temp_1];
        NSString *temp_2 = nil;
        [superscanner setScanLocation:[superscanner scanLocation]+1];
        [superscanner scanUpToString:@"E" intoString:&temp_2];
        
        NSString *superscript = [self superScriptOf:temp_2];
        
        // recombine
        final = [NSString stringWithFormat:@"%@%@",temp_1,superscript];
    }
    
    [f release];
    [f2 release];
    
    return final;
}

-(NSString*)ConvenientParser:(NSString*)earth forType:(NSString*)type
{
    NSLog(@"earth = %@",earth);
    NSNumber *originalVal = nil;
    NSNumber *newVal = nil;
    float ovf = 0.0f;
    NSNumberFormatter * f = [[NSNumberFormatter alloc] init];
    [f setNumberStyle:NSNumberFormatterDecimalStyle];
    [f setUsesSignificantDigits:YES];
    [f setMaximumSignificantDigits:3];
    //[f setRoundingMode:NSNumberFormatterRoundUp];
    
    NSNumberFormatter * f2 = [[NSNumberFormatter alloc] init];
    [f2 setNumberStyle:NSNumberFormatterScientificStyle];
    [f2 setMaximumFractionDigits:3];
    
    NSString *final = nil;
    
    originalVal = [f numberFromString:earth];
    ovf = [originalVal floatValue];
    
    if ([type isEqualToString:kMass])
    {
        ovf *= kEarthToConvenientMassConversionFactor;
    }
    else if ([type isEqualToString:kDiameter])
    {
        ovf *= kEarthToConvenientDiameterConversionFactor;        
    }
    else if ([type isEqualToString:kDensity])
    {
        ovf *= kEarthToConvenientDensityConversionFactor;
    }
    else if ([type isEqualToString:kSpeed])
    {
        ovf *= kEarthToConvenientSpeedConversionFactor;
    }
    else if ([type isEqualToString:kDayLength])
    {
        ovf *= kEarthToConvenientDayLengthConversionFactor;
    }
    else if ([type isEqualToString:kTemperature])
    {
        ovf += kEarthToConvenientTemperatureConversionFactor;
    }
    else if ([type isEqualToString:kSunDistance])
    {
        ovf *= kEarthToConvenientSunDistanceConversionFactor;
    }
    
    newVal = [NSNumber numberWithFloat:ovf];
    
    
    final = [f stringFromNumber:newVal];
    
    // if final is longer than 9 characters, then re-process with scientific notation
    
    if ([final length]>9)
    {
        final = [f2 stringFromNumber:newVal];
        
        // decompose to superscript
        NSScanner *superscanner = [NSScanner scannerWithString:final];
        NSString *temp_1 = nil;
        [superscanner scanUpToString:@"E" intoString:&temp_1];
        NSString *temp_2 = nil;
        [superscanner setScanLocation:[superscanner scanLocation]+1];
        [superscanner scanUpToString:@"E" intoString:&temp_2];
        
        NSString *superscript = [self superScriptOf:temp_2];
        
        // recombine
        final = [NSString stringWithFormat:@"%@%@",temp_1,superscript];
    }
    
    [f release];
    [f2 release];
    
    return final;
}


-(NSString *)superScriptOf:(NSString *)inputNumber
{
    
    NSString *outp=@"";
    for (int i =0; i<[inputNumber length]; i++) {
        unichar chara=[inputNumber characterAtIndex:i] ;
        switch (chara) {
            case '1':
                NSLog(@"1");
                outp=[outp stringByAppendingFormat:@"\u00B9"];
                break;
            case '2':
                NSLog(@"2");
                outp=[outp stringByAppendingFormat:@"\u00B2"];
                break;
            case '3':
                NSLog(@"3");
                outp=[outp stringByAppendingFormat:@"\u00B3"];
                break;
            case '4':
                NSLog(@"4");
                outp=[outp stringByAppendingFormat:@"\u2074"];
                break;
            case '5':
                NSLog(@"5");
                outp=[outp stringByAppendingFormat:@"\u2075"];
                break;
            case '6':
                NSLog(@"6");
                outp=[outp stringByAppendingFormat:@"\u2076"];
                break;
            case '7':
                NSLog(@"7");
                outp=[outp stringByAppendingFormat:@"\u2077"];
                break;
            case '8':
                NSLog(@"8");
                outp=[outp stringByAppendingFormat:@"\u2078"];
                break;
            case '9':
                NSLog(@"9");
                outp=[outp stringByAppendingFormat:@"\u2079"];
                break;
            case '0':
                NSLog(@"0");
                outp=[outp stringByAppendingFormat:@"\u2070"];
                break;
            default:
                break;
        }
    }
    return outp;   
}

-(void)setUnits
{
    NSString *pref = [Utilities getUnitPreference]; 
    if ([pref isEqualToString: kSIUnits])
    {
        [massUnits setText:kSIUnit_mass];
        [densityUnits setText:[NSString stringWithFormat:@"%@%@",kSIUnit_density,[self superScriptOf:@"3"]]];
        [diameterUnits setText:kSIUnit_diameter];
        [speedUnits setText:kSIUnit_speed];
        [dayLengthUnits setText:kSIUnit_dayLength];
        [temperatureUnits setText:kSIUnit_temperature];
        [sunDistanceUnits setText:kSIUnit_sunDistance];
    }
    else if ([pref isEqualToString: kConvenientUnits])
    {
        [massUnits setText:kConvenientUnit_mass];
        [densityUnits setText:[NSString stringWithFormat:@"%@%@",kConvenientUnit_density,[self superScriptOf:@"3"]]];
        [diameterUnits setText:kConvenientUnit_diameter];
        [speedUnits setText:kConvenientUnit_speed];
        [dayLengthUnits setText:kConvenientUnit_dayLength];
        [temperatureUnits setText:kConvenientUnit_temperature];
        [sunDistanceUnits setText:kConvenientUnit_sunDistance];
    }
    else 
    {
        [massUnits setText:[NSString stringWithFormat:@"%@%@",@"\u02E3",kEarthUnit_mass]];
        [densityUnits setText:[NSString stringWithFormat:@"%@%@",@"\u02E3",kEarthUnit_density]];
        [diameterUnits setText:[NSString stringWithFormat:@"%@%@",@"\u02E3",kEarthUnit_diameter]];
        [speedUnits setText:[NSString stringWithFormat:@"%@%@",@"\u02E3",kEarthUnit_speed]];
        [dayLengthUnits setText:[NSString stringWithFormat:@"%@%@",@"\u02E3",kEarthUnit_dayLength]];
        [temperatureUnits setText:kEarthUnit_temperature];
        [sunDistanceUnits setText:[NSString stringWithFormat:@"%@%@",@"\u02E3",kEarthUnit_sunDistance]];
    }
}

- (void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event {
    for (UITouch *touch in touches) {
        if (touch.tapCount == 1) {
            [parentController remoteCall_closeInfo];
 //           [self.view removeFromSuperview];
        }
    }
}

-(void)viewWillAppear:(BOOL)animated {
	[super viewWillAppear:animated];
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
