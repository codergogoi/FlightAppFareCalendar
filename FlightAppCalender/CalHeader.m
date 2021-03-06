//
//  CalHeader.m
//  AkbarCalendar
//
//  Created by Jayanta Gogoi on 04/08/16.
//  Copyright © 2016 Jayanta Gogoi. All rights reserved.
//

#import "CalHeader.h"

const CGFloat calHeaderTextSize = 16.0f;

@implementation CalHeader


-(instancetype)initWithFrame:(CGRect)frame {
    
    self = [super initWithFrame:frame];
    
    
    if(self){
        
        _titleLabel = [[UILabel alloc] init];
        [_titleLabel setFont:self.textFont];
        [_titleLabel setTextColor:self.textColor];
        [_titleLabel setBackgroundColor:[UIColor clearColor]];
        
        
        [self addSubview:_titleLabel];
        [_titleLabel setTranslatesAutoresizingMaskIntoConstraints:NO];
        
        
        UIView *separatorView = [[UIView alloc] init];
        [separatorView setBackgroundColor:self.separatorColor];
        [self addSubview:separatorView];
        [separatorView setTranslatesAutoresizingMaskIntoConstraints:NO];
        
        CGFloat onePixel = 1.0f / [UIScreen mainScreen].scale;
        NSDictionary *metricsDictionary = @{@"onePixel" : [NSNumber numberWithFloat:onePixel]};
        NSDictionary *viewsDictionary = @{@"titleLabel" : self.titleLabel, @"separatorView" : separatorView};
        
        
        
        [self addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"|-(==10)-[titleLabel]-(==10)-|" options:0 metrics:nil views:viewsDictionary]];
        [self addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:|[titleLabel]|" options:0 metrics:nil views:viewsDictionary]];
        
        
        [self addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"|[separatorView]|" options:0 metrics:nil views:viewsDictionary]];
        [self addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:[separatorView(==onePixel)]|" options:0 metrics:metricsDictionary views:viewsDictionary]];
        
    }
    
    return self;
}


- (UIColor *)textColor
{
    if(_textColor == nil) {
        _textColor = [[[self class] appearance] textColor];
    }
    
    if(_textColor != nil) {
        return _textColor;
    }
    
    return [UIColor darkGrayColor];
}

- (UIFont *)textFont
{
    if(_textFont == nil) {
        _textFont = [[[self class] appearance] textFont];
    }
    
    if(_textFont != nil) {
        return _textFont;
    }
    
    return [UIFont systemFontOfSize:calHeaderTextSize];
}

- (UIColor *)separatorColor
{
    if(_separatorColor == nil) {
        _separatorColor = [[[self class] appearance] separatorColor];
    }
    
    if(_separatorColor != nil) {
        return _separatorColor;
    }
    
    return [UIColor lightGrayColor];
}

@end
