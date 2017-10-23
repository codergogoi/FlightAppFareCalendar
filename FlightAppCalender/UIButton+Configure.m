//
//  Configure.m
//  AkbartravelApp
//
//  Created by MAC01 on 07/12/16.
//  Copyright © 2016 Ellkay. All rights reserved.
//

#import "UIButton+Configure.h"

@implementation UIButton (Configure)


#pragma mark - button Tap Effect

-(void)configureButton{
    
    dispatch_async(dispatch_get_main_queue(), ^{
    
        CAKeyframeAnimation *anim = [CAKeyframeAnimation animation];
        anim.keyPath = @"transform.scale";
        anim.values = @[@0.9,@0.8,@1.1,@1.0];
        anim.keyTimes = @[ @0.1, @0.3, @0.6, @0.9, @1.2 ];
        anim.duration = 0.3;
        [self.layer addAnimation:anim forKey:@"scale"];

    });
    
}


-(void)configureMiniButton{
    
    dispatch_async(dispatch_get_main_queue(), ^{
        
        CAKeyframeAnimation *anim = [CAKeyframeAnimation animation];
        anim.keyPath = @"transform.scale";
        anim.values = @[@0.7,@1.5,@0.7,@1.0];
        anim.keyTimes = @[ @0.1, @0.3, @0.6, @0.9, @1.2 ];
        
        
        anim.duration = 0.4;
        [self.layer addAnimation:anim forKey:@"scale"];
    });
    
}


@end
