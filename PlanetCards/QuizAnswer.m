//
//  QuizAnswer.m
//  PlanetCards
//
//  Created by Beaudry Kock on 2/18/12.
//  Copyright (c) 2012 Better World Coding. All rights reserved.
//

#import "QuizAnswer.h"

@implementation QuizAnswer

@synthesize isRight, answer;

-(void)dealloc
{
    [super dealloc];
    
    [isRight release];
    [answer release];
}


@end
