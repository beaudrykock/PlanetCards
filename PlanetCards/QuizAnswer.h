//
//  QuizAnswer.h
//  PlanetCards
//
//  Created by Beaudry Kock on 2/18/12.
//  Copyright (c) 2012 Better World Coding. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface QuizAnswer : NSObject
{
    NSString *answer;
    NSNumber *isRight;
}

@property (nonatomic, retain) NSString *answer;
@property (nonatomic, retain) NSNumber *isRight;

@end
