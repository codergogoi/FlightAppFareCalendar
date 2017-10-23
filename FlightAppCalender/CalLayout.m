//
//  CalLayout.m
//  AkbarCalendar
//
//  Created by Jayanta Gogoi on 04/08/16.
//  Copyright © 2016 Jayanta Gogoi. All rights reserved.
//

#import "CalLayout.h"

const CGFloat CalFlowLayoutMinInterItemSpacing = 0.0f;
const CGFloat CalFlowLayoutMinLineSpacing = 10.0f;
const CGFloat CalFlowLayoutInsetTop = 20.0f;
const CGFloat CalFlowLayoutInsetLeft = 0.0f;
const CGFloat CalFlowLayoutInsetBottom = 20.0f;
const CGFloat CalFlowLayoutInsetRight = 0.0f;
const CGFloat CalFlowLayoutHeaderHeight = 30.0f;


@implementation CalLayout


-(instancetype)init{
    
    
    self = [super init];
    
    if(self){
        
        self.minimumInteritemSpacing = CalFlowLayoutMinInterItemSpacing;
        self.minimumLineSpacing = CalFlowLayoutMinLineSpacing;
        self.scrollDirection = UICollectionViewScrollDirectionVertical;
        self.sectionInset = UIEdgeInsetsMake(CalFlowLayoutInsetTop, CalFlowLayoutInsetLeft, CalFlowLayoutInsetBottom, CalFlowLayoutInsetRight);
        self.headerReferenceSize = CGSizeMake(0, CalFlowLayoutHeaderHeight);
        
        
    }
    
    return self;
}








@end
