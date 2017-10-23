    //
    //  CalenderViewController.h
    //  AkbarCalendar
    //
    //  Created by Jayanta Gogoi on 02/08/16.
    //  Copyright © 2016 Jayanta Gogoi. All rights reserved.
    //

#import <UIKit/UIKit.h>
#import <QuartzCore/QuartzCore.h>
#import "CalendarDelegate.h"

@interface CalendarViewController : UIViewController <UICollectionViewDelegate, UICollectionViewDataSource, UIGestureRecognizerDelegate>

@property(nonatomic)NSCalendar *calendar;
@property(nonatomic)NSDate *firstDate;
@property(nonatomic)NSDate *lastDate;
@property(nonatomic)NSDate *selectedDate;
@property(nonatomic)UIColor *backgroundColor;
@property(nonatomic)UIColor *overlayTextColor;
@property(nonatomic,assign) BOOL isReturnSelected;
@property(nonatomic) UITapGestureRecognizer *onwardTap,*returnTap;
@property(nonatomic) id<CalendarDelegate> calDelegate;
@property(nonatomic,strong) NSDictionary * dateHistory;


 
@end

