//
//  SingleTapScrollView.m
//  PlanetCards
//
//  Created by Beaudry Kock on 1/18/12.
//  Copyright (c) 2012 Better World Coding. All rights reserved.
//

#import "SingleTapScrollView.h"

@implementation SingleTapScrollView

- (id)initWithFrame:(CGRect)frame 
{
    return [super initWithFrame:frame];
}

- (void) touchesEnded: (NSSet *) touches withEvent: (UIEvent *) event 
{   
    // If not dragging, send event to next responder
    if (!self.dragging) 
        [self.nextResponder touchesEnded: touches withEvent:event]; 
    else
        [super touchesEnded: touches withEvent: event];
}
@end