//
//  TrackCount.m
//  OVDexFlight
//
//  Created by Nguyen Goon on 4/16/14.
//  Copyright (c) 2014 Nguyen Goon. All rights reserved.
//

#import "TrackCount.h"

@implementation TrackCount

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
        NSLog(@"-> Track count init with frame");
    }
    return self;
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect
{
    // Drawing code
}
*/

- (void)viewDidLoad
{
    NSLog(@"-> Track count view did load!");
    _trackLabel.font = [UIFont fontWithName:@"Trim_Web_Light" size:10];
    _trackNumber.font = [UIFont fontWithName:@"Trim_Web_Bold" size:13];
    _timeLabel.font = [UIFont fontWithName:@"Trim_Web_Bold" size:10];
    
    //_timeLabel.layer.borderColor = [UIColor colorWithRed:(0.0/255.0) green:(37.0/255.0) blue:(61.0/255.0) alpha:1].CGColor;
    //_timeLabel.layer.borderWidth = 2.0;
    
    [self updateDateAndTime];
    
    [NSTimer scheduledTimerWithTimeInterval: 60.0
                                     target: self
                                   selector: @selector(updateDateAndTime)
                                   userInfo: nil
                                    repeats: YES];
}

- (void)setTrack:(NSInteger)total
{
    [_trackNumber setText:[NSString stringWithFormat:@"0 OF %ld", (long)total]];
}

- (void)setAvailableFlight:(NSInteger)current inTotal:(NSInteger)total
{
    [_trackNumber setText:[NSString stringWithFormat:@"%ld OF %ld", (long)current, (long)total]];
}

- (void)updateDateAndTime
{
    NSDate *currDate = [NSDate date];
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc]init];
    //[dateFormatter setDateFormat:@"MM.dd.YY HH:mm:ss"];
    [dateFormatter setDateFormat:@"EEEE, MMMM dd,YYYY - HH:mm"];
    NSString *dateString = [dateFormatter stringFromDate:currDate];
    
    _timeLabel.text = dateString;
    
    NSLog(@"%@",dateString);
}

- (id)initWithCoder:(NSCoder *)aDecoder {
    if(self = [super initWithCoder:aDecoder]) {
        //init code...
        NSLog(@"-> Track count init with code!");
        
    }
    return self;
}

@end
