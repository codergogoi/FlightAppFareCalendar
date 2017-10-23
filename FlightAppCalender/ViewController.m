//
//  ViewController.m
//  FlightAppCalender
//
//  Created by MAC01 on 04/10/17.
//  Copyright © 2017 Jayanta Gogoi. All rights reserved.
//

#import "ViewController.h"
#import "CalendarViewController.h"

@interface ViewController () <CalendarDelegate>

@property(nonatomic,weak) IBOutlet UIButton *btnOnwardDate;
@property(nonatomic,weak) IBOutlet UIButton *btnReturnDate;

@end

@implementation ViewController


- (IBAction)btnreturnTap:(id)sender {
    
    [self showCalender:[self checkCalenderHostory:YES]];
}
- (IBAction)btnOnwardTap:(id)sender {
    
    [self showCalender:[self checkCalenderHostory:NO]];
    
}

-(void)showCalender:(NSDictionary *) dateHistory{
    
    UIStoryboard *sb = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
    
    CalendarViewController *cview = [sb instantiateViewControllerWithIdentifier:@"calender_view"];
    cview.calDelegate = self;
    cview.dateHistory = dateHistory;
    cview.modalPresentationStyle = UIModalPresentationOverFullScreen;
    [self presentViewController:cview animated:YES completion:nil];
    
}

-(NSDictionary *)checkCalenderHostory:(BOOL) isReturn{
    
    NSUserDefaults *datePref = [NSUserDefaults standardUserDefaults];
    NSDate * owDate = [NSDate new];
    NSDate * retDate = [NSDate new];
    
    NSMutableDictionary *dictionary = [NSMutableDictionary new];
    
    if([datePref objectForKey:@"owDate"] != nil){
        NSString *ownwarddate = [datePref objectForKey:@"owDate"];
        owDate = [self dateFromString:ownwarddate];
        [dictionary setObject:owDate forKey:@"owDate"];
    }
    
    if(isReturn){
        
        if([datePref objectForKey:@"retDate"] != nil){
            NSString *returnDate = [datePref objectForKey:@"retDate"];
            retDate = [self dateFromString:returnDate];
            [dictionary setObject:retDate forKey:@"retDate"];
            
        }
        [dictionary setObject:@"YES" forKey:@"isReturn"];
        
    }else{
        
        [dictionary setObject:@"NO" forKey:@"isReturn"];
        
    }
    
    return (NSDictionary *)dictionary;
    
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

//Calender Delegate Method

-(void)updateDateSelection{
    
    dispatch_async(dispatch_get_main_queue(), ^{
        
        NSUserDefaults *datePref = [NSUserDefaults standardUserDefaults];
        NSString *owndate = [datePref objectForKey:@"onwardDate"];
        
        NSString *retudate = [datePref objectForKey:@"returnDate"];
        
        
        [self.btnOnwardDate setTitle:owndate forState:UIControlStateNormal];
        
        
        if(retudate.length > 0){
            [self.btnReturnDate setTitle:retudate forState:UIControlStateNormal];
        }else{
            
            [self.btnReturnDate setTitle:@"Return Date" forState:UIControlStateNormal];
        }
        NSLog(@"OW Date: %@ : %@", owndate, retudate);
        
    });
    
    
}

//Format Date to indeed format
-(NSString *)stringFromDate:(NSDate *)date{
    
    NSDateFormatter *formatter =[[NSDateFormatter alloc] init];
    [formatter setDateFormat:@"yyyy'-'MM'-'dd"];;
    
    NSString *dateString = [formatter stringFromDate:date];
    
    return dateString;
}

-(NSDate *)dateFromString:(NSString *)date{
    
    NSDateFormatter *formatter =[[NSDateFormatter alloc] init];
    [formatter setDateFormat:@"yyyy'-'MM'-'dd"];;
    
    NSDate *dateString = [formatter dateFromString:date];
    
    return dateString;
}



@end
