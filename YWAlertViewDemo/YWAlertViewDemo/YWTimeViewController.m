//
//  YWTimeViewController.m
//  YWAlertViewDemo
//
//  Created by yaowei on 2018/11/28.
//  Copyright © 2018 yaowei. All rights reserved.
//

#import "YWTimeViewController.h"
#import "NSDate+YW.h"

@interface YWTimeViewController ()
@property (weak, nonatomic) IBOutlet UILabel *yesterdayLabel;
@property (weak, nonatomic) IBOutlet UITextField *dayNum;
@property (weak, nonatomic) IBOutlet UILabel *dayLabel;

@property (weak, nonatomic) IBOutlet UILabel *monthLastDataLabel;
@property (weak, nonatomic) IBOutlet UILabel *quarterLasrDateLabel;

@property (weak, nonatomic) IBOutlet UILabel *timeLabel;
@property (weak, nonatomic) IBOutlet UILabel *dateLabel;
@property (weak, nonatomic) IBOutlet UILabel *afterDateLabel;
@property (weak, nonatomic) IBOutlet UITextField *numDayTF;
@end

@implementation YWTimeViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    


    self.yesterdayLabel.text = [NSString stringWithFormat:@"昨天日期 %@",[NSDate getDateOfYesterday]];
    self.monthLastDataLabel.text = [NSString stringWithFormat:@"本月最后一天的日期 %@",[NSDate getDateOfThisMonth]];
    self.quarterLasrDateLabel.text = [NSString stringWithFormat:@"本季度最后一天的日期 %@",[NSDate getTheDateOfTheLastDayOfTheQuarter]];

    self.dateLabel.text = [NSString stringWithFormat:@"当前日期 %@",[NSDate getDateOfNow]];
    self.timeLabel.text = [NSString stringWithFormat:@"当前时间戳 %lld",(long long)[NSDate getNowTimeInterval]];
    
    NSLog(@"当前月份共有%zi天",[[NSDate date] days]);
    
}

- (IBAction)tranFormAction:(id)sender {
    [self.dayNum endEditing:YES];
    self.dayLabel.text = [NSString stringWithFormat:@"日期:%@",[NSDate getTheDateBeforeSomeday:nil day:[self.dayNum.text integerValue]]];
}
- (IBAction)tranFormActionAfter:(id)sender {
    [self.numDayTF endEditing:YES];
    self.afterDateLabel.text = [NSString stringWithFormat:@"日期:%@",[NSDate getTheDateAfterSomeday:nil day:[self.numDayTF.text integerValue]]];
}
@end
