//
//  PlanetaryObject.m
//  PlanetCards
//
//  Created by Beaudry Kock on 11/14/11.
//  Copyright (c) 2011 Better World Coding. All rights reserved.
//

#import "PlanetaryObject.h"


@implementation PlanetaryObject

@synthesize name, type, teaser;
@synthesize mass, diameter, density, speed, dayLength, temperature, sunDistance, satellites, tabImage, mainImage;

-(void)dealloc
{
    [name release];
    [type release];
    [teaser release];
    [mass release];
    [diameter release];
    [density release];
    [speed release];
    [dayLength release];
    [temperature release];
    [sunDistance release];
    [satellites release];
    [tabImage release];
    [mainImage release];

    [super dealloc];
}

-(NSArray*)arrayOfFactoids
{
    return [NSArray arrayWithObjects:[mass stringValue], [diameter stringValue], [density stringValue], [speed stringValue], [dayLength stringValue], [temperature stringValue], [sunDistance stringValue], nil];
}

-(NSString*)mainImageFilenameWithoutType
{
    NSString *cleanFilename = [mainImage stringByReplacingOccurrencesOfString: @".png" withString: @""];
    
    return cleanFilename;
}

-(NSString*)tabImageFilenameWithoutType
{
    NSString *cleanFilename = [tabImage stringByReplacingOccurrencesOfString: @".png" withString: @""];
    
    return cleanFilename;
}

-(id)copyWithZone:(NSZone *)zone {
	PlanetaryObject *copy = [[[self class] allocWithZone: zone] init];
	[copy setName: [[[self name] copyWithZone: zone] autorelease]];
	[copy setType: [[[self type] copyWithZone: zone] autorelease]];
	[copy setTeaser: [[[self teaser] copyWithZone: zone] autorelease] ];
	[copy setMass: [[[self mass] copyWithZone: zone] autorelease] ];
	[copy setDiameter: [[[self diameter] copyWithZone: zone] autorelease] ];
	[copy setDensity: [[[self density] copyWithZone: zone] autorelease] ];
	[copy setSpeed: [[[self speed] copyWithZone: zone] autorelease] ];
    [copy setDayLength: [[[self dayLength] copyWithZone: zone] autorelease] ];
    [copy setTemperature: [[[self temperature] copyWithZone: zone] autorelease] ];
	[copy setSunDistance: [[[self sunDistance] copyWithZone: zone] autorelease] ];
    [copy setSatellites: [[[self sunDistance] copyWithZone: zone] autorelease] ];
    [copy setTabImage: [[[self sunDistance] copyWithZone: zone] autorelease] ];
    [copy setMainImage: [[[self sunDistance] copyWithZone: zone] autorelease] ];
	return copy;
}

-(void)print
{
    NSLog(@"Printing contents of the %@ object", name);
    NSLog(@"Type = %@", type);
    NSLog(@"Teaser = %@", teaser);
    NSLog(@"Mass = %@", mass);
    NSLog(@"Diameter = %@", diameter);
    NSLog(@"Density = %@", density);
    NSLog(@"Speed = %@", speed);
    NSLog(@"Day Length = %@", dayLength);
    NSLog(@"Temperature = %@", temperature);
    NSLog(@"Sun distance = %@",sunDistance);
    NSLog(@"Tab image = %@",tabImage);
    NSLog(@"Main image = %@",mainImage);
    NSLog(@"Object has %i satellites",[satellites count]);
    for (PlanetaryObject *obj in satellites)
    {
        NSLog(@"Printing contents of the satellite %@", [obj name]);
        NSLog(@"Type = %@", [obj type]);
        NSLog(@"Teaser = %@", [obj teaser]);
        NSLog(@"Mass = %@", [obj mass]);
        NSLog(@"Diameter = %@", [obj diameter]);
        NSLog(@"Density = %@", [obj density]);
        NSLog(@"Speed = %@", [obj speed]);
        NSLog(@"Day Length = %@", [obj dayLength]);
        NSLog(@"Temperature = %@", [obj temperature]);
        NSLog(@"Sun distance = %@",[obj sunDistance]);
        NSLog(@"Tab image = %@", [obj tabImage]);
        NSLog(@"Main image = %@", [obj mainImage]);
    }
}


@end
