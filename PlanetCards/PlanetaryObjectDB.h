//
//  PlanetaryObjectDB.h
//  PlanetCards
//
//  Created by Beaudry Kock on 11/14/11.
//  Copyright (c) 2011 Better World Coding. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "PlanetaryObject.h"
#import "SMXMLDocument.h"

@interface PlanetaryObjectDB : NSObject
{
    NSMutableArray *planetaryObjects;
}

@property (nonatomic, retain) NSMutableArray *planetaryObjects;


#pragma mark -
#pragma mark XML Parsing
-(void)loadContent;
-(void)generatePlanetaryObjectFromElement:(SMXMLElement*)factItem;
-(void)reportContents;

-(NSString*)objectNameForIndex:(int)index;
-(NSString*)objectTypeForIndex:(int)index;
-(NSArray*)factoidsForObjectNamed:(NSString*)objectName;
-(NSString*)teaserForObjectNamed:(NSString*)objectName;
-(NSString*)mainImageFilenameForIndex:(int)index;
-(NSString*)tabImageFilenameForIndex:(int)index;
-(NSArray*)arrayOfObjectNames;
-(NSArray*)arrayOfObjectTabImageFilenames;
-(NSNumber*)numberOfPlanetaryObjects;
-(NSArray*)arrayofActiveObjectsForPageNumber:(NSUInteger)pageNumber;
-(BOOL)objectWithSatellitesAtIndex:(NSUInteger)index;
-(NSArray*)arrayOfSatellitesForObjectAtIndex:(NSUInteger)index;
-(NSInteger)numberOfSatellitesForObjectAtIndex:(NSInteger)index;
-(void)addAllCometsToHaleBoppSatellites;
-(void)addAllAsteroidsToCeresSatellites;
-(PlanetaryObject*)planetaryObjectForName:(NSString*)planetaryObjectName;
-(NSInteger)indexForPlanetaryObjectWithName: (NSString*)planetaryObjectName;
-(NSArray*)arrayOfComets;
-(BOOL)objectAtIndexIsSatellite:(NSInteger)index;

@end
