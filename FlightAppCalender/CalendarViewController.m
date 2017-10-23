//
//  CalenderViewController.m
//  AkbarCalendar
//
//  Created by Jayanta Gogoi on 02/08/16.
//  Copyright © 2016 Jayanta Gogoi. All rights reserved.
//

#import "CalendarViewController.h"
#import "DateCell.h"
#import "CalLayout.h"
#import "CalHeader.h"
#import "UIButton+Configure.h"


#define Rgb2UIColor(r, g, b) [UIColor colorWithRed:((r) / 255.0) green:((g) / 255.0) blue:((b) / 255.0) alpha:1.0]
#define Rgb2UIColora(r, g, b) [UIColor colorWithRed:((r) / 255.0) green:((g) / 255.0) blue:((b) / 255.0) alpha:0.2]

#define Rgb2UIColorAlp(r, g, b,a) [UIColor colorWithRed:((r) / 255.0) green:((g) / 255.0) blue:((b) / 255.0) alpha:((a)/255.0)]


static const NSCalendarUnit kCalendarUnitYMD = NSCalendarUnitYear | NSCalendarUnitMonth | NSCalendarUnitDay;

static NSString *const cellIdentifier = @"cell";
static NSString *const cellHeaderIdentifier = @"cellheader";

@interface CalendarViewController () <DateCellDelegate>{
    NSString *fareCalendarRequestJsonString;
    
    
}


@property(nonatomic)UIView *springBar;

@property (nonatomic) UICollectionView *calendarView;
@property (nonatomic) UIView *informationView;

@property(nonatomic)NSArray *dateArray;

@property(nonatomic, strong)NSDateFormatter *headerDateFormatter;
@property(nonatomic) NSDate *firstDateMonth;
@property(nonatomic) NSDate *lastDateMonth;
@property(nonatomic) NSString *currentSelectedDate;
@property(nonatomic, assign)NSUInteger daysPerWeek;

@property (nonatomic) UILabel *txtMonthName;
//@property (nonatomic) UILabel *onwardDMPrefix,*returnDMPrefix;
@property (nonatomic) UILabel *txtOnwardDate,*txtReturnDate;
@property (nonatomic) UILabel *txtReturnTitle;
@property (nonatomic) BOOL isReturn,isRangeAvailable;
@property (nonatomic) NSIndexPath *onwardIndex;
@property (nonatomic) NSIndexPath *returnIndex;
@property (nonatomic) NSMutableArray *returnRange;
@property (nonatomic) UIView *leftView,*rightView;
@property (nonatomic) UIView *selectionBorder;
@property (nonatomic) NSIndexPath *todayIndexPath;
@property (nonatomic) UILabel *returnTripText;
@property (nonatomic) NSDate * prevOnwardDate;
@property (nonatomic) NSIndexPath *prevOnwardPath;
@property (nonatomic) NSDate *prevReturnDate;
@property (nonatomic) NSIndexPath *prevReturnPath;
@property (nonatomic) NSIndexPath *startUpPath;
@property (nonatomic) UIButton *clearRoundTrip;
@property (nonatomic,assign) BOOL isOwPreSelected;
@property (nonatomic,strong) NSIndexPath *StartIndex,*EndIndex;


@property (nonatomic,strong) NSMutableArray *fareCalendarArray;
@property (nonatomic,strong) NSMutableArray *onwardFareArray, *returnFareArray;


//New Design
@property(nonatomic) UILabel *lblOwMenu, *lblRetMenu;
@property(nonatomic,strong)UILabel *prompt, *dateDescription;

@property(nonatomic,assign) BOOL isEndSelection ;
@property(nonatomic,assign) BOOL isReturnFare;
@property(nonatomic,assign) BOOL isReloadedFare;


//FareCalrequest
@property(nonatomic,strong) NSMutableDictionary *calRequestDict;
@property(nonatomic, strong)NSString *errorResponseString;



@end

@implementation CalendarViewController

@synthesize calendarView;
@synthesize dateArray;

@synthesize firstDate = _firstDate;
@synthesize lastDate = _lastDate;
@synthesize calendar = _calendar;
@synthesize informationView;
@synthesize txtOnwardDate,txtReturnDate,txtReturnTitle;
@synthesize isReturn,isRangeAvailable;
@synthesize onwardIndex;
@synthesize returnIndex;
@synthesize onwardTap,returnTap;
@synthesize leftView,rightView;
@synthesize selectionBorder;
@synthesize todayIndexPath;
@synthesize txtMonthName;
@synthesize returnTripText;
@synthesize currentSelectedDate;
@synthesize isReturnSelected;
@synthesize prevOnwardDate;
@synthesize prevOnwardPath;
@synthesize prevReturnDate;
@synthesize prevReturnPath;
@synthesize startUpPath;
@synthesize clearRoundTrip;
@synthesize isOwPreSelected;
@synthesize StartIndex,EndIndex;
@synthesize fareCalendarArray;

@synthesize calRequestDict;
@synthesize errorResponseString;

//new design
@synthesize lblOwMenu,lblRetMenu;
@synthesize prompt;

@synthesize calDelegate;
@synthesize dateHistory;

static const NSInteger kFirstDay = 1;


#pragma mark - View Methods

- (void)viewDidLoad {
    
    [super viewDidLoad];
    
    
    [self.view setBackgroundColor:Rgb2UIColorAlp(255, 255, 255, 250)];
    
    UIView *topBar = [[UIView alloc] initWithFrame:CGRectMake(0, 0, self.view.bounds.size.width, 70)];
    topBar.backgroundColor = Rgb2UIColor(178, 24, 19);
    
    UIButton *menuBtn =  [UIButton buttonWithType:UIButtonTypeCustom];
    [menuBtn setImage:[UIImage imageNamed:@"prev"] forState:UIControlStateNormal];
    [menuBtn setFrame:CGRectMake(10, 35, 22, 22)];
    [menuBtn addTarget:self action:@selector(onCancelTap) forControlEvents:UIControlEventTouchUpInside];
    [topBar addSubview:menuBtn];
    
    
    UIView *rectView = [[UIView alloc] initWithFrame:CGRectMake(0, 24, 260, 40)];
    rectView.layer.cornerRadius = 20;
    rectView.layer.borderWidth = 1;
    rectView.layer.borderColor = Rgb2UIColorAlp(255, 255, 255, 100).CGColor;
    rectView.center = CGPointMake(topBar.center.x, rectView.center.y);
    [topBar addSubview:rectView];
    
    
    self.lblOwMenu = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, rectView.frame.size.width/2, 40)];
    self.lblOwMenu.text = @"Onward";
    [self.lblOwMenu setBackgroundColor:[UIColor clearColor]];
    self.lblOwMenu.font = [UIFont systemFontOfSize:11];
    self.lblOwMenu.textColor = Rgb2UIColorAlp(255, 255, 255, 200);
    self.lblOwMenu.textAlignment = NSTextAlignmentCenter;
    [rectView addSubview:self.lblOwMenu];
    
    
    
    self.lblRetMenu = [[UILabel alloc] initWithFrame:CGRectMake(rectView.frame.size.width/2,0, rectView.frame.size.width/2, 40)];
    self.lblRetMenu.text = @"Return";
    [self.lblRetMenu setBackgroundColor:[UIColor clearColor]];
    self.lblRetMenu.font = [UIFont systemFontOfSize:14];
    self.lblRetMenu.textColor = Rgb2UIColorAlp(255, 255, 255, 200);
    self.lblRetMenu.textAlignment = NSTextAlignmentCenter;
    [rectView addSubview:self.lblRetMenu];
    
    
    self.springBar = [[UIView alloc] initWithFrame:CGRectMake(0, 0, rectView.frame.size.width/2, 40)];
    [self.springBar setBackgroundColor:Rgb2UIColorAlp(225, 225, 225, 50)];
    self.springBar.layer.cornerRadius = 20;
    self.springBar.layer.borderColor = Rgb2UIColorAlp(174, 24, 19,255).CGColor;
    self.springBar.layer.borderWidth = 5;
    [rectView addSubview:self.springBar];
    
    
    UIView *owTapView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, rectView.bounds.size.width/2, rectView.bounds.size.height)];
    [owTapView setBackgroundColor:[UIColor clearColor]];
    UITapGestureRecognizer *owTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(owSpring)];
    [owTapView addGestureRecognizer:owTap];
    [rectView addSubview:owTapView];
    
    
    UIView *retTapView = [[UIView alloc] initWithFrame:CGRectMake(rectView.bounds.size.width/2, 0, rectView.bounds.size.width/2, rectView.bounds.size.height)];
    [retTapView setBackgroundColor:[UIColor clearColor]];
    UITapGestureRecognizer *retTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(retSpring)];
    [retTapView addGestureRecognizer:retTap];
    [rectView addSubview:retTapView];
    [self.view addSubview:topBar];
    
    
    self.informationView = [[UIView alloc] initWithFrame:CGRectMake(0, topBar.frame.size.height, self.view.frame.size.width, 50)];
    
    isReturn = NO;
    isRangeAvailable = NO;
    
    CGPathRef path =[UIBezierPath bezierPathWithRect:self.informationView.bounds].CGPath;
    
    [self.informationView setBackgroundColor:[UIColor whiteColor]];
    self.informationView.layer.masksToBounds = NO;
    self.informationView.layer.shadowColor = [UIColor blackColor].CGColor;
    
    // other device excluding 6plus or 6splus
    self.informationView.layer.shadowOffset = CGSizeMake(1.0, 1.0);
    
    self.informationView.layer.shadowOpacity = 0.2f;
    self.informationView.layer.shadowPath = path;
    
    [self.view addSubview:informationView];
    
    
    //customise view appearance
    UINavigationBar *bar = [self.navigationController  navigationBar];
    [bar setTintColor:[UIColor whiteColor]];
    [bar setBackgroundColor: Rgb2UIColor(172, 24, 19)];
    
    CGRect frameRect = CGRectMake(0, (self.informationView.frame.size.height + 70.0f), self.view.frame.size.width, (self.view.frame.size.height - self.informationView.frame.size.height) - 60.0f);
    
    CalLayout *layout = [[CalLayout alloc] init];
    
    self.calendarView = [[UICollectionView alloc] initWithFrame:frameRect collectionViewLayout:layout];
    self.calendarView.showsVerticalScrollIndicator = NO;
    
    [self simpleCalenderInit];
    
    [self calHederLayoutSetup];
    
    self.calendarView.collectionViewLayout = layout;
    [self.calendarView setBackgroundColor:[UIColor clearColor]];
    [self.calendarView registerClass:[DateCell class] forCellWithReuseIdentifier:cellIdentifier];
    
    [self.calendarView registerClass:[CalHeader class] forSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:cellHeaderIdentifier];
    self.calendarView.delegate = self;
    self.calendarView.dataSource = self;
    self.calendarView.allowsMultipleSelection = YES;
    
    [self.view addSubview:self.calendarView];
    
    
    
    [self calculateRangeCell];
    [self rangeSelectionToReturnDate];
    
    UIToolbar *toolbar = [[UIToolbar alloc] initWithFrame:CGRectMake(0, self.view.bounds.size.height-44, self.view.bounds.size.width, 44)];
    toolbar.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleTopMargin;
    toolbar.barTintColor = Rgb2UIColorAlp(255, 255, 255, 200);
    
    self.dateDescription = [[UILabel alloc] initWithFrame:CGRectMake(20, 5, 200, 20)];
    self.dateDescription.text = @"";
    self.dateDescription.textColor = Rgb2UIColorAlp(0, 0, 0, 150);
    self.dateDescription.font =  [UIFont systemFontOfSize:14];
    [toolbar addSubview:self.dateDescription];
    
    self.prompt = [[UILabel alloc] initWithFrame:CGRectMake(20, 2, 200, 44)];
    self.prompt.text = @"Select Onward date";
    self.prompt.textColor = [UIColor redColor];
    self.prompt.font =  [UIFont systemFontOfSize:14];
    
    [toolbar addSubview:self.prompt];
    
    UIButton *btnBookNow = [[UIButton alloc] initWithFrame:CGRectMake(toolbar.bounds.size.width - 83, 2, 80, 40)];
    [btnBookNow setTitle:@"Done" forState:UIControlStateNormal];
    [btnBookNow.titleLabel setFont: [UIFont systemFontOfSize:12]];
    btnBookNow.layer.cornerRadius = 20;
    btnBookNow.layer.backgroundColor = Rgb2UIColorAlp(172, 24, 19, 110).CGColor;
    btnBookNow.layer.borderWidth = 3;
    btnBookNow.layer.borderColor = Rgb2UIColorAlp(172, 24, 19, 120).CGColor;
    
    [btnBookNow addTarget:self action:@selector(onDoneTap:) forControlEvents:UIControlEventTouchUpInside];
    
    [toolbar addSubview:btnBookNow];
    
    [self.view addSubview:toolbar];
    
    [self configureCalenderFromHistoryData];
    
    
}

//Configure Calender From Hitrory
-(void)configureCalenderFromHistoryData{
    
    NSDate * OWDate = [NSDate new];
    
    if([self.dateHistory objectForKey:@"owDate"] != nil){
        OWDate = [self.dateHistory objectForKey:@"owDate"];
    }
    
    
    NSDate * RWDate = [NSDate new];
    
    if([self.dateHistory objectForKey:@"retDate"] != nil){
        RWDate = [self.dateHistory objectForKey:@"retDate"];
    }
    
    NSString *isReturnDate = [self.dateHistory objectForKey:@"isReturn"];
    
    self.prevOnwardDate = OWDate;
    
    
    if([isReturnDate isEqualToString:@"YES"]){
        self.prevReturnDate = RWDate;
        self.isReturnSelected = YES;
        self.isReturnFare = YES;
    }else{
        
        isOwPreSelected = YES;
    }
    
    if(OWDate != NULL && RWDate != NULL){
        self.prevOnwardDate = OWDate;
        self.prevReturnDate = RWDate;
    }
    
}

#pragma mark - Spring Effect

-(void)owSpring{
    
    self.prompt.text = @"Select Onward Date";
    
    isReturn = NO;
    
    if(self.isOwPreSelected){
        
        self.isReturnSelected = NO;
    }
    
    self.isReturnFare = NO;
    
    [self.clearRoundTrip setHidden:YES];
    
    [self springEffect:self.lblOwMenu.frame.origin.x forView:self.springBar];
    [self updateDateText];
    [self.calendarView reloadItemsAtIndexPaths:[self.calendarView indexPathsForVisibleItems]];
    
    
}

-(void)retSpring{
    
    self.prompt.text = @"Select Return Date";
    
    if(!self.isReturnSelected){
        
        self.isReturnSelected = YES;
        
        [self figureOutWhichCellHasThisDate];
    }
    
    [self.clearRoundTrip setHidden:NO];
    
    isReturn = YES;
    
    self.isReturnFare = YES;
    
    [self springEffect:self.lblRetMenu.frame.origin.x forView:self.springBar];
    [self updateDateText];
    
}


- (void)springEffect:(CGFloat)xPosition forView:(UIView *)view
{
    
    [UIView animateWithDuration:1.0 delay:0 usingSpringWithDamping:0.2 initialSpringVelocity:5.0 options:UIViewAnimationOptionCurveLinear animations:^{
        [view setFrame:CGRectMake(xPosition, view.frame.origin.y,view.frame.size.width, view.frame.size.height)];
    } completion:^(BOOL finished) {
        
    }];
    
}

-(void)figureOutWhichCellHasThisDate{
    
    self.prevReturnDate = [self.prevOnwardDate dateByAddingTimeInterval:60*60*24*2];
    [self calculateRangeCell];
    [self rangeSelectionToReturnDate];
    
    NSUserDefaults *datePref = [NSUserDefaults standardUserDefaults];
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    
    NSTimeZone *gmt = [NSTimeZone localTimeZone];
    [dateFormatter setTimeZone:gmt];
    
    [dateFormatter setDateFormat:@"yyyy-MM-dd"];
    
    NSString *returnDate = [dateFormatter stringFromDate:self.prevReturnDate];
    
    [datePref setObject:returnDate forKey:@"returnDate"];
    [datePref synchronize];
    
    [self validateDatePref];
    
}

- (void)viewWillDisappear:(BOOL)animated{
    
    [self.navigationController setToolbarHidden:YES animated:YES];
    
}

-(void)viewDidAppear:(BOOL)animated{
    
    [super viewDidAppear:animated];
    
    [self.calendarView scrollToItemAtIndexPath: self.prevOnwardPath atScrollPosition:(UICollectionViewScrollPositionTop) animated:YES];
    
    [self validateDatePref];
    
    
    if(self.isOwPreSelected){
        
        [self onTapOnwardTrip:nil];
        
    }else{
        
        [self retSpring];
    }
    
    
}


-(NSUInteger)compareMonth:(NSDate *)mA MonthB:(NSDate *)mB{
    
    NSDateComponents *firstMonth = [[NSCalendar currentCalendar] components:NSCalendarUnitMonth fromDate:mA];
    
    NSDateComponents *secondMonth = [[NSCalendar currentCalendar] components: NSCalendarUnitMonth fromDate:mB];
    
    if([firstMonth month] == [secondMonth month]) {
        
        return 1;
        
    }else{
        return 0;
    }
    
}


-(UIView *) createBlurView: (UIView *)view withEffect:(UIBlurEffectStyle) style andConstraints:(BOOL)addConstraints{
    
    if(!UIAccessibilityIsReduceTransparencyEnabled()){
        
        UIBlurEffect *blurEffect = [UIBlurEffect effectWithStyle:style];
        UIVisualEffectView *blurEfView = [[UIVisualEffectView alloc] initWithEffect:blurEffect];
        blurEfView.frame = view.frame;
        
        [view addSubview:blurEfView];
        
        if(addConstraints)
        {
            //add auto layout constraints so that the blur fills the screen upon rotating device
            [blurEfView setTranslatesAutoresizingMaskIntoConstraints:NO];
            
            [view addConstraint:[NSLayoutConstraint constraintWithItem:blurEfView
                                                             attribute:NSLayoutAttributeTop
                                                             relatedBy:NSLayoutRelationEqual
                                                                toItem:view
                                                             attribute:NSLayoutAttributeTop
                                                            multiplier:1
                                                              constant:0]];
            
            [view addConstraint:[NSLayoutConstraint constraintWithItem:blurEfView
                                                             attribute:NSLayoutAttributeBottom
                                                             relatedBy:NSLayoutRelationEqual
                                                                toItem:view
                                                             attribute:NSLayoutAttributeBottom
                                                            multiplier:1
                                                              constant:0]];
            
            [view addConstraint:[NSLayoutConstraint constraintWithItem:blurEfView
                                                             attribute:NSLayoutAttributeLeading
                                                             relatedBy:NSLayoutRelationEqual
                                                                toItem:view
                                                             attribute:NSLayoutAttributeLeading
                                                            multiplier:1
                                                              constant:0]];
            
            [view addConstraint:[NSLayoutConstraint constraintWithItem:blurEfView
                                                             attribute:NSLayoutAttributeTrailing
                                                             relatedBy:NSLayoutRelationEqual
                                                                toItem:view
                                                             attribute:NSLayoutAttributeTrailing
                                                            multiplier:1
                                                              constant:0]];
        }
        
        
    }else{
        view.backgroundColor = Rgb2UIColorAlp(255, 255, 255, 240);
        
    }
    
    return view;
    
}


-(void)simpleCalenderInit{
    
    self.calendar = [[NSCalendar alloc] initWithCalendarIdentifier:NSCalendarIdentifierGregorian];
    [self.calendar setFirstWeekday:1];
    self.daysPerWeek = 7;
    
}


-(void)calHederLayoutSetup{
    
    
    // Buttom View
    UIView *buttomView = [[UIView alloc] initWithFrame:CGRectMake(0,0,informationView.frame.size.width, self.informationView.frame.size.height)];
    
    // [buttomView setBackgroundColor:[UIColor yellowColor]];
    [informationView addSubview:buttomView];
    
    txtMonthName = [[UILabel alloc] initWithFrame:CGRectMake(16, 5, buttomView.frame.size.width, 22)];
    [txtMonthName setFont: [UIFont systemFontOfSize:16]];
    
    [txtMonthName setTextColor: Rgb2UIColorAlp(172, 24, 19, 200)];
    [buttomView addSubview:txtMonthName];
    
    float xPos = buttomView.frame.size.width /7.2f;
    float yPos = txtMonthName.frame.size.height -10;
    
    float xShiftPos = 8.0f;
    
    NSArray *daysArray = self.calendar.shortWeekdaySymbols;
    
    
    
    if(self.calendar.firstWeekday == 2){
        
        //NSLog(@"First Week Days 2");
        [buttomView addSubview:[self updateDayHeader:daysArray[1] xPos:xShiftPos yPos:yPos isHoliday:NO]];
        xShiftPos += xPos;
        [buttomView addSubview:[self updateDayHeader:daysArray[2] xPos:xShiftPos yPos:yPos isHoliday:NO]];
        xShiftPos += xPos;
        [buttomView addSubview:[self updateDayHeader:daysArray[3] xPos:xShiftPos yPos:yPos isHoliday:NO]];
        xShiftPos += xPos;
        [buttomView addSubview:[self updateDayHeader:daysArray[4] xPos:xShiftPos yPos:yPos isHoliday:NO]];
        xShiftPos += xPos;
        [buttomView addSubview:[self updateDayHeader:daysArray[5] xPos:xShiftPos yPos:yPos isHoliday:NO]];
        xShiftPos += xPos;
        [buttomView addSubview:[self updateDayHeader:daysArray[6] xPos:xShiftPos yPos:yPos isHoliday:NO]];
        xShiftPos += xPos;
        [buttomView addSubview:[self updateDayHeader:daysArray[0] xPos:xShiftPos yPos:yPos isHoliday:YES]];
        xShiftPos += xPos;
        
    }else if(self.calendar.firstWeekday == 1){
        
        // NSLog(@"First Week Days 1");
        [buttomView addSubview:[self updateDayHeader:daysArray[0] xPos:xShiftPos yPos:yPos isHoliday:YES]];
        xShiftPos += xPos;
        [buttomView addSubview:[self updateDayHeader:daysArray[1] xPos:xShiftPos yPos:yPos isHoliday:NO]];
        xShiftPos += xPos;
        [buttomView addSubview:[self updateDayHeader:daysArray[2] xPos:xShiftPos yPos:yPos isHoliday:NO]];
        xShiftPos += xPos;
        [buttomView addSubview:[self updateDayHeader:daysArray[3] xPos:xShiftPos yPos:yPos isHoliday:NO]];
        xShiftPos += xPos;
        [buttomView addSubview:[self updateDayHeader:daysArray[4] xPos:xShiftPos yPos:yPos isHoliday:NO]];
        xShiftPos += xPos;
        [buttomView addSubview:[self updateDayHeader:daysArray[5] xPos:xShiftPos yPos:yPos isHoliday:NO]];
        xShiftPos += xPos;
        [buttomView addSubview:[self updateDayHeader:daysArray[6] xPos:xShiftPos yPos:yPos isHoliday:NO]];
        xShiftPos += xPos;
        
        
    }else{
        
        //NSLog(@"First Week Days 0");
        [buttomView addSubview:[self updateDayHeader:daysArray[6] xPos:xShiftPos yPos:yPos isHoliday:NO]];
        xShiftPos += xPos;
        [buttomView addSubview:[self updateDayHeader:daysArray[0] xPos:xShiftPos yPos:yPos isHoliday:YES]];
        xShiftPos += xPos;
        [buttomView addSubview:[self updateDayHeader:daysArray[1] xPos:xShiftPos yPos:yPos isHoliday:NO]];
        xShiftPos += xPos;
        [buttomView addSubview:[self updateDayHeader:daysArray[2] xPos:xShiftPos yPos:yPos isHoliday:NO]];
        xShiftPos += xPos;
        [buttomView addSubview:[self updateDayHeader:daysArray[3] xPos:xShiftPos yPos:yPos isHoliday:NO]];
        xShiftPos += xPos;
        [buttomView addSubview:[self updateDayHeader:daysArray[4] xPos:xShiftPos yPos:yPos isHoliday:NO]];
        xShiftPos += xPos;
        [buttomView addSubview:[self updateDayHeader:daysArray[5] xPos:xShiftPos yPos:yPos isHoliday:NO]];
        xShiftPos += xPos;
        
        
        
    }
    
    if(isReturnSelected){
        
        [self.clearRoundTrip setHidden:NO];
    }else{
        
        [self.clearRoundTrip setHidden:YES];
    }
    
    
}

-(UIView *)updateDayHeader:(NSString *)day xPos:(float) xpos yPos:(float)ypos isHoliday:(BOOL)isHoliday{
    
    UILabel *dayHeader = [[UILabel alloc] initWithFrame:CGRectMake(xpos, ypos, 40, 25)];
    
    [dayHeader setFont: [UIFont systemFontOfSize:13]];
    [dayHeader setTextAlignment:NSTextAlignmentCenter];
    [dayHeader setTextColor:[UIColor darkGrayColor]];
    [dayHeader setBackgroundColor:[UIColor clearColor]];
    [dayHeader setFont:[UIFont boldSystemFontOfSize:13.0f]];
    [dayHeader setText:day];
    
    if(isHoliday){
        
        dayHeader.textColor = Rgb2UIColor(172, 24, 19);
    }
    
    
    return dayHeader;
    
}

- (void)moveViewPosition:(CGFloat)xPosition forView:(UIView *)view
{
    [UIView beginAnimations:nil context:nil];
    [UIView setAnimationDuration:0.25];
    [UIView setAnimationCurve:UIViewAnimationCurveLinear];
    
    [view setFrame:CGRectMake(xPosition, view.frame.origin.y,view.frame.size.width, view.frame.size.height)];
    [UIView commitAnimations];
}


#pragma mark Gesture Actions

-(void)clearReturn{
    
    [self.clearRoundTrip setHidden:YES];
    self.isReturnSelected = NO;
    isReturn = NO;
    self.prevReturnPath = nil;
    [self.calendarView reloadItemsAtIndexPaths:[self.calendarView indexPathsForVisibleItems]];
    [self.calendarView reloadData];
    [self onTapOnwardTrip:nil];
    [self.calendarView  scrollToItemAtIndexPath:self.prevOnwardPath atScrollPosition:UICollectionViewScrollPositionCenteredVertically animated:YES];
}

-(IBAction)onTapOnwardTrip:(id)sender{
    
    isReturn = NO;
    [self changeSelectionBg];
    
}

-(IBAction)onTapReturnTrip:(id)sender{
    
    if(!self.isReturnSelected){
        
        self.isReturnSelected = YES;
        
        [self figureOutWhichCellHasThisDate];
    }
    
    [self.clearRoundTrip setHidden:NO];
    
    isReturn = YES;
    
    
    [self changeSelectionBg];
}


#pragma mark Update Selected date UI

-(void)updateDateText{
    
    NSUserDefaults *datePref  = [NSUserDefaults standardUserDefaults];
    
    if(isReturnSelected){
        
        NSString *owDate = [datePref objectForKey:@"onwardDate"];
        NSString *retDate = [datePref objectForKey:@"returnDate"];
        
        NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
        
        NSTimeZone *gmt = [NSTimeZone localTimeZone];
        [dateFormatter setTimeZone:gmt];
        
        [dateFormatter setDateFormat:@"yyyy-MM-dd"];
        
        NSDate *onwardDate = [dateFormatter dateFromString:owDate];
        
        NSDate *returnDate = [dateFormatter dateFromString:retDate];
        
        
        NSDateFormatter *dateFormater = [NSDateFormatter new];
        dateFormater.dateFormat = @"d MMM''yy";
        
        if ([dateFormater stringFromDate:returnDate] != nil) {
            
            self.dateDescription.text = [NSString stringWithFormat:@"%@ \u21C4 %@",[dateFormater stringFromDate:onwardDate],[dateFormater stringFromDate:returnDate]];
        }
        
        if([owDate length] > 0 && [retDate length] > 0){
            
            [self.prompt setHidden:YES];
            
            CGRect frame = CGRectMake(self.prompt.frame.origin.x, 0, self.prompt.frame.size.width, self.prompt.frame.size.height);
            
            [self.dateDescription setFrame:frame];
            
        }
        
    }else{
        
        NSString *owDate = [datePref objectForKey:@"onwardDate"];
        
        NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
        
        NSTimeZone *gmt = [NSTimeZone localTimeZone];
        [dateFormatter setTimeZone:gmt];
        
        [dateFormatter setDateFormat:@"yyyy-MM-dd"];
        
        NSDate *onwardDate = [dateFormatter dateFromString:owDate];
        
        NSDateFormatter *dateFormater = [NSDateFormatter new];
        dateFormater.dateFormat = @"d MMM''yy";
        
        self.dateDescription.text = [NSString stringWithFormat:@"\u279D %@",[dateFormater stringFromDate:onwardDate]];
        
    }
    
    
    
    
}




#pragma mark Selection Identity
-(void)changeSelectionBg{
    
    
    if(!isReturnSelected){
        
        [returnTripText setText:@"Tap to Book\nReturn Flight"];
        [txtReturnDate setText:@""];
        [txtReturnTitle setText:@""];
    }else{
        
        [txtReturnTitle setText:@"RETURN"];
        [returnTripText setText:@""];
    }
    
    if(isReturn){
        
        [self.leftView setBackgroundColor:Rgb2UIColorAlp(172, 24, 19, 20)];
        [self.rightView setBackgroundColor:Rgb2UIColorAlp(172, 24, 19, 20)];
        [self.rightView setAlpha:1.0f];
        [self moveViewPosition:self.rightView.frame.origin.x forView:self.selectionBorder];
        
    }else{
        [self.leftView setBackgroundColor:Rgb2UIColorAlp(172, 24, 19, 20)];
        [self.rightView setBackgroundColor:Rgb2UIColorAlp(172, 24, 19, 5)];
        [self moveViewPosition:self.leftView.frame.origin.x forView:self.selectionBorder];
        
    }
}

-(void)setReturnDate{
    
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    
    NSTimeZone *gmt = [NSTimeZone localTimeZone];
    [dateFormatter setTimeZone:gmt];
    [dateFormatter setDateFormat:@"yyyy-MM-dd"];
    
}

-(void)validateDatePref{
    
    //Get saved Date from pref
    NSUserDefaults *datePref = [NSUserDefaults standardUserDefaults];
    NSString *lastOnwardDate = [datePref objectForKey:@"onwardDate"];
    NSString *lastReturnDate = [datePref objectForKey:@"returnDate"];
    
    // set default date formatter
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    // NSTimeZone *gmt = [NSTimeZone timeZoneWithAbbreviation:@"GMT+5:30"];
    
    NSTimeZone *gmt = [NSTimeZone localTimeZone];
    [dateFormatter setTimeZone:gmt];
    [dateFormatter setDateFormat:@"yyyy-MM-dd"];
    
    //get todays date  for validation
    NSDate *today = [NSDate date];
    
    NSDate *onwardDT = [[NSDate alloc] init];
    NSDate *returnDT = [[NSDate alloc] init];
    
    if([lastOnwardDate length] > 0){
        
        onwardDT = [dateFormatter dateFromString:lastOnwardDate];
        
    }else{
        
        onwardDT = [today dateByAddingTimeInterval:60*60*24*1];
    }
    
    if(isReturnSelected){
        
        if([lastReturnDate length] > 0){
            
            returnDT = [dateFormatter dateFromString:lastReturnDate];
            isReturn = YES;
            
        }else{
            
            returnDT = [onwardDT dateByAddingTimeInterval:60*60*24*2];
            
        }
    }
    
    
    
    dateFormatter.dateFormat = @"MMMM";
    
    
    dateFormatter.dateFormat = @"EEEE";
    
    
    NSCalendar *calender = [NSCalendar autoupdatingCurrentCalendar];
    NSDateComponents *dtComponents = [calender components:NSCalendarUnitDay fromDate:onwardDT];
    NSString *onwardDateDigit = [NSString stringWithFormat:@"%ld",[dtComponents day]];
    
    
    dtComponents = [calender components:NSCalendarUnitDay fromDate:returnDT];
    NSString *returnDateDigit = [NSString stringWithFormat:@"%ld",[dtComponents day]];
    
    // set New Onward Date if the selected date is Older
    if(isReturn){
        //set text
        [txtReturnDate setText:[NSString stringWithFormat:@"%@", returnDateDigit]];
        [txtOnwardDate setText:[NSString stringWithFormat:@"%@", onwardDateDigit]];
    }else{
        //set text
        [txtOnwardDate setText:[NSString stringWithFormat:@"%@", onwardDateDigit]];
        
    }
    
    
    [self changeSelectionBg];
}



-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    
    if(self.selectedDate){
        
        [self.calendarView.collectionViewLayout  invalidateLayout];
    }
    
    CGPoint startPoint = CGPointMake(0.0, 0.0);
    
    [self.calendarView setContentOffset:startPoint];
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


#pragma mark Calendar Accessors

-(NSDateFormatter *)headerDateFormatter{
    
    if(!_headerDateFormatter){
        
        _headerDateFormatter = [[NSDateFormatter alloc] init];
        _headerDateFormatter.calendar = self.calendar;
        _headerDateFormatter.dateFormat = [NSDateFormatter dateFormatFromTemplate:@"yyyy LLLL" options:0 locale:self.calendar.locale];
        
    }
    
    return _headerDateFormatter;
}


-(NSCalendar *)calendar{
    
    if(!_calendar){
        
        [self setCalendar:[NSCalendar currentCalendar]];
    }
    
    
    return _calendar;
}

-(void)setCalendar:(NSCalendar *)calendar{
    
    _calendar = calendar;
    self.headerDateFormatter.calendar =calendar;
    self.daysPerWeek = [_calendar maximumRangeOfUnit:NSCalendarUnitWeekday].length;
    
}

-(NSDate *)firstDate{
    
    if(!_firstDate){
        
        NSDateComponents *components = [self.calendar components:kCalendarUnitYMD fromDate:[NSDate date]];
        components.day = 1;
        _firstDate = [self.calendar dateFromComponents:components];
    }
    return _firstDate;
}

-(void)setFirstDate:(NSDate *)firstDate{
    
    _firstDate = [self clampDate:firstDate toComponents:kCalendarUnitYMD];
}



-(NSDate *)firstDateMonth{
    
    if(_firstDateMonth){
        
        return _firstDateMonth;
    }
    
    NSDateComponents *components = [self.calendar components:kCalendarUnitYMD fromDate:self.firstDate];
    components.day = 1; //1
    
    _firstDateMonth = [self.calendar dateFromComponents:components];
    
    return _firstDateMonth;
}


-(NSDate *)lastDate{
    
    
    if(!_lastDate){
        
        NSDateComponents *offsetComponents = [[NSDateComponents alloc] init];
        offsetComponents.year = 1;
        offsetComponents.month = 1;
        offsetComponents.day = -1;
        
        [self setLastDate:[self.calendar dateByAddingComponents:offsetComponents toDate:self.firstDateMonth options:0]];
        
    }
    
    return _lastDate;
}

-(void)setLastDate:(NSDate *)lastDate{
    
    _lastDate = [self clampDate:lastDate toComponents:kCalendarUnitYMD];
    
}

-(NSDate *)lastDateMonth{
    
    if(_lastDateMonth){
        
        return  _lastDateMonth;
    }
    
    NSDateComponents *components = [self.calendar components:kCalendarUnitYMD fromDate:self.lastDate];
    
    components.month++;
    components.day = 0;
    
    _lastDateMonth = [self.calendar dateFromComponents:components];
    
    return _lastDateMonth;
}

-(void)setSelectedDate:(NSDate *)newselectedDate{
    
    if(!newselectedDate){
        
        [[self cellForItemAtDate:_selectedDate] setSelected:NO];
        _selectedDate = newselectedDate;
        
        return;
    }
    NSDate *startOfDay = [self clampDate:newselectedDate toComponents:kCalendarUnitYMD];
    
    if(([startOfDay compare:self.firstDateMonth]== NSOrderedAscending) || ([startOfDay compare:self.lastDateMonth] == NSOrderedDescending)){
        
        return;
    }
    
    [[self cellForItemAtDate:_selectedDate] setSelected:NO];
    [[self cellForItemAtDate:startOfDay] setSelected:YES];
    
    _selectedDate = startOfDay;
    
    NSIndexPath *indexPath = [self indexPathForCellAtDate:_selectedDate];
    [self.calendarView reloadItemsAtIndexPaths:@[ indexPath ]];
}

-(DateCell *)cellForItemAtDate:(NSDate *)date{
    
    
    return (DateCell *)[self.calendarView cellForItemAtIndexPath:[self indexPathForCellAtDate:date]];
}

#pragma mark CalendarCalculation

- (NSDate *)clampDate:(NSDate *)date toComponents:(NSUInteger)unitFlags
{
    NSDateComponents *components = [self.calendar components:unitFlags fromDate:date];
    return [self.calendar dateFromComponents:components];
}


-(BOOL)isTodayDate:(NSDate *)date{
    
    return [self clampAndCompareDate:date withReferenceDate:[NSDate date]];
}

-(BOOL)isSelectedDate:(NSDate *)date{
    
    if(!self.selectedDate){
        return  NO;
    }
    
    return  [self clampAndCompareDate:date withReferenceDate:self.selectedDate];
    
}


-(BOOL) isEnabledDate:(NSDate *)date{
    
    NSDate *clampedDate = [self clampDate:date toComponents:kCalendarUnitYMD];
    
    if(([clampedDate compare:self.firstDate] == NSOrderedAscending) || ([clampedDate compare:self.lastDate] == NSOrderedDescending)){
        
        return NO;
    }
    
    return YES;
}


-(BOOL)clampAndCompareDate:(NSDate *)date withReferenceDate:(NSDate *)referenceDate{
    
    NSDate *refDate = [self clampDate:referenceDate toComponents:kCalendarUnitYMD];
    NSDate *clampedDate = [self clampDate:date toComponents:kCalendarUnitYMD];
    
    return [refDate isEqualToDate:clampedDate];
}

#pragma mark CollectionView CalenderMethod

- (UIEdgeInsets)collectionView:(UICollectionView*)collectionView layout:(UICollectionViewLayout *)collectionViewLayout insetForSectionAtIndex:(NSInteger)section {
    return UIEdgeInsetsMake(0, 0, 0, 0); // top, left, bottom, right
}

-(NSDate *)firstOfMonthForSection:(NSInteger)section{
    
    NSDateComponents *offset = [NSDateComponents new];
    offset.month = section;
    
    return [self.calendar dateByAddingComponents:offset toDate:self.firstDateMonth options:0];
}


-(NSInteger)sectionForDate:(NSDate *)date{
    
    return [self.calendar components:NSCalendarUnitMonth fromDate:self.firstDateMonth toDate:date options:0].month;
    
}


- (NSDate *)dateForCellAtIndexPath:(NSIndexPath *)indexPath
{
    NSDate *firstOfMonth = [self firstOfMonthForSection:indexPath.section];
    
    NSUInteger weekday = [[self.calendar components: NSCalendarUnitWeekday fromDate: firstOfMonth] weekday];
    NSInteger startOffset = weekday - self.calendar.firstWeekday;
    startOffset += startOffset >= 0 ? 0 : self.daysPerWeek;
    
    NSDateComponents *dateComponents = [NSDateComponents new];
    dateComponents.day = indexPath.item - startOffset;
    //NSInteger itemNo = (indexPath.item - startOffset);
    return [self.calendar dateByAddingComponents:dateComponents toDate:firstOfMonth options:0];
}


- (NSIndexPath *)indexPathForCellAtDate:(NSDate *)date
{
    if (!date) {
        return nil;
    }
    
    NSInteger section = [self sectionForDate:date];
    NSDate *firstOfMonth = [self firstOfMonthForSection:section];
    
    NSInteger weekday = [[self.calendar components: NSCalendarUnitWeekday fromDate: firstOfMonth] weekday];
    NSInteger startOffset = weekday - self.calendar.firstWeekday;
    startOffset += startOffset >= 0 ? 0 : self.daysPerWeek;
    
    NSInteger day = [[self.calendar components:kCalendarUnitYMD fromDate:date] day];
    
    NSInteger item = (day - kFirstDay + startOffset);
    
    return [NSIndexPath indexPathForItem:item inSection:section];
    
}



#pragma mark - onDone Tap

- (void)onDoneTap:(UIButton *)sender {
    
    if([sender isKindOfClass:[UIButton class]]){
        
        [sender configureButton];
    }
    
    NSUserDefaults *datePref = [NSUserDefaults standardUserDefaults];
    
    if(!isReturnSelected){
        [datePref setObject:@"" forKey:@"returnDate"];
        [datePref synchronize];
    }else{
        
        NSUserDefaults *datePref = [NSUserDefaults standardUserDefaults];
        NSString *owndate = [datePref objectForKey:@"onwardDate"];
        
        NSString *retudate = [datePref objectForKey:@"returnDate"];
        
        NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
        
        
        NSTimeZone *gmt = [NSTimeZone localTimeZone];
        [dateFormatter setTimeZone:gmt];
        
        [dateFormatter setDateFormat:@"yyyy-MM-dd"];
        
        NSDate *onDT = [dateFormatter dateFromString:owndate];
        NSDate *retDT = [dateFormatter dateFromString:retudate];
        
        NSDateComponents *validateReturnDate = [[NSCalendar currentCalendar] components:NSCalendarUnitDay fromDate:onDT toDate:retDT options:0];
        NSInteger diffReturnDay = [validateReturnDate day];
        
        if(diffReturnDay < 0){
            
            UIAlertController *controller = [UIAlertController alertControllerWithTitle:@"Date Selection" message:@"Please select a valid Return Date" preferredStyle:UIAlertControllerStyleAlert];
            
            UIAlertAction *action = [UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleDefault handler:nil];
            
            
            [controller addAction:action];
            
            [self presentViewController:controller animated:YES completion:nil];
            
            return;
            
        }
        
        [dateFormatter setDateFormat:@"yyyy-MM-dd"];
        
        NSString *returnDate = [dateFormatter stringFromDate:self.prevReturnDate];
        
        [datePref setObject:returnDate forKey:@"returnDate"];
        [datePref synchronize];
        
    }
    
    
    
    if(self.isReturnSelected){
        
        [self performSelector:@selector(closeCalendar) withObject:nil afterDelay:0.1];
    }else{
        
        [self closeCalendar];
        
    }
}

-(void)closeCalendar{
    
    [self.calDelegate updateDateSelection];
    [self dismissViewControllerAnimated:YES completion:nil];
    
}


-(NSString *)checkTodayFare:(NSDate *)cDate{
    
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    
    dateFormatter.dateFormat       = @"dd/MM/yyyy HH:mm:ss";
    
    for(NSDictionary *dict in self.fareCalendarArray){
        
        NSString *dateString = [dict objectForKey:@"owDt"];
        
        NSDate *date = [dateFormatter dateFromString:dateString];
        
        NSDateComponents *components = [[NSCalendar currentCalendar] components:NSCalendarUnitDay | NSCalendarUnitMonth | NSCalendarUnitYear fromDate:date];
        
        NSInteger day = [components day];
        NSInteger month = [components month];
        NSInteger year = [components year];
        
        NSDateComponents *calComponent = [[NSCalendar currentCalendar] components:NSCalendarUnitDay | NSCalendarUnitMonth | NSCalendarUnitYear fromDate:cDate];
        
        NSInteger currentDay = [calComponent day];
        NSInteger currentMonth = [calComponent month];
        NSInteger currentYear = [calComponent year];
        
        if(month == currentMonth && day == currentDay && year == currentYear){
            
            NSString *fare = [NSString stringWithFormat:@"%@",[dict objectForKey:@"ntFr"]];
            
            return fare;
        }
        
    }
    
    return nil;
    
}


-(void)onCancelTap{
    
    NSUserDefaults *datePref = [NSUserDefaults standardUserDefaults];
    
    if(!isReturnSelected){
        [datePref setObject:@"" forKey:@"returnDate"];
        [datePref synchronize];
    }
    
    [self dismissViewControllerAnimated:YES completion:nil];
}

#pragma CollectionView


-(NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView{
    
    
    NSUInteger sectionCount = [self.calendar components:NSCalendarUnitMonth fromDate:self.firstDateMonth toDate:self.lastDateMonth options:0].month +1;
    
    
    return sectionCount;
}

-(NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
    
    NSDate *firstOfMonth  = [self firstOfMonthForSection:section];
    NSRange rangeOfWeeks = [self.calendar rangeOfUnit:NSCalendarUnitWeekOfMonth inUnit:NSCalendarUnitMonth forDate:firstOfMonth];
    
    return (rangeOfWeeks.length * self.daysPerWeek);
    
}


-(UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
    
    DateCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:cellIdentifier forIndexPath:indexPath];
    
   
    
    [cell setUserInteractionEnabled:YES];
    
    cell.delegate = self;
    
    [cell setSelected:NO];
    
    NSDate *firstOfMonth = [self firstOfMonthForSection:indexPath.section];
    NSDate *cellDate = [self dateForCellAtIndexPath:indexPath];
    
    
    
    // Configure selections
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    
    
    NSTimeZone *gmt = [NSTimeZone localTimeZone];
    [dateFormatter setTimeZone:gmt];
    
    [dateFormatter setDateFormat:@"yyyy-MM-dd"];
    
    NSString *OWDT = [dateFormatter stringFromDate:self.prevOnwardDate];
    NSString *CalDate = [dateFormatter stringFromDate:cellDate];
    
    
    
    
    NSString *RETDT = [NSString new];
    
    if(self.isReturnSelected){
        RETDT = [dateFormatter stringFromDate:self.prevReturnDate];
    }
    
    NSDateComponents *cellDateComponents = [self.calendar components:kCalendarUnitYMD fromDate:cellDate];
    NSDateComponents *firstOfMonthsComponents = [self.calendar components:kCalendarUnitYMD fromDate:firstOfMonth];
    
    
    BOOL isToday = NO;
    BOOL isSelected = NO;
    //BOOL isCustomDate = NO;
    
    if(cellDateComponents.month == firstOfMonthsComponents.month){
        
        isSelected = ([self isSelectedDate:cellDate] && (indexPath.section == [self sectionForDate:cellDate]));
        isToday = [self isTodayDate:cellDate];
        [cell setDate:cellDate calendar:self.calendar];
        
        
        UInt64 randomFare = arc4random_uniform(9999);
        
        NSString *fare = [NSString stringWithFormat:@"%llu",randomFare];
        [cell setFare:fare];
        
        if (randomFare < 2000) {
            cell.fareLabel.font = [UIFont boldSystemFontOfSize:10];
        }else{
            cell.fareLabel.font = [UIFont systemFontOfSize:10];
            
        }
        
        
    }else{
        
        [cell setDate:nil calendar:nil];
        [cell setFare:nil];
    }
    
    if(isToday){
        
        
        if(self.prevOnwardPath == indexPath){
            
            cell.dayLabel.layer.cornerRadius = (46.0/2);
            [cell.dayLabel setBackgroundColor: Rgb2UIColorAlp(172, 24, 19, 255)];
            [cell.dayLabel setTextColor:[UIColor whiteColor]];
            [cell.fareLabel setTextColor:[UIColor whiteColor]];
            [cell setSelected:YES];
        }else{
            
            [cell setIsToday:isToday];
            cell.dayLabel.layer.cornerRadius = (46.0/2);
            self.todayIndexPath = indexPath;
            [cell.dayLabel setBackgroundColor: Rgb2UIColorAlp(0, 0, 0, 50)];
        }
    }
    
    
    if(isSelected){
        
        [cell setSelected:isSelected];
        
        cell.dayLabel.layer.cornerRadius = (46.0/2);
        
        if(self.isReturnSelected){
            
            if(self.prevReturnPath == self.prevOnwardPath){
                
                [cell setSelected:NO];
            }
            
            if(self.prevReturnPath == indexPath && !self.isReturn){
                
                [cell setSelected:NO];
                
            }
            
        }
        
        if(!self.isReturn && !self.isReturnSelected && self.prevReturnPath == indexPath){
            
            [cell setSelected:NO];
            
        }
        
    }
    
    if(!isReturn){
        
        [cell.contentView setBackgroundColor:[UIColor clearColor]];
    }
    
    if(!self.isReturnSelected){
        
        if([OWDT isEqualToString:CalDate]){
            
            [cell.dayLabel setBackgroundColor: Rgb2UIColorAlp(172, 24, 19, 255)];
            [cell.dayLabel setTextColor:[UIColor whiteColor]];
            [cell.fareLabel setTextColor:[UIColor whiteColor]];
            
        }
        
        if(isToday){
            
            
            if(self.prevOnwardPath == indexPath){
                
                [cell setSelected:YES];
                cell.dayLabel.layer.cornerRadius = (46.0/2);
                [cell.dayLabel setBackgroundColor: Rgb2UIColorAlp(172, 24, 19, 255)];
                [cell.dayLabel setTextColor:[UIColor whiteColor]];
                [cell.fareLabel setBackgroundColor:[UIColor clearColor]];
                [cell.fareLabel setTextColor:[UIColor whiteColor]];
            }else{
                
                [cell setIsToday:isToday];
                cell.dayLabel.layer.cornerRadius = (46.0/2);
                self.todayIndexPath = indexPath;
                [cell.dayLabel setBackgroundColor: Rgb2UIColorAlp(0, 0, 0, 50)];
                [cell.fareLabel setBackgroundColor:[UIColor clearColor]];
            }
            
        }
        
    }else{
        
        dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_BACKGROUND, 0), ^(void) {
            
            dispatch_async(dispatch_get_main_queue(), ^(void) {
                [self rangeSelectionToReturnDate];
            });
        });
    }
    
    // configure empty cell
    if([cell.dayLabel.text length] < 1){
        
        [cell setUserInteractionEnabled:NO];
        [cell.dayLabel setBackgroundColor:[cell circleDefaultColor]];
        
    }
    
    cell.layer.shouldRasterize = YES;
    cell.layer.rasterizationScale = [UIScreen mainScreen].scale;
    
    return cell;
}



-(void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath{
    
    NSDate *selectedDt = [self dateForCellAtIndexPath:indexPath];
    
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    
    NSTimeZone *gmt = [NSTimeZone localTimeZone];
    [dateFormatter setTimeZone:gmt];
    
    [dateFormatter setDateFormat:@"yyyy-MM-dd"];
    
    NSString * currentSelectedDt = [dateFormatter stringFromDate:selectedDt];
    
    NSUserDefaults *datePref = [NSUserDefaults standardUserDefaults];
    
    NSDate *todaysDate = [NSDate date];
    NSDateComponents *validateComponents = [[NSCalendar currentCalendar] components:NSCalendarUnitDay fromDate:todaysDate toDate:selectedDt options:0];
    NSInteger daysDiff = [validateComponents day];
    
    UICollectionViewCell *cell = [self.calendarView cellForItemAtIndexPath:indexPath];
    
    [cell setUserInteractionEnabled:YES];
    
    [cell setSelected:NO];
    
    if(isReturn){
        
        
        NSUserDefaults *datePref = [NSUserDefaults standardUserDefaults];
        NSString *lastOnwardDate = [datePref objectForKey:@"onwardDate"];
        
        NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
        
        NSTimeZone *gmt = [NSTimeZone localTimeZone];
        [dateFormatter setTimeZone:gmt];
        
        [dateFormatter setDateFormat:@"yyyy-MM-dd"];
        
        NSDate *onwardDate = [dateFormatter dateFromString:lastOnwardDate];
        NSDateComponents *validateReturnDate = [[NSCalendar currentCalendar] components:NSCalendarUnitDay fromDate:onwardDate toDate:selectedDt options:0];
        NSInteger diffReturnDay = [validateReturnDate day];
        
        if(diffReturnDay < 0){
            
            dispatch_async(dispatch_get_main_queue(), ^{
                
                [cell setSelected:NO];
                [self changeBGCOlor:cell];
                
            });
            
            UIAlertController *controller = [UIAlertController alertControllerWithTitle:@"Date Selection" message:@"Please select a valid Return Date" preferredStyle:UIAlertControllerStyleAlert];
            
            UIAlertAction *action = [UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
                
                dispatch_async(dispatch_get_main_queue(), ^{
                    [self.calendarView performBatchUpdates:^{
                        
                        [self.calendarView reloadData];
                        
                    } completion:^(BOOL finished) {}];
                    
                });
                
                
                
            }];
            
            [controller addAction:action];
            
            [self presentViewController:controller animated:YES completion:nil];
            
            return;
        }else{
            
            
            [cell setSelected:YES];
        }
        
        
        
        returnIndex = indexPath;
        
        self.currentSelectedDate = currentSelectedDt;
        [datePref setObject:self.currentSelectedDate forKey:@"returnDate"];
        
        [datePref synchronize];
        
        self.selectedDate = selectedDt;
        self.prevReturnDate = self.selectedDate;
        
        self.prevReturnPath = indexPath;
        [self setInitialDateForJourney];
        [self.calendarView reloadItemsAtIndexPaths:[self.calendarView indexPathsForVisibleItems]];
        
        
    }else{
        
        
        if(daysDiff < 0){
            
            dispatch_async(dispatch_get_main_queue(), ^{
                
                [cell setSelected:NO];
                
            });
            
            return;
        }else{
            
            if(isReturnSelected){
                
                NSDateComponents *validateReturnComponents = [[NSCalendar currentCalendar] components:NSCalendarUnitDay fromDate:selectedDt toDate:self.prevReturnDate options:0];
                NSInteger daysDiff = [validateReturnComponents day];
                
                if(daysDiff < 0){
                    
                    onwardIndex = indexPath;
                    
                    [datePref setObject:self.currentSelectedDate forKey:@"onwardDate"];
                    [datePref synchronize];
                    
                    self.selectedDate = selectedDt;
                    self.prevOnwardDate = self.selectedDate;
                    self.prevOnwardPath = indexPath;
                    
                    [self validateDatePref];
                    
                    [self changeOWDateString];
                    [self onTapReturnTrip:nil];
                    [self retSpring];
                    
                    
                }else{
                    
                    self.currentSelectedDate = currentSelectedDt;
                    [datePref setObject:self.currentSelectedDate forKey:@"onwardDate"];
                    [datePref synchronize];
                    
                    
                    self.selectedDate = selectedDt;
                    self.prevOnwardDate = self.selectedDate;
                    self.prevOnwardPath = indexPath;
                    
                    
                    [self onTapReturnTrip:nil];
                    [self retSpring];
                    [self changeOWDateString];
                    
                    [cell setSelected:NO];
                    
                    dispatch_async(dispatch_get_main_queue(), ^{
                        [self.calendarView performBatchUpdates:^{
                            
                            [self.calendarView reloadItemsAtIndexPaths:[self.calendarView indexPathsForVisibleItems]];
                            
                        } completion:^(BOOL finished) {}];
                        
                    });
                    
                    
                }
                
            }else{
                [self clearReturn];
                [cell setSelected:YES];
                
            }
            
        }
        
        [self.calendarView performBatchUpdates:^{
            
            [self.calendarView reloadItemsAtIndexPaths:[self.calendarView indexPathsForVisibleItems]];
            
        } completion:^(BOOL finished) {}];
        
        NSArray *viewArr = [cell.contentView subviews];
        
        for(id obj in viewArr){
            if([obj isKindOfClass:[UILabel class]]){
                UILabel *label = obj;
                if(label.text.length < 1){
                    [label setBackgroundColor:[UIColor clearColor]];
                }
            }
        }
        
        onwardIndex = indexPath;
        
        self.currentSelectedDate = currentSelectedDt;
        [datePref setObject:self.currentSelectedDate forKey:@"onwardDate"];
        [datePref synchronize];
        
        self.selectedDate = selectedDt;
        self.prevOnwardDate = self.selectedDate;
        self.prevOnwardPath = indexPath;
        
    }
    
    [self setInitialDateForJourney];
    
    if(isReturnSelected && isReturn){
        
        self.prevReturnPath = indexPath;
        
    }
    
    if(self.isReturnSelected){
        [self rangeSelectionToReturnDate];
    }
    
    
    if(!self.isReturnSelected){
        
        [self onDoneTap:nil];
    }
    
    
    [self updateDateText];
    
    
}


-(void)setInitialDateForJourney{
    
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    
    [dateFormatter setTimeZone:[NSTimeZone localTimeZone]];
    
    
    dateFormatter.dateFormat = @"MMMM";
    
    dateFormatter.dateFormat = @"EEEE";
    
    NSCalendar *calender = [NSCalendar autoupdatingCurrentCalendar];
    NSDateComponents *dtComponents = [calender components:(NSCalendarUnitYear|NSCalendarUnitMonth| NSCalendarUnitDay) fromDate:self.selectedDate];
    
    NSString *selectedDate = [NSString stringWithFormat:@"%ld",[dtComponents day]];
    
    
    if(isReturn){
        
        [txtReturnDate setText:[NSString stringWithFormat:@"%@", selectedDate]];
        
        
    }else{
        [txtOnwardDate setText:[NSString stringWithFormat:@"%@", selectedDate]];
    }
    
}



-(void)changeOWDateString{
    
    
    NSCalendar *calender = [NSCalendar autoupdatingCurrentCalendar];
    NSDateComponents *dtComponents = [calender components:(NSCalendarUnitYear|NSCalendarUnitMonth| NSCalendarUnitDay) fromDate:self.selectedDate];
    
    NSString *selectedDate = [NSString stringWithFormat:@"%ld",[dtComponents day]];
    
    
    [txtOnwardDate setText:[NSString stringWithFormat:@"%@", selectedDate]];
    
}


#pragma mark Multiple Date selection



-(void)calculateRangeCell{
    
    BOOL isReturnPath = NO;
    
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    
    NSTimeZone *gmt = [NSTimeZone localTimeZone];
    [dateFormatter setTimeZone:gmt];
    
    [dateFormatter setDateFormat:@"yyyy-MM-dd"];
    
    NSInteger section = [self numberOfSectionsInCollectionView:self.calendarView];
    
    NSString *B = [dateFormatter stringFromDate:self.prevOnwardDate];
    NSString *C = [dateFormatter stringFromDate:self.prevReturnDate];
    
    for(NSInteger i = 0; i < section; i++){
        
        NSInteger maxitem = [self.calendarView numberOfItemsInSection:i];
        
        for(NSInteger k = 0; k < maxitem; k++ ){
            
            NSIndexPath *path = [NSIndexPath indexPathForItem:k inSection:i];
            
            NSDate *cellDate = [self dateForCellAtIndexPath:path];
            
            NSString *A = [dateFormatter stringFromDate:cellDate];
            
            if([A isEqualToString:B] && !isReturnPath){
                
                self.prevOnwardPath = path;
                isReturnPath = YES;
            }
            
            if(isReturnSelected){
                
                if([A isEqualToString:C]){
                    self.prevReturnPath = path;
                }
            }
        }
        
    }
}


-(void)rangeSelectionToReturnDate{
    
    if(self.prevReturnPath.section > self.prevOnwardPath.section){
        
        
        NSInteger j = self.prevOnwardPath.item;
        
        for(NSInteger i = self.prevOnwardPath.section; i <= self.prevReturnPath.section;i++){
            
            NSInteger maxK = [self.calendarView numberOfItemsInSection:i];
            
            for(NSInteger k =j; k < maxK; k++){
                
                NSIndexPath *path = [NSIndexPath indexPathForItem:k inSection:i];
                
                [self performColorChangeOnCell:path];
                
                if(self.prevReturnPath.section == i && k == self.prevReturnPath.item){
                    
                    return;
                    
                }
                
            }
            j = 0;
            
        }
        
    }else{
        
        for(NSInteger i = self.prevOnwardPath.item;i <= self.prevReturnPath.item; i++){
            
            NSIndexPath *path = [NSIndexPath indexPathForItem:i inSection:self.prevOnwardPath.section];
            [self performColorChangeOnCell:path];
            
        }
        
    }
    
}

-(NSInteger)dateCompare:(NSDate*)date1 andDate2:(NSDate*)date2{
    
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"yyyy-MM-dd"];
    
    NSString *toString = [dateFormatter stringFromDate:date1];
    date1 = [dateFormatter dateFromString:toString];
    
    NSDateFormatter *dateFormatte = [[NSDateFormatter alloc] init];
    [dateFormatte setDateFormat:@"yyyy-MM-dd"];
    
    NSString *fromString = [dateFormatter stringFromDate:date2];
    date2 = [dateFormatte dateFromString:fromString];
    
    unsigned int unitFlags = NSCalendarUnitDay;
    
    NSCalendar *gregorian = [[NSCalendar alloc]initWithCalendarIdentifier:NSCalendarIdentifierGregorian];
    NSDateComponents *comps = [gregorian components:unitFlags fromDate:date1  toDate:date2  options:0];
    
    NSInteger days = [comps day];
    
    return days;
    
    
}

-(void)changeBGCOlor:(UICollectionViewCell *)cell {
    
    DateCell *dtCell = (DateCell *)cell;
    
    dtCell.dayLabel.backgroundColor = [UIColor clearColor];
    dtCell.dayLabel.textColor = [UIColor darkGrayColor];
    
}

-(void)performColorChangeOnCell:(NSIndexPath *)path{
    
    BOOL isStartCell = NO;
    BOOL isEndCell = NO;
    
    UICollectionViewCell *cell = [self.calendarView cellForItemAtIndexPath:path];
    
    
    DateCell *dtCell = (DateCell *)cell;
    
    
    if([dtCell.dayLabel.text length] > 0){
        
        if(self.isReturnSelected){
            
            
            if(self.prevOnwardPath == self.prevReturnPath){
                
                [dtCell.dayLabel setBackgroundColor:Rgb2UIColorAlp(172, 24, 19, 200)];
                dtCell.dayLabel.layer.cornerRadius = 42.0/2;
                [dtCell.dayLabel setTextColor:[UIColor whiteColor]];
                dtCell.dayLabel.layer.mask = nil;
                
                
            }else{
                
                dtCell.dayLabel.layer.cornerRadius = 0;
                
                if([self dateCompare:self.prevOnwardDate andDate2:dtCell.assignDate] == 0){
                    
                    
                    isStartCell = YES;
                    UIBezierPath *maskPath = [UIBezierPath
                                              bezierPathWithRoundedRect:dtCell.dayLabel.bounds
                                              byRoundingCorners:(UIRectCornerTopLeft | UIRectCornerBottomLeft)
                                              cornerRadii:CGSizeMake(20, 20)
                                              ];
                    
                    CAShapeLayer *maskLayer = [CAShapeLayer layer];
                    
                    maskLayer.frame = dtCell.dayLabel.bounds;
                    maskLayer.path = maskPath.CGPath;
                    
                    dtCell.dayLabel.layer.mask = maskLayer;
                    [dtCell.dayLabel setBackgroundColor:Rgb2UIColorAlp(172, 24, 19, 200)];
                    [dtCell.dayLabel setTextColor:[UIColor whiteColor]];
                    
                    [dtCell.fareLabel setBackgroundColor:[UIColor clearColor]];
                    [dtCell.fareLabel setTextColor:[UIColor whiteColor]];
                    
                }else if([self dateCompare:self.prevReturnDate  andDate2:dtCell.assignDate] == 0){
                    
                    isEndCell = YES;
                    UIBezierPath *maskPath = [UIBezierPath
                                              bezierPathWithRoundedRect:dtCell.dayLabel.bounds
                                              byRoundingCorners:(UIRectCornerTopRight | UIRectCornerBottomRight)
                                              cornerRadii:CGSizeMake(20, 20)
                                              ];
                    CAShapeLayer *maskLayer = [CAShapeLayer layer];
                    
                    maskLayer.frame = dtCell.dayLabel.bounds;
                    maskLayer.path = maskPath.CGPath;
                    
                    dtCell.dayLabel.layer.mask = maskLayer;
                    [dtCell.dayLabel setBackgroundColor:Rgb2UIColorAlp(172, 24, 19, 200)];
                    [dtCell.dayLabel setTextColor:[UIColor whiteColor]];
                    
                    [dtCell.fareLabel setBackgroundColor:[UIColor clearColor]];
                    [dtCell.fareLabel setTextColor:[UIColor whiteColor]];
                    
                    
                }else if([self dateCompare:self.prevOnwardDate  andDate2:dtCell.assignDate] > 0 && [self dateCompare:dtCell.assignDate andDate2:self.prevReturnDate] > 0){
                    
                    [dtCell.dayLabel setBackgroundColor:Rgb2UIColorAlp(172, 24, 19, 50)];
                    dtCell.dayLabel.layer.cornerRadius = 0;
                    dtCell.dayLabel.layer.mask = nil;
                    
                }
                
            }
            
        }else{
            
            
            if([self dateCompare:self.prevOnwardDate  andDate2:dtCell.assignDate] == 0){
                
                [dtCell.dayLabel setBackgroundColor:Rgb2UIColorAlp(172, 24, 19, 50)];
                dtCell.dayLabel.layer.cornerRadius = 42.0/2;
                dtCell.dayLabel.layer.mask = nil;
            }
            
        }
        
        
        
    }
    
    
}



-(UICollectionReusableView *)collectionView:(UICollectionView *)collectionView viewForSupplementaryElementOfKind:(NSString *)kind atIndexPath:(NSIndexPath *)indexPath{
    
    if(kind == UICollectionElementKindSectionHeader){
        
        CalHeader *headerView = [self.calendarView dequeueReusableSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:cellHeaderIdentifier forIndexPath:indexPath];
        
        
        NSDate *firstOfMonth = [self firstOfMonthForSection:indexPath.section];
        
        NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
        
        
        NSTimeZone *gmt = [NSTimeZone localTimeZone];
        [dateFormatter setTimeZone:gmt];
        
        [dateFormatter setDateFormat:@"LLLL"];
        
        NSString *currentMonth = [dateFormatter stringFromDate:firstOfMonth];
        
        
        headerView.titleLabel.text = currentMonth;
        
        headerView.layer.shouldRasterize = YES;
        headerView.layer.rasterizationScale = [UIScreen mainScreen].scale;
        
        
        return headerView;
        
    }
    return nil;
}



- (CGSize)collectionView:(UICollectionView *)collectionView
                  layout:(UICollectionViewLayout *)collectionViewLayout
  sizeForItemAtIndexPath:(NSIndexPath *)indexPath
{
    CGRect screenRect = [[UIScreen mainScreen] bounds];
    CGFloat screenWidth = screenRect.size.width;
    float cellWidth = screenWidth / 7.5;  // for iPhone
    CGSize size = CGSizeMake(cellWidth, cellWidth);
    
    return size;
}




@end



