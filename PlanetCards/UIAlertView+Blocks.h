//
//  UIAlertView+Blocks.h
//  PlanetCards
//
//  Created by Beaudry Kock on 8/8/12.
//
//

#import <UIKit/UIKit.h>

@interface UIAlertView (Blocks)
    
    typedef void (^DismissBlock)(int buttonIndex);
    typedef void (^CancelBlock)();

+(UIAlertView*) showAlertViewWithTitle:(NSString*) title
                message: (NSString*)message
                cancelButtonTitle: (NSString*)cancelButtonTitle
                otherButtonTitles: (NSArray*)otherButtons
                onDismiss:(DismissBlock)dismissed
                              onCancel:(CancelBlock)cancelled;
@end
