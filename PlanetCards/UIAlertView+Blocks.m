//
//  UIAlertView+Blocks.m
//  PlanetCards
//
//  Created by Beaudry Kock on 8/8/12.
//
//

#import "UIAlertView+Blocks.h"

@implementation UIAlertView (Blocks)

static DismissBlock _dismissBlock;
static CancelBlock _cancelBlock;

+(UIAlertView*) showAlertViewWithTitle:(NSString*) title
                               message: (NSString*)message
                     cancelButtonTitle: (NSString*)cancelButtonTitle
                     otherButtonTitles: (NSArray*)otherButtons
                             onDismiss:(DismissBlock)dismissed
                              onCancel:(CancelBlock)cancelled
{
    [_cancelBlock release];
    _cancelBlock = [cancelled copy];
    
    [_dismissBlock release];
    _dismissBlock = [dismissed copy];
    
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:title message:message delegate:self cancelButtonTitle:cancelButtonTitle otherButtonTitles: nil];
    
    for (NSString *buttonTitle in otherButtons)
        [alert addButtonWithTitle:buttonTitle];
    
    [alert show];
    return [alert autorelease];
}

+(void)alertView:(UIAlertView*)alertView didDismissButtonWithIndex:(NSInteger)buttonIndex
{
    if (buttonIndex == [alertView cancelButtonIndex])
    {
        _cancelBlock();
    }
    else
    {
        _dismissBlock(buttonIndex-1);
    }
    
    [_cancelBlock autorelease];
    [_dismissBlock autorelease];
}

@end
