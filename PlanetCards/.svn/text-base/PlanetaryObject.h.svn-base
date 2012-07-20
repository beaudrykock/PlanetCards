//
//  PlanetaryObject.h
//  PlanetCards
//
//  Created by Beaudry Kock on 11/14/11.
//  Copyright (c) 2011 Better World Coding. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
#import "AppConstants.h"

@interface PlanetaryObject : NSObject <NSCopying>
{
    NSString *name;
    NSString *type;
    NSString *teaser;
    NSNumber *mass;
    NSNumber *diameter;
    NSNumber *density;
    NSNumber *speed;
    NSNumber *dayLength;
    NSNumber *temperature;
    NSNumber *sunDistance; 
    NSMutableArray *satellites;
    NSString *tabImage;
    NSString *mainImage;

}

@property (nonatomic, retain) NSString *name;
@property (nonatomic, retain) NSString *type;
@property (nonatomic, retain) NSString *teaser;
@property (nonatomic, retain) NSNumber *mass;
@property (nonatomic, retain) NSNumber *diameter;
@property (nonatomic, retain) NSNumber *density;
@property (nonatomic, retain) NSNumber *speed;
@property (nonatomic, retain) NSNumber *dayLength;
@property (nonatomic, retain) NSNumber *temperature;
@property (nonatomic, retain) NSNumber *sunDistance;
@property (nonatomic, retain) NSMutableArray *satellites;
@property (nonatomic, retain) NSString *tabImage;
@property (nonatomic, retain) NSString *mainImage;

-(void)print;
-(NSArray*)arrayOfFactoids;
-(NSString*)tabImageFilenameWithoutType;
-(NSString*)mainImageFilenameWithoutType;

@end
