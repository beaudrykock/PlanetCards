//
//  PlanetaryObjectDB.m
//  PlanetCards
//
//  Created by Beaudry Kock on 11/14/11.
//  Copyright (c) 2011 Better World Coding. All rights reserved.
//

#import "PlanetaryObjectDB.h"


@implementation PlanetaryObjectDB

@synthesize  planetaryObjects;

-(void)dealloc
{
    [super dealloc];
    
    [planetaryObjects release];
}

-(void)loadContent
{
    planetaryObjects = [[NSMutableArray alloc] initWithCapacity:30];
    
    NSString *objectXML = [[NSBundle mainBundle] pathForResource:@"PlanetCardsData" ofType:@"xml"];
	NSData *data = [NSData dataWithContentsOfFile:objectXML];
    
    // create a new SMXMLDocument with the contents of sample.xml
	SMXMLDocument *document = [SMXMLDocument documentWithData:data error:NULL];
    
	// demonstrate -description of document/element classes
	//NSLog(@"Document:\n %@", document);
    
    // Pull out the <rdf> node
	SMXMLElement *root = document.root;
    
    for (SMXMLElement *factItem in [root childrenNamed:kFactItem])
    {
        [self generatePlanetaryObjectFromElement: factItem];
    }
    
    [self addAllCometsToHaleBoppSatellites];
    [self addAllAsteroidsToCeresSatellites];
    
    //[self reportContents];
    
}

-(void)addAllCometsToHaleBoppSatellites
{
    PlanetaryObject *haleBopp = [self planetaryObjectForName:kHaleBopp];
    
    for (PlanetaryObject *obj in planetaryObjects)
    {
        if (![[obj name] isEqualToString: kHaleBopp] && [[obj type] isEqualToString:kCometType])
        {
            [[haleBopp satellites] addObject:obj];
        }
    }
    
    NSInteger hbIndex = [self indexForPlanetaryObjectWithName: [haleBopp name]];
    
    [planetaryObjects replaceObjectAtIndex:hbIndex withObject:haleBopp];
    
}

-(void)addAllAsteroidsToCeresSatellites
{
    PlanetaryObject *ceres = [self planetaryObjectForName:kCeres];
    
    for (PlanetaryObject *obj in planetaryObjects)
    {
        if (![[obj name] isEqualToString: kCeres] && [[obj type] isEqualToString:kAsteroidType])
        {
            [[ceres satellites] addObject:obj];
        }
    }
    
    NSInteger cIndex = [self indexForPlanetaryObjectWithName: [ceres name]];
    
    [planetaryObjects replaceObjectAtIndex:cIndex withObject:ceres];
    
}

-(NSInteger)indexForPlanetaryObjectWithName: (NSString*)planetaryObjectName
{
    BOOL found = NO;
    NSInteger index = 0;
    while (!found && index < [planetaryObjects count])
    {
        if ([[[planetaryObjects objectAtIndex:index] name] isEqualToString:planetaryObjectName])
        {
            found = YES;
        }
        else
        {
            index++;
        }
    }
    return index;
}

-(PlanetaryObject*)planetaryObjectForName:(NSString*)planetaryObjectName
{
    PlanetaryObject *planet = nil;
    BOOL found = NO;
    int index = 0;
    while (!found && index < [planetaryObjects count])
    {
        if ([[[planetaryObjects objectAtIndex:index] name] isEqualToString:planetaryObjectName])
        {
            found = YES;
            planet = [planetaryObjects objectAtIndex:index]; 
        }
        else
        {
            index++;
        }
    }
    
    return planet;
}

-(NSNumber*)getFloatAsNumberFromElement:(SMXMLElement*)factoid
{
    NSString *value = [factoid value];
    NSString *noWS = [value stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
    return [NSNumber numberWithFloat:[noWS floatValue]];
}

-(NSString*)stringStrippedOfWhitespaceAndNewlines:(NSString*)oldString
{
    return [oldString stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
}

//TODO: implement NSCoding and NSCopying protocols


-(NSString*)objectNameForIndex:(int)index
{
    return [[planetaryObjects objectAtIndex:index] name];
}

-(NSString*)objectTypeForIndex:(int)index
{
    return [[planetaryObjects objectAtIndex:index] type];
}

-(NSString*)mainImageFilenameForIndex:(int)index
{
    NSString *fullFilename = [[planetaryObjects objectAtIndex:index] mainImage];
    NSString *filenameWithoutType = [fullFilename stringByReplacingOccurrencesOfString:@".png" withString:@""];
    
    return filenameWithoutType;
}

-(NSString*)tabImageFilenameForIndex:(int)index
{
    NSString *fullFilename = [[planetaryObjects objectAtIndex:index] tabImage];
    NSString *filenameWithoutType = [fullFilename stringByReplacingOccurrencesOfString:@".png" withString:@""];
    
    return filenameWithoutType;
}

-(NSArray*)arrayOfObjectNames
{
    NSMutableArray *array = [NSMutableArray arrayWithCapacity:20];
    
    for (PlanetaryObject *planetaryObject in planetaryObjects)
    {
        if ([planetaryObject type] != kCometType && [planetaryObject type] != kAsteroidType)
        {
            [array addObject:[planetaryObject name]];
        }
        else
        {
            if ([planetaryObject name] == kHaleBopp)
            {
                [array addObject:[planetaryObject name]];
            }
            else if ([planetaryObject name] == kCeres)
            {
                [array addObject:[planetaryObject name]];
            }
        }
    }
    
    NSArray *final = [NSArray arrayWithArray:array];
    
    return final;
}

-(NSNumber*)numberOfPlanetaryObjects
{
    return [NSNumber numberWithInt:[planetaryObjects count]-(kNumberOfCometsLessHaleBopp)];
}

// does not return comets after Hale Bopp, or asteroids
-(NSArray*)arrayOfObjectTabImageFilenames
{
    NSMutableArray *array = [NSMutableArray arrayWithCapacity:20];
    
    for (PlanetaryObject *planetaryObject in planetaryObjects)
    {
        if ([planetaryObject type] != kCometType && [planetaryObject type] != kAsteroidType)
        {
            [array addObject: [[planetaryObject tabImage] stringByReplacingOccurrencesOfString:@".png" withString:@""]];
        }
        else
        {
            if ([planetaryObject name] == kHaleBopp)
            {
                [array addObject: [[planetaryObject tabImage] stringByReplacingOccurrencesOfString:@".png" withString:@""]];
            }
            else if ([planetaryObject name] == kCeres)
            {
                [array addObject: [[planetaryObject tabImage] stringByReplacingOccurrencesOfString:@".png" withString:@""]];
            }
        }
    }
    
    NSArray *final = [NSArray arrayWithArray:array];
    
    return final;
}

-(NSArray*)arrayofActiveObjectsForPageNumber:(NSUInteger)pageNumber
{
    int lowerBound = pageNumber*5;
    int upperBound = lowerBound+4;
    NSMutableArray *array = [NSMutableArray arrayWithCapacity:10];
    for (int i = lowerBound; i<=upperBound; i++)
    {
        [array addObject:[[planetaryObjects objectAtIndex:i] name]]; 
    }
    return [NSArray arrayWithArray: array];
}

-(BOOL)objectWithSatellitesAtIndex:(NSUInteger)index
{
    PlanetaryObject *po = [planetaryObjects objectAtIndex:index];
    
    if ([[po name] isEqualToString:kHaleBopp])
    {
        return YES;
    }
    else
    {
        return ([[po satellites] count] > 0);
    }
}

-(NSInteger)numberOfSatellitesForObjectAtIndex: (NSInteger)index
{
    NSInteger count = 0;
    
    if ([[[planetaryObjects objectAtIndex:index] name] isEqualToString:kHaleBopp])
    {
        count = 4;
    }
    else
    {
        count = [[[planetaryObjects objectAtIndex:index] satellites] count];
    }
    
    return count;
}

-(NSArray*)arrayOfSatellitesForObjectAtIndex:(NSUInteger)index
{
    if ([[[planetaryObjects objectAtIndex:index] name] isEqualToString:kHaleBopp])
    {
        return [self arrayOfComets];
    }
    else
    {
        return [[planetaryObjects objectAtIndex:index] satellites];
    }
}

-(NSArray*)arrayOfComets
{
    NSMutableArray *comets = [[NSMutableArray alloc] initWithCapacity:3];
    
    for (PlanetaryObject *obj in planetaryObjects)
    {
        if ([[obj name] isEqualToString:kHalley] ||
            [[obj name] isEqualToString:kShoemakerLevy] ||
            [[obj name] isEqualToString:kTemple] ||
            [[obj name] isEqualToString:kHaleBopp])
        {
            [comets addObject:obj];
        }
    }
    
    return [NSArray arrayWithArray:comets];
    
}

-(BOOL)objectAtIndexIsSatellite:(NSInteger)index
{
    PlanetaryObject *obj = [planetaryObjects objectAtIndex:index];
    
    return [[obj type] isEqualToString:kCometType];
}

// TODO: add an indexing approach so max number of times this would have to be called is limited to the number
// of objects in the database
-(NSUInteger)indexForObjectNamed:(NSString*)objectName
{
    BOOL found = NO;
    int counter = 0;
    int index = 0;
    while (!found && counter < [planetaryObjects count])
    {
        if ([[[planetaryObjects objectAtIndex:counter]name] isEqualToString:objectName])
        {
            found = YES;
            index = counter;
        }
        else
        {
            counter++;
        }
    }
    if (!found) index = -1;
    
    return index;
}

-(NSArray*)factoidsForObjectNamed:(NSString*)objectName
{
    
    PlanetaryObject *foundObj = nil;
    if ([self indexForObjectNamed:objectName] == -1)
    {
        
        // iterate through satellites
        BOOL found = NO;
        int index = 0;
        while (!found && index < [planetaryObjects count])
        {
            PlanetaryObject *testObj = [planetaryObjects objectAtIndex:index];
            
            if ([[testObj satellites] count] > 0)
            {
                
                for (PlanetaryObject *sat in [testObj satellites])
                {
                    if ([[sat name] isEqualToString:objectName])
                    {
                        found = YES;
                        foundObj = sat;
                    }
                }
                
                if (!found) index++;
                
            }
            else
            {
                index++;
            }
        }
    }
    else
    {
        foundObj = [planetaryObjects objectAtIndex:[self indexForObjectNamed:objectName]];
    }
    
    return [foundObj arrayOfFactoids];
}

-(NSString*)teaserForObjectNamed:(NSString*)objectName
{
    PlanetaryObject *foundObj = nil;
    if ([self indexForObjectNamed:objectName] == -1)
    {
        
        // iterate through satellites
        BOOL found = NO;
        int index = 0;
        while (!found && index < [planetaryObjects count])
        {
            PlanetaryObject *testObj = [planetaryObjects objectAtIndex:index];
            
            if ([[testObj satellites] count] > 0)
            {
                
                for (PlanetaryObject *sat in [testObj satellites])
                {
                    if ([[sat name] isEqualToString:objectName])
                    {
                        found = YES;
                        foundObj = sat;
                    }
                }
                
                if (!found) index++;
                
            }
            else
            {
                index++;
            }
        }
    }
    else
    {
        foundObj = [planetaryObjects objectAtIndex:[self indexForObjectNamed:objectName]];
    }

    
    return [foundObj teaser];
}

#pragma mark -
#pragma mark XML data file parsing using TBXML
/*
 * Generates a parameterized PlanetaryObject on the basis of a SMXMLElement
 * 
 */
-(void)generatePlanetaryObjectFromElement:(SMXMLElement*)factItem {
    
    PlanetaryObject *newPlanetaryObject = [[PlanetaryObject alloc] init];
    
    [newPlanetaryObject setName:[self stringStrippedOfWhitespaceAndNewlines:[factItem valueWithPath:kName]]];
    [newPlanetaryObject setTeaser: [self stringStrippedOfWhitespaceAndNewlines:[factItem valueWithPath:kTeaser]]];
    [newPlanetaryObject setType: [self stringStrippedOfWhitespaceAndNewlines:[factItem valueWithPath:kType]]];
    [newPlanetaryObject setMainImage: [self stringStrippedOfWhitespaceAndNewlines:[factItem valueWithPath:kImage]]];
    [newPlanetaryObject setTabImage: [self stringStrippedOfWhitespaceAndNewlines:[factItem valueWithPath:kTabImage]]];
    
    SMXMLElement *factoids = [factItem childNamed:kFactoids];
    
    [newPlanetaryObject setMass: [self getFloatAsNumberFromElement: [factoids childNamed:kMass]]];
    [newPlanetaryObject setDiameter: [self getFloatAsNumberFromElement: [factoids childNamed:kDiameter]]];
    [newPlanetaryObject setDensity: [self getFloatAsNumberFromElement: [factoids childNamed:kDensity]]];
    [newPlanetaryObject setSpeed: [self getFloatAsNumberFromElement: [factoids childNamed:kSpeed]]];
    [newPlanetaryObject setDayLength: [self getFloatAsNumberFromElement: [factoids childNamed:kDayLength]]];
    [newPlanetaryObject setTemperature: [self getFloatAsNumberFromElement: [factoids childNamed:kTemperature]]];
    [newPlanetaryObject setSunDistance: [self getFloatAsNumberFromElement: [factoids childNamed:kSunDistance]]];
    
    SMXMLElement *satellites = [factItem childNamed:kSatellites];
    
    if (satellites.name)
    {
        newPlanetaryObject.satellites = [NSMutableArray arrayWithCapacity:5];
        NSArray *satelliteElements = [satellites childrenNamed:kSatellite];
        
        for (SMXMLElement *satObj in satelliteElements)
        {
            PlanetaryObject *sat = [[PlanetaryObject alloc] init];
            
            [sat setName:[self stringStrippedOfWhitespaceAndNewlines:[satObj valueWithPath:kName]]];
            [sat setTeaser: [self stringStrippedOfWhitespaceAndNewlines:[satObj valueWithPath:kTeaser]]];
            [sat setType: [self stringStrippedOfWhitespaceAndNewlines:[satObj valueWithPath:kType]]];
            [sat setMainImage: [self stringStrippedOfWhitespaceAndNewlines:[satObj valueWithPath:kSatelliteImage]]];
            [sat setTabImage: [self stringStrippedOfWhitespaceAndNewlines:[satObj valueWithPath:kSatelliteTabImage]]];
            
            SMXMLElement *satFactoids = [satObj childNamed:kFactoids];
            [sat setMass:[self getFloatAsNumberFromElement: [satFactoids childNamed:kMass]]];
            [sat setDiameter:[self getFloatAsNumberFromElement: [satFactoids childNamed:kDiameter]]];
            [sat setDensity:[self getFloatAsNumberFromElement: [satFactoids childNamed:kDensity]]];
            [sat setSpeed:[self getFloatAsNumberFromElement: [satFactoids childNamed:kSpeed]]];
            [sat setDayLength:[self getFloatAsNumberFromElement: [satFactoids childNamed:kDayLength]]];
            [sat setTemperature:[self getFloatAsNumberFromElement: [satFactoids childNamed:kTemperature]]];
            [sat setSunDistance:[self getFloatAsNumberFromElement: [satFactoids childNamed:kSunDistance]]];
            
            [newPlanetaryObject.satellites addObject:sat];
            [sat release];
        }
    }
    
    [planetaryObjects addObject:newPlanetaryObject];
    
    [newPlanetaryObject release];
}

// DEBUGGING
-(void)reportContents
{
    NSLog(@"Number of PlanetaryObjects: %i",[planetaryObjects count]);
    NSLog(@"PlanetaryObject print...\n");
    for (PlanetaryObject *object in planetaryObjects)
    {
        [object print];
    }
}

@end
