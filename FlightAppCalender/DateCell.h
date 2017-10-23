//
//  CollectionViewCell.h
//  AkbarCalendar
//
//  Created by Jayanta Gogoi on 02/08/16.
//  Copyright © 2016 Jayanta Gogoi. All rights reserved.
//
#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@class DateCell;

@protocol DateCellDelegate <NSObject>

@optional

- (BOOL)simpleCalendarViewCell:(DateCell *)cell shouldUseCustomColorsForDate:(NSDate *)date;
- (UIColor *)simpleCalendarViewCell:(DateCell *)cell textColorForDate:(NSDate *)date;
- (UIColor *)simpleCalendarViewCell:(DateCell *)cell circleColorForDate:(NSDate *)date;


@end



@interface DateCell : UICollectionViewCell


@property(nonatomic, assign) BOOL isToday;
@property(nonatomic,strong) NSDate *assignDate;

@property(nonatomic, strong)id<DateCellDelegate> delegate;

@property(nonatomic)UILabel *dayLabel,*fareLabel;

@property(nonatomic)CGFloat cellSize;

/**
 *  Customize the circle behind the day's number color using UIAppearance.
 */
@property (nonatomic, strong) UIColor *circleDefaultColor UI_APPEARANCE_SELECTOR;

/**
 *  Customize the color of the circle for today's cell using UIAppearance.
 */
@property (nonatomic, strong) UIColor *circleTodayColor UI_APPEARANCE_SELECTOR;

/**
 *  Customize the color of the circle when cell is selected using UIAppearance.
 */
@property (nonatomic, strong) UIColor *circleSelectedColor UI_APPEARANCE_SELECTOR;

/**
 *  Customize the day's number using UIAppearance.
 */
@property (nonatomic, strong) UIColor *textDefaultColor UI_APPEARANCE_SELECTOR;

/**
 *  Customize today's number color using UIAppearance.
 */
@property (nonatomic, strong) UIColor *textTodayColor UI_APPEARANCE_SELECTOR;

/**
 *  Customize the day's number color when cell is selected using UIAppearance.
 */
@property (nonatomic, strong) UIColor *textSelectedColor UI_APPEARANCE_SELECTOR;

/**
 *  Customize the day's number color when cell is disabled using UIAppearance.
 */
@property (nonatomic, strong) UIColor *textDisabledColor UI_APPEARANCE_SELECTOR;

/**
 *  Customize the day's number font using UIAppearance.
 */
@property (nonatomic, strong) UIFont *textDefaultFont UI_APPEARANCE_SELECTOR;

/**
 * Set the date for this cell
 *
 * @param date the date (Midnight GMT).
 *
 * @param calendar the calendar.
 */
- (void) setDate:(NSDate*)date calendar:(NSCalendar*)calendar;

-(void)setFare:(NSString *)fare;

/**
 *  Force the refresh of the colors for the circle and the text
 */
- (void)refreshCellColors;

@end
