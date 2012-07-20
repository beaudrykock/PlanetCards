//
//  UITextView+DisabledCopyPaste.m
//  PlanetCards
//
//  Created by Beaudry Kock on 2/15/12.
//  Copyright (c) 2012 Better World Coding. All rights reserved.
//

#import "UITextView+DisabledCopyPaste.h"

@implementation UITextView_DisabledCopyPaste
- (BOOL)canBecomeFirstResponder {
    return NO;
}
@end
