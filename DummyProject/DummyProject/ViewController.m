//
//  ViewController.m
//  MSJSONDate
//
//  Created by coryallegory on 13-05-07.
//  Copyright (c) 2013 Cory Metcalfe. All rights reserved.
//

#import "ViewController.h"
#import "MSJSONDate.h"

@interface ViewController ()

@property (weak, nonatomic) IBOutlet UILabel *currentDateLabel;
@property (weak, nonatomic) IBOutlet UISwitch *timezoneSwitch;
@property (weak, nonatomic) IBOutlet UITextField *jsonDateField;
@property (weak, nonatomic) IBOutlet UILabel *convertedDateLabel;

@property (strong, nonatomic) NSDateFormatter *dateFormatter;
@property (strong, nonatomic) NSDate *currentDate;

- (IBAction)convertDateToJSON:(id)sender;
- (IBAction)convertJSONToDate:(id)sender;

- (void)tickTock:(NSTimer *)timer;

@end

@implementation ViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
	
    self.dateFormatter = [[NSDateFormatter alloc] init];
    self.dateFormatter.dateStyle = NSDateFormatterLongStyle;
    self.dateFormatter.timeStyle = NSDateFormatterLongStyle;
    
    [self tickTock:nil];
    [NSTimer scheduledTimerWithTimeInterval:1.0f target:self selector:@selector(tickTock:) userInfo:nil repeats:YES];
}

- (IBAction)convertDateToJSON:(id)sender
{
    NSString *jsonString;
    if ([self.timezoneSwitch isOn]) {
        jsonString = [self.currentDate jsonValueWithCurrentTimeZone];
    } else {
        jsonString = [self.currentDate jsonValue];
    }
    self.jsonDateField.text = jsonString;
}

- (IBAction)convertJSONToDate:(id)sender
{
    NSString *dateString;
    NSString *str = self.jsonDateField.text;
    if (str) {
        NSDate *date = [MSJSONDate dateWithJSON:str];
        if (date) {
            dateString = [self.dateFormatter stringFromDate:date];
        }
    }
    self.convertedDateLabel.text = dateString;
}

- (void)tickTock:(NSTimer *)timer
{
    self.currentDate = [NSDate date];
    self.currentDateLabel.text = [self.dateFormatter stringFromDate:self.currentDate];
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    [textField endEditing:YES];
    return YES;
}

@end
