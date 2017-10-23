    //
    //  CalHeader.h
    //  AkbarCalendar
    //
    //  Created by Jayanta Gogoi on 04/08/16.
    //  Copyright © 2016 Jayanta Gogoi. All rights reserved.
    //

#import <UIKit/UIKit.h>

@interface CalHeader : UICollectionReusableView


/**
 *  Label that display the month and year
 */
@property (nonatomic, strong) UILabel *titleLabel;

/** @name Customizing Appearance */

/**
 *  Customize the Month text color display.
 */
@property (nonatomic, strong) UIColor *textColor UI_APPEARANCE_SELECTOR;

/**
 *  Customize the Month text font.
 */
@property (nonatomic, strong) UIFont *textFont UI_APPEARANCE_SELECTOR;

/**
 *  Customize the separator color between the month name and the dates.
 */
@property (nonatomic, strong) UIColor *separatorColor UI_APPEARANCE_SELECTOR;



@end
