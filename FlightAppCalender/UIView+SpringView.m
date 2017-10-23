//
//  UIView+SpringView.m
//  AkbartravelApp
//
//  Created by MAC01 on 12/12/16.
//  Copyright © 2016 Ellkay. All rights reserved.
//

#import "UIView+SpringView.h"

@implementation UIView (SpringView)



+ (void)springEffect:(CGFloat)xPosition forView:(UIView *)view
{
    
    [UIView animateWithDuration:1.0 delay:0 usingSpringWithDamping:0.2 initialSpringVelocity:5.0 options:UIViewAnimationOptionCurveLinear animations:^{
        [view setFrame:CGRectMake(xPosition, view.frame.origin.y,view.frame.size.width, view.frame.size.height)];
    } completion:^(BOOL finished) {
        
    }];
    
}


@end
