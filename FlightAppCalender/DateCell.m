//
//  CollectionViewCell.m
//  AkbarCalendar
//
//  Created by Jayanta Gogoi on 02/08/16.
//  Copyright © 2016 Jayanta Gogoi. All rights reserved.
//

#import "DateCell.h"


//const CGFloat cellSize = 30.0f;
#define Rgb2UIColor(r, g, b) [UIColor colorWithRed:((r) / 255.0) green:((g) / 255.0) blue:((b) / 255.0) alpha:1.0]


@interface DateCell()

@property(nonatomic, strong) NSDate *date;

@end


@implementation DateCell

@synthesize cellSize;

#pragma mark Class Methods

+ (NSString *)formatDate:(NSDate *)date withCalendar:(NSCalendar *)calendar
{
    NSDateFormatter *dateFormatter = [self dateFormatter];
    return [DateCell stringFromDate:date withDateFormatter:dateFormatter withCalendar:calendar];
}

+ (NSString *)formatAccessibilityDate:(NSDate *)date withCalendar:(NSCalendar *)calendar
{
    NSDateFormatter *dateFormatter = [self accessibilityDateFormatter];
    return [DateCell stringFromDate:date withDateFormatter:dateFormatter withCalendar:calendar];
}


+ (NSDateFormatter *)dateFormatter {
    static NSDateFormatter *dateFormatter;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        dateFormatter = [[NSDateFormatter alloc] init];
        dateFormatter.dateFormat = @"d";
    });
    return dateFormatter;
}

+ (NSDateFormatter *)accessibilityDateFormatter {
    static NSDateFormatter *dateFormatter;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        dateFormatter = [[NSDateFormatter alloc] init];
        [dateFormatter setDateStyle:NSDateFormatterLongStyle];
        [dateFormatter setTimeStyle:NSDateFormatterNoStyle];
        
    });
    return dateFormatter;
}

+ (NSString *)stringFromDate:(NSDate *)date withDateFormatter:(NSDateFormatter *)dateFormatter withCalendar:(NSCalendar *)calendar {
    //Test if the calendar is different than the current dateFormatter calendar property
    if (![dateFormatter.calendar isEqual:calendar]) {
        dateFormatter.calendar = calendar;
    }
    return [dateFormatter stringFromDate:date];
}


@synthesize dayLabel = _dayLabel;
@synthesize fareLabel = _fareLabel;

-(instancetype)initWithFrame:(CGRect)frame{
    
    self = [super initWithFrame:frame];
    
    if(self){
        
        self.cellSize = 46.15;
        _date = nil;
        _isToday = NO;
        _dayLabel = [[UILabel alloc] init];
        [self.dayLabel setFont:[self textDefaultFont]];
        [self.dayLabel setTextAlignment:NSTextAlignmentCenter];
        [self.contentView addSubview:self.dayLabel];
        
        _fareLabel = [[UILabel alloc] init];
        [self.fareLabel setFont:[UIFont systemFontOfSize:10]];
        [self.fareLabel setTextAlignment:NSTextAlignmentCenter];
        [self.contentView addSubview:self.fareLabel];
        
        //Add the Constraints
        [self.dayLabel setTranslatesAutoresizingMaskIntoConstraints:NO];
        [self.dayLabel setBackgroundColor:[UIColor clearColor]];
        self.dayLabel.layer.cornerRadius = cellSize/2;
        self.dayLabel.layer.masksToBounds = YES;
        
        [self.contentView addConstraint:[NSLayoutConstraint constraintWithItem:self.dayLabel attribute:NSLayoutAttributeCenterX relatedBy:NSLayoutRelationEqual toItem:self.contentView attribute:NSLayoutAttributeCenterX multiplier:1.0 constant:0.0]];
        [self.contentView addConstraint:[NSLayoutConstraint constraintWithItem:self.dayLabel attribute:NSLayoutAttributeCenterY relatedBy:NSLayoutRelationEqual toItem:self.contentView attribute:NSLayoutAttributeCenterY multiplier:1.0 constant:0.0]];
        [self.contentView addConstraint:[NSLayoutConstraint constraintWithItem:self.dayLabel attribute:NSLayoutAttributeHeight relatedBy:NSLayoutRelationEqual toItem:nil attribute:NSLayoutAttributeNotAnAttribute multiplier:1.0 constant:cellSize]];
        [self.contentView addConstraint:[NSLayoutConstraint constraintWithItem:self.dayLabel attribute:NSLayoutAttributeWidth relatedBy:NSLayoutRelationEqual toItem:nil attribute:NSLayoutAttributeNotAnAttribute multiplier:1.0 constant:cellSize]];
        
        //Add the Constraints
        [self.fareLabel setTranslatesAutoresizingMaskIntoConstraints:NO];
        self.fareLabel.layer.masksToBounds = YES;
        
        
        [self.contentView addConstraint:[NSLayoutConstraint constraintWithItem:self.fareLabel attribute:NSLayoutAttributeCenterX relatedBy:NSLayoutRelationEqual toItem:self.contentView attribute:NSLayoutAttributeCenterX multiplier:1.0 constant:0.0]];
        [self.contentView addConstraint:[NSLayoutConstraint constraintWithItem:self.fareLabel attribute:NSLayoutAttributeCenterY relatedBy:NSLayoutRelationEqual toItem:self.contentView attribute:NSLayoutAttributeCenterY multiplier:1.5 constant:0.0]];
        
        
        
        
        [self setCircleColor:NO selected:NO];
    }
    
    
    return self;
}

-(void)setMultipleSelectEnable{
    
    [self.contentView setBackgroundColor:[UIColor lightGrayColor]];
}

-(void)setDate:(NSDate *)date calendar:(NSCalendar *)calendar{
    
    
    NSString *day = @"";
    NSString *accessibilityDay = @"";
    
    if(date && calendar){
        
        _date = date;
        day = [DateCell formatDate:date withCalendar:calendar];
        accessibilityDay = [DateCell formatAccessibilityDate:date withCalendar:calendar];
        
        
        NSDateComponents *dc = [calendar components:NSCalendarUnitWeekday fromDate:date];
        
        [self.dayLabel setFont:[UIFont systemFontOfSize:11]];
        
        if([dc weekday] == 1){
            
            [self.dayLabel setTextColor:[UIColor redColor]];
            [self.dayLabel setFont:[UIFont boldSystemFontOfSize:16]];
        }else{
            
            [self.dayLabel setFont:[UIFont boldSystemFontOfSize:16]];
            [self.dayLabel setTextColor:[UIColor darkGrayColor]];
            
        }
        
        self.dayLabel.text = day;
        self.dayLabel.accessibilityLabel = accessibilityDay;
        self.assignDate = date;
        
    }
    
}


-(void)setFare:(NSString *)fare{
    
    if([fare length] > 0){
        
        [self.fareLabel setTextColor:[UIColor clearColor]];
        
        [UIView transitionWithView:self.fareLabel duration:0.5 options:UIViewAnimationOptionTransitionCrossDissolve animations:^{
            
            [self.fareLabel setTextColor:Rgb2UIColor(0, 128, 0)];
            self.fareLabel.text = fare;
            
        }completion:nil];
        
        
        
    }else{
        
        self.fareLabel.text = @"";
    }
    
    self.fareLabel.backgroundColor = [UIColor clearColor];
    
    
}


- (void)setIsToday:(BOOL)isToday
{
    _isToday = isToday;
    [self setCircleColor:isToday selected:self.selected];
}

- (void)setSelected:(BOOL)selected
{
    [super setSelected:selected];
    [self setCircleColor:self.isToday selected:selected];
}


- (void)setCircleColor:(BOOL)today selected:(BOOL)selected
{
    UIColor *circleColor = (today) ? [self circleTodayColor] : [self circleDefaultColor];
    UIColor *labelColor = (today) ? [self textTodayColor] : [self textDefaultColor];
    
    if (self.date && self.delegate) {
        if ([self.delegate respondsToSelector:@selector(simpleCalendarViewCell:shouldUseCustomColorsForDate:)] && [self.delegate simpleCalendarViewCell:self shouldUseCustomColorsForDate:self.date]) {
            
            if ([self.delegate respondsToSelector:@selector(simpleCalendarViewCell:textColorForDate:)] && [self.delegate simpleCalendarViewCell:self textColorForDate:self.date]) {
                labelColor = [self.delegate simpleCalendarViewCell:self textColorForDate:self.date];
            }
            
            if ([self.delegate respondsToSelector:@selector(simpleCalendarViewCell:circleColorForDate:)] && [self.delegate simpleCalendarViewCell:self circleColorForDate:self.date]) {
                circleColor = [self.delegate simpleCalendarViewCell:self circleColorForDate:self.date];
            }
        }
    }
    
    if (selected) {
        circleColor = [self circleSelectedColor];
        labelColor = [self textSelectedColor];
    }else{
        labelColor = [self textDefaultColor];
    }
    
    [self.dayLabel setBackgroundColor:circleColor];
    [self.dayLabel setTextColor:labelColor];
}


- (void)refreshCellColors
{
    [self setCircleColor:self.isToday selected:self.isSelected];
}


#pragma mark - Prepare for Reuse

- (void)prepareForReuse
{
    [super prepareForReuse];
    _date = nil;
    _isToday = NO;
    [self.dayLabel setText:@""];
    [self.dayLabel setBackgroundColor:[self circleDefaultColor]];
    [self.dayLabel setTextColor:[self textDefaultColor]];
}

#pragma mark - Circle Color Customization Methods

- (UIColor *)circleDefaultColor
{
    if(_circleDefaultColor == nil) {
        _circleDefaultColor = [[[self class] appearance] circleDefaultColor];
    }
    
    if(_circleDefaultColor != nil) {
        return _circleDefaultColor;
    }
    
    //whiteColor
    return [UIColor clearColor];
}

- (UIColor *)circleTodayColor
{
    if(_circleTodayColor == nil) {
        _circleTodayColor = [[[self class] appearance] circleTodayColor];
    }
    
    if(_circleTodayColor != nil) {
        return _circleTodayColor;
    }
    
    return [UIColor lightGrayColor];
}

- (UIColor *)circleSelectedColor
{
    if(_circleSelectedColor == nil) {
        _circleSelectedColor = [[[self class] appearance] circleSelectedColor];
    }
    
    if(_circleSelectedColor != nil) {
        return _circleSelectedColor;
    }
    
    return Rgb2UIColor(172, 24, 19);
}

#pragma mark - Text Label Customizations Color

- (UIColor *)textDefaultColor
{
    if(_textDefaultColor == nil) {
        _textDefaultColor = [[[self class] appearance] textDefaultColor];
    }
    
    if(_textDefaultColor != nil) {
        return _textDefaultColor;
    }
    
    return [UIColor darkGrayColor]; //[UIColor blackColor];
}

- (UIColor *)textTodayColor
{
    if(_textTodayColor == nil) {
        _textTodayColor = [[[self class] appearance] textTodayColor];
    }
    
    if(_textTodayColor != nil) {
        return _textTodayColor;
    }
    
    return [UIColor whiteColor];
}

- (UIColor *)textSelectedColor
{
    if(_textSelectedColor == nil) {
        _textSelectedColor = [[[self class] appearance] textSelectedColor];
    }
    
    if(_textSelectedColor != nil) {
        return _textSelectedColor;
    }
    
    return [UIColor whiteColor];
}

- (UIColor *)textDisabledColor
{
    if(_textDisabledColor == nil) {
        _textDisabledColor = [[[self class] appearance] textDisabledColor];
    }
    
    if(_textDisabledColor != nil) {
        return _textDisabledColor;
    }
    
    return [UIColor lightGrayColor];
}

#pragma mark - Text Label Customizations Font

- (UIFont *)textDefaultFont
{
    if(_textDefaultFont == nil) {
        _textDefaultFont = [[[self class] appearance] textDefaultFont];
    }
    
    if (_textDefaultFont != nil) {
        return _textDefaultFont;
    }
    
    // default system font
    return [UIFont systemFontOfSize:14.0];
}




@end
