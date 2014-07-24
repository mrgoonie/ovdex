//
//  PlaybackViewController.m
//  OVDexFlight
//
//  Created by Nguyen Goon on 4/24/14.
//  Copyright (c) 2014 Nguyen Goon. All rights reserved.
//

#import "PlaybackViewController.h"
#import "MapController.h"

@interface PlaybackViewController ()
{
    MapController* mapController;
}

@end

@implementation PlaybackViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    _step2.hidden = YES;
    
    _dateBtn.titleLabel.font = [UIFont fontWithName:@"Trim_Web_Light" size:20];
    _hourBtn.titleLabel.font = [UIFont fontWithName:@"Trim_Web_Light" size:20];
    _minBtn.titleLabel.font = [UIFont fontWithName:@"Trim_Web_Light" size:20];
    
    [_playBtn1 addTarget:self action:@selector(gotoStep2) forControlEvents:UIControlEventTouchUpInside];
    
    [_closeBtn addTarget:self action:@selector(hide) forControlEvents:UIControlEventTouchUpInside];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)gotoStep2
{
    _step1.hidden = YES;
    _step2.hidden = NO;
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

- (void)show
{
    _isShow = YES;
    self.view.hidden = NO;
    
    if([self.parentViewController isKindOfClass:[MapController class]]) {
        mapController = (MapController*)self.parentViewController;
    }
    
    CGRect f1 = self.view.frame;
    f1.origin.y = mapController.view.bounds.size.height - self.view.frame.size.height - 10;
    
    [UIView animateWithDuration:0.4
                          delay:0.2
                        options: UIViewAnimationOptionCurveEaseOut
                     animations:^{
                         self.view.frame = f1;
                     }
                     completion:^(BOOL finished){
                         NSLog(@"Show done!");
                         
                     }];
}

- (void)hide
{
    _isShow = NO;
    
    if([self.parentViewController isKindOfClass:[MapController class]]) {
        mapController = (MapController*)self.parentViewController;
    }
    
    CGRect frame = self.view.frame;
    frame.origin.y = mapController.view.bounds.size.height;
    
    [UIView animateWithDuration:0.4
                          delay:0.0
                        options: UIViewAnimationOptionCurveEaseIn
                     animations:^{
                         self.view.frame = frame;
                     }
                     completion:^(BOOL finished){
                         NSLog(@"Hide done!");
                         self.view.hidden = YES;
                         
                         [self willMoveToParentViewController:nil];
                         [self.view removeFromSuperview];
                         [self removeFromParentViewController];
                     }];
}

@end
